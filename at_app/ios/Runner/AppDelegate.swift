import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

  // Native silent loop — independent of the Dart/Flutter stack.
  // Keeps AVAudioSession active even when flutter_tts or just_audio
  // calls setActive(false), which they do after each utterance/playback.
  private var nativeSilentPlayer: AVAudioPlayer?

  // Periodic timer that re-asserts setActive(true) and restarts the native
  // silent player if it has stopped. Runs entirely in Swift — fires even
  // when the Dart isolate is paused.
  private var keepAliveTimer: Timer?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    configureAudioSession()

    // Session recovery after phone-call / Siri interruptions.
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleAudioInterruption(_:)),
      name: AVAudioSession.interruptionNotification,
      object: AVAudioSession.sharedInstance()
    )

    // Full reset if media services are lost (rare).
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleMediaServicesReset(_:)),
      name: AVAudioSession.mediaServicesWereResetNotification,
      object: nil
    )

    // Start native keepalive when screen locks / app backgrounds.
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(appDidEnterBackground),
      name: UIApplication.didEnterBackgroundNotification,
      object: nil
    )

    // Stop keepalive overhead when back in foreground.
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(appWillEnterForeground),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  // MARK: - Audio Session

  private func configureAudioSession() {
    do {
      // mixWithOthers only — no duckOthers here.
      // Ducking is scoped to individual prompt deliveries on the Dart side
      // (_duckForPrompt / _restoreMix in audio_service.dart). Setting duckOthers
      // permanently causes the silent keepalive loop to suppress other audio
      // (e.g. Spotify) for the entire session, not just during prompts.
      try AVAudioSession.sharedInstance().setCategory(
        .playback,
        mode: .default,
        options: [.mixWithOthers]
      )
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("AVAudioSession setup failed: \(error)")
    }
  }

  @objc private func handleAudioInterruption(_ notification: Notification) {
    guard
      let info = notification.userInfo,
      let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
      let type = AVAudioSession.InterruptionType(rawValue: typeValue)
    else { return }

    if type == .ended {
      try? AVAudioSession.sharedInstance().setActive(true)
      nativeSilentPlayer?.play()
    }
  }

  @objc private func handleMediaServicesReset(_ notification: Notification) {
    configureAudioSession()
    startNativeSilentLoop()
  }

  // MARK: - App Lifecycle

  @objc private func appDidEnterBackground() {
    startNativeSilentLoop()
    startKeepAliveTimer()
  }

  @objc private func appWillEnterForeground() {
    // Keep the loop running — Dart-side loop takes over naturally.
    // Stop the aggressive keepalive timer (not needed in foreground).
    stopKeepAliveTimer()
  }

  // MARK: - Native Silent Loop

  /// Plays a near-inaudible 30-second loop from the iOS bundle.
  /// This is completely independent of the Dart/Flutter/just_audio stack —
  /// flutter_tts calling setActive(false) on the shared session pauses
  /// the Dart-side just_audio player, but our keepAliveTimer detects
  /// this and restarts both the session and this native player within 3s.
  private func startNativeSilentLoop() {
    guard nativeSilentPlayer == nil || !(nativeSilentPlayer?.isPlaying ?? false) else { return }
    guard let url = Bundle.main.url(forResource: "near_silent_native", withExtension: "caf") else {
      print("near_silent_native.caf not found in bundle")
      return
    }
    do {
      nativeSilentPlayer = try AVAudioPlayer(contentsOf: url)
      nativeSilentPlayer?.numberOfLoops = -1  // infinite
      nativeSilentPlayer?.volume = 0.05
      nativeSilentPlayer?.prepareToPlay()
      nativeSilentPlayer?.play()
    } catch {
      print("Native silent player failed: \(error)")
    }
  }

  // MARK: - Keepalive Timer

  private func startKeepAliveTimer() {
    keepAliveTimer?.invalidate()
    let timer = Timer(timeInterval: 3.0, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      // Re-assert the session — counteracts flutter_tts calling setActive(false).
      try? AVAudioSession.sharedInstance().setActive(true)
      // Restart native loop if it stopped due to session deactivation.
      if !(self.nativeSilentPlayer?.isPlaying ?? false) {
        self.nativeSilentPlayer?.play()
      }
    }
    // .common mode ensures the timer fires even when the run loop is
    // processing touches or other events.
    RunLoop.main.add(timer, forMode: .common)
    keepAliveTimer = timer
  }

  private func stopKeepAliveTimer() {
    keepAliveTimer?.invalidate()
    keepAliveTimer = nil
  }
}

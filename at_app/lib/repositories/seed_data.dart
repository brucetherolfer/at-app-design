import 'package:uuid/uuid.dart';
import '../models/library.dart';
import '../models/prompt.dart';
import '../models/sequence.dart';

const _uuid = Uuid();

// ── Libraries ──────────────────────────────────────────────────────────────

Library get allPromptsLibrary => Library()
  ..uid = 'builtin_all'
  ..name = 'All Prompts'
  ..isBuiltIn = true
  ..sortOrder = 0
  ..createdAt = DateTime(2024);

Library get brucesLibrary => Library()
  ..uid = 'builtin_bruces'
  ..name = "Bruce's Prompts"
  ..isBuiltIn = true
  ..sortOrder = 1
  ..createdAt = DateTime(2024);

Library get mioLibrary => Library()
  ..uid = 'builtin_mio'
  ..name = 'MIO Prompts'
  ..isBuiltIn = true
  ..sortOrder = 2
  ..createdAt = DateTime(2024);

// ── MIO 9 prompts ──────────────────────────────────────────────────────────

List<Prompt> get mioPrompts {
  final texts = [
    'Notice where you are holding tension right now.',
    'Allow your neck to be free.',
    'Let your head balance lightly on top of your spine.',
    'Allow your back to lengthen and widen.',
    'Let your knees release forward and away.',
    'Feel the ground supporting you.',
    'Soften your eyes and jaw.',
    'Allow your breathing to be easy.',
    'Pause — and begin again with fresh attention.',
  ];
  return texts.asMap().entries.map((e) {
    return Prompt()
      ..uid = _uuid.v4()
      ..text = e.value
      ..libraryUid = 'builtin_mio'
      ..sortOrder = e.key
      ..isBuiltIn = true
      ..createdAt = DateTime(2024);
  }).toList();
}

// ── Bruce's 23 prompts ─────────────────────────────────────────────────────

List<Prompt> get brucesPrompts {
  final texts = [
    'Allow your neck to be free so that your head can go forward and up.',
    'Let your back lengthen and widen.',
    'Notice the contact of your feet with the floor.',
    'Allow your knees to release forward and away.',
    'Let your shoulders release out to the sides.',
    'Soften the muscles around your eyes.',
    'Allow your jaw to release.',
    'Notice any unnecessary effort and let it go.',
    'Let your breath come and go without interference.',
    'Allow your whole torso to lengthen upward.',
    'Notice the weight of your head — and allow it to float.',
    'Let your hips release and widen.',
    'Allow your arms to hang freely from your shoulder joints.',
    'Notice the space behind you as well as in front.',
    'Let your ribs move freely with each breath.',
    'Allow your ankles to be free.',
    'Notice the relationship between your head, neck, and back.',
    'Let unnecessary holding in your chest release.',
    'Allow your whole body to be supported by the ground.',
    'Notice what is happening in your hands right now.',
    'Let your lower back release and lengthen.',
    'Allow your gaze to soften and widen.',
    'Take a moment to inhibit — and then choose your direction.',
  ];
  return texts.asMap().entries.map((e) {
    return Prompt()
      ..uid = _uuid.v4()
      ..text = e.value
      ..libraryUid = 'builtin_bruces'
      ..sortOrder = e.key
      ..isBuiltIn = true
      ..createdAt = DateTime(2024);
  }).toList();
}

// ── All Prompts (200) ──────────────────────────────────────────────────────
// Full set of AT awareness prompts. Sourced from Alexander Technique tradition.

List<Prompt> get allPrompts {
  final texts = [
    // Primary Control & Core Directions
    'Allow your neck to be free.',
    'Let your head go forward and up.',
    'Allow your back to lengthen.',
    'Allow your back to widen.',
    'Let your back lengthen and widen.',
    'Allow your neck to be free so that your head can go forward and up, and your back can lengthen and widen.',
    'Notice the relationship between your head and your spine.',
    'Allow your head to float upward from your spine.',
    'Let the back of your neck be long.',
    'Allow your head to balance lightly on top of your spine.',
    // Sitting awareness
    'Notice how you are sitting right now.',
    'Allow your sitting bones to release downward into the chair.',
    'Let your spine lengthen upward from your sitting bones.',
    'Notice if you are gripping anywhere while sitting.',
    'Allow your hips to widen on the chair.',
    'Let your feet rest flat on the floor.',
    'Notice the contact of your thighs with the seat.',
    'Allow your lower back to lengthen.',
    'Let your chest be open and easy.',
    'Notice if you are leaning to one side.',
    // Standing awareness
    'Notice how you are standing right now.',
    'Allow your weight to be evenly distributed on both feet.',
    'Let your knees release — not locked, not bent.',
    'Notice the tripod of each foot on the ground.',
    'Allow your ankles to be free and easy.',
    'Let your hips be level.',
    'Notice the length of your spine in standing.',
    'Allow your whole body to be supported by the ground.',
    'Let your centre of gravity drop.',
    'Notice the space between your ears and your shoulders.',
    // Walking awareness
    'Notice how you are walking right now.',
    'Allow your head to lead the movement.',
    'Let each step be a fall and a catch.',
    'Notice how your arms move as you walk.',
    'Allow your gaze to be forward and wide.',
    'Let your pelvis release as you walk.',
    'Notice the rhythm of your footfall.',
    'Allow ease in your movement.',
    'Let your shoulders stay wide as you walk.',
    'Notice if you are rushing or straining.',
    // Breathing
    'Allow your breath to come and go without interference.',
    'Notice the movement of your ribs as you breathe.',
    'Let your belly be soft.',
    'Allow your back to breathe.',
    'Notice if you are holding your breath.',
    'Let the out-breath be complete before the next in-breath.',
    'Allow the breath to breathe you.',
    'Notice the rhythm of your breathing right now.',
    'Let your collarbone move freely with your breath.',
    'Allow your entire torso to participate in breathing.',
    // Eyes & Face
    'Soften your eyes.',
    'Allow your gaze to widen.',
    'Let your forehead smooth.',
    'Notice any tension around your eyes.',
    'Allow your jaw to release.',
    'Let your tongue rest gently in your mouth.',
    'Notice the muscles around your mouth.',
    'Allow your face to be easy.',
    'Let your eyes look without effort.',
    'Notice the space around you as you look.',
    // Hands & Arms
    'Notice what your hands are doing right now.',
    'Allow your fingers to uncurl.',
    'Let your wrists be free.',
    'Notice any gripping in your hands.',
    'Allow your arms to hang from your shoulder joints.',
    'Let your elbows be soft.',
    'Notice the weight of your arms.',
    'Allow your shoulders to release downward and outward.',
    'Let your shoulder blades slide down your back.',
    'Notice if you are pulling your shoulders forward.',
    // Feet & Legs
    'Notice the contact of your feet with the ground.',
    'Allow your toes to spread.',
    'Let your arches lift gently.',
    'Notice any gripping in your feet.',
    'Allow your calves to be soft.',
    'Let your knees track over your toes.',
    'Notice the length of your legs.',
    'Allow your hip joints to be free.',
    'Let your inner thighs release.',
    'Notice the connection from your feet to your head.',
    // Inhibition
    'Before you move — pause.',
    'Notice the impulse to do — and wait.',
    'Allow a moment of non-doing.',
    'What would happen if you did less?',
    'Notice the habit — and choose differently.',
    'Allow the pause between stimulus and response.',
    'Let the doing wait for a moment.',
    'Notice what you are about to do — and do nothing for now.',
    'Inhibit the habitual response.',
    'Allow yourself not to know what comes next.',
    // Direction
    'Send your awareness to the top of your head.',
    'Allow your whole self to lengthen upward.',
    'Direct your back to widen.',
    'Allow your knees to go forward and away from your hips.',
    'Direct your elbows away from each other.',
    'Allow your head to lead, your body to follow.',
    'Direct your gaze to the horizon.',
    'Allow expansion in all directions.',
    'Direct your attention to the present moment.',
    'Allow your intentions to guide you lightly.',
    // General body awareness
    'Do a quick scan — where is there unnecessary tension?',
    'Notice the overall quality of your use right now.',
    'Allow whatever needs to release to release.',
    'Notice the relationship between ease and effort.',
    'Allow your body to be the size it is.',
    'Notice what is comfortable right now.',
    'Allow your posture to be dynamic, not fixed.',
    'Notice the alive quality of your body.',
    'Allow movement to be possible in any direction.',
    'Notice the intelligence in your body.',
    // Emotional & mental tone
    'Notice the quality of your attention right now.',
    'Allow your mind to settle.',
    'Let go of the last moment.',
    'Notice if you are bracing for the next moment.',
    'Allow a sense of ease and spaciousness.',
    'Notice what is actually happening, not what you fear.',
    'Allow your nervous system to calm.',
    'Let your thoughts pass like clouds.',
    'Notice the quality of the present moment.',
    'Allow kindness toward your own use.',
    // Hands-on / lesson reminders
    'Remember a moment of lightness and allow it now.',
    'Notice when you begin to tighten — and stop.',
    'Allow the chair to support you completely.',
    'Let the floor take your full weight.',
    'Notice the support beneath you.',
    'Allow your body to trust the support.',
    'Let your joints be oiled and easy.',
    'Notice how little effort is actually required.',
    'Allow the body to be surprised by ease.',
    'Let it be simpler than you think.',
    // Voice & speaking
    'Allow your throat to be open and free.',
    'Let your voice come from your whole body.',
    'Notice if you are tightening to speak.',
    'Allow your breath to power your voice.',
    'Let your lips and tongue be nimble and free.',
    'Notice the resonance of your voice.',
    'Allow your speaking to be effortless.',
    'Let each word have space around it.',
    'Notice if you are holding your breath before speaking.',
    'Allow your voice to carry without pushing.',
    // Computer / desk work
    'Notice how you are holding your arms at the keyboard.',
    'Allow your wrists to be level.',
    'Let your screen be at eye level.',
    'Notice if you are reaching forward with your head.',
    'Allow your back to be supported.',
    'Let your shoulders not hold up the ceiling.',
    'Notice the distance between your eyes and the screen.',
    'Allow regular pauses from screen work.',
    'Let your eyes rest by looking into the distance.',
    'Notice the overall quality of your setup.',
    // Movement transitions
    'Before you stand — notice how you plan to do it.',
    'Allow the movement to be initiated from your head.',
    'Let sitting-to-standing be easy.',
    'Notice any bracing as you prepare to move.',
    'Allow the transition to be smooth and uncontrived.',
    'Let your head lead as you bend forward.',
    'Notice the moment between intention and action.',
    'Allow movements to be complete before the next one.',
    'Let reaching be from your whole arm, not just your hand.',
    'Notice how you return to stillness after movement.',
    // Advanced / integration
    'Allow primary control to organise your whole self.',
    'Notice the reciprocal relationship of your parts.',
    'Allow the directions to work together simultaneously.',
    'Let the means whereby be your guide.',
    'Notice the unity of your psycho-physical self.',
    'Allow your use to improve in all activities.',
    'Let inhibition come first, direction follow.',
    'Notice the way your thinking affects your body.',
    'Allow a constructive conscious awareness.',
    'Let the work of the lesson carry through your day.',
    // Closing / settling
    'Take a moment to notice where you are.',
    'Allow a sense of appreciation for this pause.',
    'Let your body settle into the present.',
    'Notice the quiet intelligence available to you.',
    'Allow this moment to be enough.',
    'Let yourself arrive in your own body.',
    'Notice the stillness available beneath the activity.',
    'Allow your whole self to be here.',
    'Let this be a moment of genuine rest.',
    'Notice — and allow — and begin again.',
    // Additional prompts to reach 200
    'Allow your pelvis to be neutral.',
    'Let your tailbone release downward.',
    'Notice the curve of your lower back.',
    'Allow your thoracic spine to lengthen.',
    'Let your sternum be free and easy.',
    'Notice the space between your vertebrae.',
    'Allow your cranium to be light.',
    'Let your atlas and axis be free.',
    'Notice the tone of your muscles — not too much, not too little.',
    'Allow proprioception to guide you.',
    'Let your eyes lead and your head follow.',
    'Notice the horizon and let your spine lengthen toward the sky.',
    'Allow the top of your head to move away from your heels.',
    'Let gravity be your ally.',
    'Notice how you use yourself in this moment.',
    'Allow your body to make its own adjustments.',
    'Let your nervous system do its work.',
    'Notice the quality of ease in your movement.',
    'Allow release without collapse.',
    'Let length without tension guide you.',
  ];
  return texts.asMap().entries.map((e) {
    return Prompt()
      ..uid = _uuid.v4()
      ..text = e.value
      ..libraryUid = 'builtin_all'
      ..sortOrder = e.key
      ..isBuiltIn = true
      ..createdAt = DateTime(2024);
  }).toList();
}

// ── Built-in Sequences ─────────────────────────────────────────────────────

Sequence get primaryControlSequence {
  // Placeholder prompt UIDs — will be replaced with real prompt UIDs after seeding
  return Sequence()
    ..uid = 'builtin_seq_primary_control'
    ..name = 'Primary Control'
    ..promptUids = [] // populated during seeding from allPrompts
    ..gapSeconds = 2
    ..isBuiltIn = true
    ..createdAt = DateTime(2024);
}

Sequence get bodyScanSequence {
  return Sequence()
    ..uid = 'builtin_seq_body_scan'
    ..name = 'Body Scan'
    ..promptUids = []
    ..gapSeconds = 2
    ..isBuiltIn = true
    ..createdAt = DateTime(2024);
}

Sequence get preActivitySequence {
  return Sequence()
    ..uid = 'builtin_seq_pre_activity'
    ..name = 'Pre-Activity'
    ..promptUids = []
    ..gapSeconds = 2
    ..isBuiltIn = true
    ..createdAt = DateTime(2024);
}

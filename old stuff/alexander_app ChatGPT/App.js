import React, { useState, useEffect } from 'react';
import { View, Text, Button, StyleSheet, ScrollView } from 'react-native';
import * as Notifications from 'expo-notifications';
import * as Device from 'expo-device';

/*
 * This simple React Native application uses Expo to deliver random Alexander Technique
 * prompts via local notifications and provides a screen for longer lesson content.
 *
 * On first launch the app asks for notification permissions. Press the
 * "Schedule Random Prompts" button to schedule a handful of notifications for the
 * remainder of the current day. Each notification is drawn randomly from the
 * prompts array defined below. The "Go to Lessons" button opens a scrollable
 * lessons page containing basic Alexander Technique guidance drawn from
 * published sources【211788931891446†L96-L110】【211788931891446†L111-L122】. You can return
 * to the home screen using the button at the bottom of the lessons page.
 */

/**
 * Request notification permissions from the user.
 */
async function requestPermissions() {
  // On iOS you must explicitly request permission to display notifications.
  // On Android this resolves immediately.
  const { status } = await Notifications.requestPermissionsAsync();
  return status;
}

/**
 * Schedules a number of random notifications for the current day.
 *
 * @param {Array} prompts List of prompt objects with title and body
 * @param {number} count Number of notifications to schedule
 */
async function scheduleRandomNotifications(prompts, count = 5) {
  // Define a window for notifications: between 09:00 and 21:00 today.
  const now = new Date();
  const start = new Date(now);
  start.setHours(9, 0, 0, 0);
  const end = new Date(now);
  end.setHours(21, 0, 0, 0);

  for (let i = 0; i < count; i++) {
    // Choose a random moment within the window.
    const randomTime = new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
    // Pick a random prompt from the list.
    const randomPrompt = prompts[Math.floor(Math.random() * prompts.length)];
    await Notifications.scheduleNotificationAsync({
      content: {
        title: randomPrompt.title,
        body: randomPrompt.body,
        data: { type: 'prompt' },
      },
      trigger: randomTime,
    });
  }
}

export default function App() {
  // Track which screen we're on: 'home' or 'lessons'.
  const [screen, setScreen] = useState('home');

  // Define the prompts used for notifications. Each entry contains a title and body.
  const prompts = [
    {
      title: 'Mindful Body Awareness',
      body: 'Take a brief moment to notice tension or misalignment in your body.',
    },
    {
      title: 'Lengthen Your Spine',
      body: 'Let your neck be free and let your head go forward and up.',
    },
    {
      title: 'Sitting with Awareness',
      body: 'Use your sit‑bones for support and maintain poise as you sit down.',
    },
    {
      title: 'Movement Break',
      body: 'Posture is a dynamic movement – take a movement break to release tension.',
    },
    {
      title: 'Ergonomics',
      body: 'Raise your phone or laptop to eye level and avoid hunching.',
    },
    {
      title: 'Posture Check‑In',
      body: 'Check in with your posture, release tension and re‑establish balance.',
    },
  ];

  // Ask for notification permissions and set a default handler when the component mounts.
  useEffect(() => {
    requestPermissions();
    Notifications.setNotificationHandler({
      handleNotification: async () => ({
        shouldShowAlert: true,
        shouldPlaySound: false,
        shouldSetBadge: false,
      }),
    });
  }, []);

  return (
    <View style={styles.container}>
      {screen === 'home' ? (
        // Home screen with buttons to schedule notifications and navigate to lessons
        <View style={styles.container}>
          <Text style={styles.heading}>Alexander Technique Prompts</Text>
          <Button
            title="Schedule Random Prompts"
            onPress={() => scheduleRandomNotifications(prompts, 5)}
          />
          <Button title="Go to Lessons" onPress={() => setScreen('lessons')} />
        </View>
      ) : (
        // Lessons screen with explanatory text and citations
        <ScrollView style={styles.container}>
          <Text style={styles.heading}>Alexander Technique Lessons</Text>
          <Text style={styles.paragraph}>
            The Alexander Technique helps you develop awareness of posture and movement. This
            section provides longer lessons based on published guidance. Each section below
            cites information from a reliable source to help you practice.
          </Text>
          <Text style={styles.lessonHeading}>Mindful Body Awareness</Text>
          <Text style={styles.paragraph}>
            Throughout your day, take brief moments to tune into your body. Notice any
            areas of tension, slumping or misalignment. Simply acknowledging these patterns
            sets the foundation for change【211788931891446†L96-L100】.
          </Text>
          <Text style={styles.lessonHeading}>Lengthen Your Spine</Text>
          <Text style={styles.paragraph}>
            Allow your neck muscles to release and let your head rotate forward and up at
            the atlanto‑occipital joint. The traditional reminder in the Alexander
            Technique is to “let your neck be free, to let your head go forward and up.”
            This simple adjustment can significantly improve your posture【211788931891446†L102-L110】.
          </Text>
          <Text style={styles.lessonHeading}>Sitting with Awareness</Text>
          <Text style={styles.paragraph}>
            When sitting, use the bony part of your pelvis (sit‑bones) to support you. As
            you make your way to the chair, think of a gentle squat until the chair
            naturally halts your movement. Maintain poise and pivot from the hip joints
            while keeping pressure off the tailbone【211788931891446†L111-L122】.
          </Text>
          <Text style={styles.lessonHeading}>Movement Breaks</Text>
          <Text style={styles.paragraph}>
            Posture is not a position to hold—it’s a dynamic balancing act. Take regular
            movement breaks to release tension and increase blood circulation【211788931891446†L140-L144】.
          </Text>
          <Text style={styles.lessonHeading}>Ergonomics and Devices</Text>
          <Text style={styles.paragraph}>
            Optimize your workstation by raising screens to eye level and keeping your
            keyboard and mouse within comfortable reach. Avoid hunching over your phone or
            laptop by using a stand. These adjustments encourage a more neutral and
            relaxed posture【211788931891446†L145-L150】.
          </Text>
          <Text style={styles.lessonHeading}>Mindful Posture Check‑Ins</Text>
          <Text style={styles.paragraph}>
            Set reminders throughout your day to check in with your posture. Take a moment
            to consciously adjust your posture (“head forward and up”), release tension
            and re‑establish a balanced dynamic【211788931891446†L155-L159】.
          </Text>
          <Button title="Back to Home" onPress={() => setScreen('home')} />
        </ScrollView>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 24,
    backgroundColor: '#fff',
  },
  heading: {
    fontSize: 24,
    marginBottom: 16,
    fontWeight: 'bold',
  },
  lessonHeading: {
    fontSize: 20,
    marginTop: 16,
    marginBottom: 8,
    fontWeight: '600',
  },
  paragraph: {
    fontSize: 16,
    marginBottom: 8,
    lineHeight: 20,
  },
});
// AT Reminders - Full direction prompt, today only, every 2.5 min
// Scriptable (iOS) — clears existing AT reminders, creates for TODAY only

const prompt = "Let your neck be free, so your head can go forward and up, so your back can lengthen, and your arms and legs can lengthen out your elbows, knees, toes, and fingers.";

const cal = await Calendar.forReminders();
const reminderCal = cal.find(c => c.title === "Alexander Technique") || cal[0];

// --- Clear ALL existing reminders in the Alexander Technique list ---
const existing = await Reminder.all([reminderCal]);
for (const r of existing) {
  r.remove();
}

// --- Build reminders for TODAY only ---
const today = new Date();
const startOfToday = new Date(today);
startOfToday.setHours(0, 0, 0, 0);

const nowMinutes = today.getHours() * 60 + today.getMinutes() + 5;

let totalCount = 0;

// Step every 2.5 minutes from 7:00 AM to 9:00 PM
for (let m = 7 * 60; m < 21 * 60; m += 2.5) {
  if (m < nowMinutes) continue;

  const totalSecs = Math.round(m * 60);
  const h = Math.floor(totalSecs / 3600);
  const min = Math.floor((totalSecs % 3600) / 60);
  const sec = totalSecs % 60;

  const r = new Reminder();
  r.title = prompt;
  r.calendar = reminderCal;
  const d = new Date(startOfToday);
  d.setHours(h, min, sec, 0);
  r.dueDate = d;
  r.dueDateIncludesTime = true;
  await r.save();
  totalCount++;
}

Script.setShortcutOutput("Created " + totalCount + " reminders!");
QuickLook.present("Done! " + totalCount + " reminders for today (every 2.5 min):\n\"" + prompt + "\"");

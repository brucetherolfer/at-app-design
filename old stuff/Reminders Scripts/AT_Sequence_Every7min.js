// AT Reminders - Full directions sequence, every 7 minutes
// Each cycle fires 4 reminders spaced 5 seconds apart:
//   +0s  "Let your neck be free..."
//   +5s  "...so your head can go forward and up..."
//   +10s "...so your back can lengthen..."
//   +15s "...so your legs and arms can lengthen out of your fingers and toes."
//
// NOTE: iOS Reminders supports second-level precision via Scriptable, and the app
// will surface all four notifications — but iOS may batch very close notifications
// together in the lock screen. They will still fire correctly; you may see them
// grouped rather than staggered if your screen is off. Works best with Reminders
// notifications set to "Immediate delivery" in Settings → Notifications → Reminders.
//
// Scriptable (iOS) — clears existing AT reminders, creates from TODAY through this Sunday

const sequence = [
  "Let your neck be free...",
  "...so your head can go forward and up...",
  "...so your back can lengthen...",
  "...so your legs and arms can lengthen out of your fingers and toes."
];

const intervalMinutes = 7;      // minutes between each sequence start
const stepSeconds     = 5;      // seconds between each phrase in the sequence

const blackout = {
  1: [[540,810]],
  2: [[540,1080]],
  3: [[900,1170]],
  4: [[540,810]],
  5: [[540,720],[900,1080]]
};

function isBlocked(dow, min) {
  return (blackout[dow]||[]).some(([s,e]) => min >= s && min < e);
}

const cal = await Calendar.forReminders();
const reminderCal = cal.find(c => c.title === "Alexander Technique") || cal[0];

// --- Replace existing reminders ---
const existing = await Reminder.all([reminderCal]);
for (const r of existing) {
  r.remove();
}

// --- Build from TODAY through this Sunday ---
const today = new Date();
const startOfToday = new Date(today);
startOfToday.setHours(0, 0, 0, 0);

const nowMinutes = today.getHours() * 60 + today.getMinutes() + 5;

const todayDow = today.getDay();
const daysUntilSunday = todayDow === 0 ? 0 : 7 - todayDow;
const daysToGenerate = daysUntilSunday + 1;

let totalCount = 0;

for (let dayOffset = 0; dayOffset < daysToGenerate; dayOffset++) {
  const day = new Date(startOfToday);
  day.setDate(startOfToday.getDate() + dayOffset);
  const dow = day.getDay();

  // Fire a sequence start every 7 minutes from 7:00 AM to 9:00 PM
  for (let m = 7 * 60; m < 21 * 60; m += intervalMinutes) {
    if (isBlocked(dow, m)) continue;
    if (dayOffset === 0 && m < nowMinutes) continue;

    // Schedule each phrase in the sequence, offset by stepSeconds
    for (let i = 0; i < sequence.length; i++) {
      const totalSecs = Math.round(m * 60) + (i * stepSeconds);
      const h   = Math.floor(totalSecs / 3600);
      const min = Math.floor((totalSecs % 3600) / 60);
      const sec = totalSecs % 60;

      const r = new Reminder();
      r.title = sequence[i];
      r.calendar = reminderCal;
      const d = new Date(day);
      d.setHours(h, min, sec, 0);
      r.dueDate = d;
      r.dueDateIncludesTime = true;
      await r.save();
      totalCount++;
    }
  }
}

Script.setShortcutOutput("Created " + totalCount + " reminders!");
QuickLook.present("Done! " + totalCount + " reminders (today–Sunday, 4-phrase sequence every 7 min, phrases 5 s apart).");

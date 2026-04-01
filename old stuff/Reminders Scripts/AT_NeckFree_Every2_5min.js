// AT Reminders - "Let your neck be free" every 2.5 min
// Scriptable (iOS) — clears existing AT reminders, creates from TODAY through this Sunday

const prompt = "Let your neck be free.";

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

  // Step every 2.5 minutes from 7:00 AM to 9:00 PM
  for (let m = 7 * 60; m < 21 * 60; m += 2.5) {
    if (isBlocked(dow, m)) continue;
    if (dayOffset === 0 && m < nowMinutes) continue;

    const totalSecs = Math.round(m * 60);
    const h = Math.floor(totalSecs / 3600);
    const min = Math.floor((totalSecs % 3600) / 60);
    const sec = totalSecs % 60;

    const r = new Reminder();
    r.title = prompt;
    r.calendar = reminderCal;
    const d = new Date(day);
    d.setHours(h, min, sec, 0);
    r.dueDate = d;
    r.dueDateIncludesTime = true;
    await r.save();
    totalCount++;
  }
}

Script.setShortcutOutput("Created " + totalCount + " reminders!");
QuickLook.present("Done! " + totalCount + " reminders (today–Sunday, every 2.5 min): \"Let your neck be free.\"");

// AT Reminders — TODAY (no massage), clears existing and adds new slots from now through 9:00 PM today

const prompts = [
  "Are you gripping the floor?",
  "Is your abdomen compressed?",
  "Is your abdomen collapsed?",
  "Is your solar plexus compressed?",
  "Is your solar plexus collapsed?",
  "Are your toes clenched?",
  "Are your ankles held?",
  "Are your feet clenched?",
  "Let your abdomen lengthen.",
  "Let your stomach fall back.",
  "Let your stomach release.",
  "Let your ankles release.",
  "Let the balls of your feet release.",
  "Let your toes release.",
  "Let your gaze be soft.",
  "Practice all-inclusive awareness.",
  "Let your ribs be soft as you breathe.",
  "Let your front be long from your pubic bone to your supersternal notch.",
  "Let your shoulders be wide all the way across your collarbones.",
  "Let your neck be free.",
  "Let your neck be free so your head can move forward and up.",
  "Let your neck be free so your head can move forward and up and your back can lengthen and widen and your legs and arms lengthen through your fingers and toes.",
  "Let your ribs be free.",
  "Let your eyes be free.",
  "Let your face be free.",
  "Let your jaw be free.",
  "Are you gripping the floor?",
  "Are you compressing your abdomen?",
  "Are you bending over at your waist?",
  "Notice the space behind your head.",
  "Notice the space above your head.",
  "Notice the hair on the back of your head.",
  "Notice the hair on the top of your head.",
  "Notice the space behind your neck.",
  "Notice the hair on the back of your neck.",
  "Let your breath move.",
  "Let your body move.",
  "Where are you easing a little bit?",
  "What is happening to the ease in your body?",
  "Notice the ease in your body.",
  "Notice a little bit of ease.",
  "Notice if anything is easing a little bit.",
  "Notice a place that feels relatively better.",
  "Notice, think, notice, move, notice.",
  "Your feet are a long way away.",
  "Sharks have no shoulders."
];

function shuffle(arr) {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

const cal = await Calendar.forReminders();
const reminderCal = cal.find(c => c.title === "Alexander Technique") || cal[0];

// Clear all existing AT reminders for today
const today = new Date();
const startOfToday = new Date(today);
startOfToday.setHours(0, 0, 0, 0);
const endOfToday = new Date(startOfToday);
endOfToday.setDate(startOfToday.getDate() + 1);
const existing = await Reminder.allDueBetween(startOfToday, endOfToday, [reminderCal]);
for (const r of existing) { await r.remove(); }

// Current time in minutes + 5 min buffer so first reminder is slightly ahead
const nowMinutes = today.getHours() * 60 + today.getMinutes() + 5;

// End time: 9:00 PM = 1260 minutes
const endMinutes = 21 * 60;

// Shuffle prompts 3x over to ensure good variety across all slots
const dayPrompts = shuffle([...prompts, ...prompts, ...prompts]);

let dayIndex = 0;
let totalCount = 0;

for (let m = 7 * 60; m < endMinutes; m += 2.5) {
  // Skip slots already past
  if (m < nowMinutes) continue;

  const totalSecs = Math.round(m * 60);
  const h = Math.floor(totalSecs / 3600);
  const min = Math.floor((totalSecs % 3600) / 60);
  const sec = totalSecs % 60;

  const r = new Reminder();
  r.title = dayPrompts[dayIndex % dayPrompts.length];
  r.calendar = reminderCal;
  const d = new Date(startOfToday);
  d.setHours(h, min, sec, 0);
  r.dueDate = d;
  r.dueDateIncludesTime = true;
  await r.save();
  totalCount++;
  dayIndex++;
}

Script.setShortcutOutput("Created " + totalCount + " reminders!");
QuickLook.present("Done! " + totalCount + " AT reminders created for today (now → 9:00 PM, every 2.5 min). Previous reminders cleared.");

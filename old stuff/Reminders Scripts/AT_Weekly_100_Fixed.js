// AT Reminders - Weekly, up to 100/day, ~7min fixed intervals, work sessions skipped
// 75min session + 15min break per 90min cycle within work blocks
// Scriptable (iOS) — creates reminders for next Mon-Sun

const prompts = ["Is your neck free?","Let your head float up.","Are your shoulders dropping away from your ears?","Notice the weight of your head.","Is your jaw clenched?","Let your back lengthen and widen.","Where is your weight right now?","Is your breathing restricted anywhere?","Let your knees go forward and away.","Notice your contact with the ground.","Is your chest collapsed?","Let your spine decompress.","Are you gripping with your hands?","Notice the space behind your eyes.","Is your tongue pressed to the roof of your mouth?","Let your shoulders widen.","Are you bracing your legs?","Notice your lower back—is it compressed?","Let your head lead, body follow.","Are you holding your breath?","Notice the width of your upper back.","Is your pelvis tucked or tilted?","Let your arms hang freely.","Are you squinting?","Notice the length of your spine.","Is your neck shortening?","Let your ribs move with your breath.","Are you pulling your head back?","Notice the softness behind your knees.","Is your belly gripping?","Let your face soften.","Are your toes curled?","Notice the relationship between your head and atlas.","Is your sternum lifting?","Let your sitting bones drop.","Are you leaning into one hip?","Notice the space between your vertebrae.","Is your chin jutting forward?","Let your eyes soften and widen.","Are you rushing?","Notice the weight dropping through your heels.","Is your upper chest tight?","Let your neck be long.","Are your hands tense?","Notice the horizon line of your eyes.","Is your head tipped to one side?","Let your breath come to you.","Are you end-gaining right now?","Notice the primary control.","Is your back narrowing?","Let your ankles be free.","Are you over-efforting?","Notice the ease available to you.","Is your head balanced on your spine?","Let your lower back soften.","Are you bracing your core?","Notice the length from crown to tailbone.","Is your throat constricted?","Let your hips release.","Are you pulling down?","Notice inhibition—pause before acting.","Is your neck muscles tight?","Let your weight be supported.","Are you lifting your chest unnecessarily?","Notice if you're anticipating the next thing.","Is your head free to nod?","Let your shoulder blades slide down your back.","Are you contracting to stay upright?","Notice the direction of your gaze.","Is your lower jaw hanging free?","Let your whole back breathe.","Are you gripping the floor with your feet?","Notice where effort is unnecessary.","Is your sternum compressed?","Let your arms lengthen from your back.","Are you pulling your shoulders forward?","Notice the relationship of your ears to your shoulders.","Is your breathing shallow?","Let your neck release forward and up.","Are you holding tension in your forehead?","Notice your head as a weight balanced on your spine.","Is your mid-back collapsing?","Let your entire spine be involved in movement.","Are you fixing your gaze too hard?","Notice the ease in your peripheral vision.","Is your weight forward on your toes?","Let your skull float away from your atlas.","Are you bracing for something that isn't happening?","Notice the space between your shoulder blades.","Is your neck shortening as you think?","Let your whole self be taller.","Are you compressing downward as you sit?","Notice the relationship between your eyes and your neck.","Is your upper arm rotating inward?","Let your ribs be free to expand sideways.","Are you rushing through this moment?","Notice the quality of your attention right now.","Is your sacrum tucked under?","Let your whole back surface widen and lengthen.","Pause. Inhibit. Direct. Move."];

// Blackout windows in minutes from midnight
// Mon=1, Tue=2, Wed=3, Thu=4, Fri=5
const blackout = {
  1: [[540,810]],           // Mon 9am-1:30pm
  2: [[540,1080]],          // Tue 9am-6pm
  3: [[900,1170]],          // Wed 3pm-7:30pm
  4: [[540,810]],           // Thu 9am-1:30pm
  5: [[540,720],[900,1080]] // Fri 9am-12pm, 3pm-6pm
};

function isBlocked(dow, min) {
  const windows = blackout[dow] || [];
  for (const [s, e] of windows) {
    if (min >= s && min < e) {
      // 75-min session then 15-min break per 90-min cycle — allow reminders in break
      const cyclePos = (min - s) % 90;
      return cyclePos < 75;
    }
  }
  return false;
}
function shuffle(arr) {
  const a=[...arr];
  for(let i=a.length-1;i>0;i--){const j=Math.floor(Math.random()*(i+1));[a[i],a[j]]=[a[j],a[i]];}
  return a;
}

const cal = await Calendar.forReminders();
const reminderCal = cal.find(c => c.title === "Alexander Technique");
if (!reminderCal) {
  const names = cal.map(c => c.title).join(", ");
  throw new Error("'Alexander Technique' list not found! Available lists: " + names);
}

const today = new Date();
const daysToMonday = today.getDay() === 1 ? 0 : (8 - today.getDay()) % 7 || 7;
const monday = new Date(today);
monday.setDate(today.getDate() + daysToMonday);
monday.setHours(0,0,0,0);

// Clear any existing AT reminders for the week to avoid duplicates
const weekEnd = new Date(monday);
weekEnd.setDate(monday.getDate() + 7);
const existing = await Reminder.allDueBetween(monday, weekEnd, [reminderCal]);
for (const r of existing) { await r.remove(); }

let totalCount = 0;

for (let dayOffset = 0; dayOffset < 7; dayOffset++) {
  const day = new Date(monday);
  day.setDate(monday.getDate() + dayOffset);
  const dow = day.getDay();

  const slots = [];
  for (let m = 6*60+30; m < 21*60; m += 7) {
    if (!isBlocked(dow, m)) slots.push(m);
  }

  const selected = slots.slice(0, 100);
  const dayPrompts = shuffle([...prompts]).slice(0, selected.length);

  for (let i = 0; i < selected.length; i++) {
    const r = new Reminder();
    r.title = dayPrompts[i];
    r.calendar = reminderCal;
    const d = new Date(day);
    d.setHours(Math.floor(selected[i]/60));
    d.setMinutes(selected[i]%60);
    d.setSeconds(0);
    r.dueDate = d;
    r.dueDateIncludesTime = true;
    await r.save();
    totalCount++;
  }
}

Script.setShortcutOutput("Created "+totalCount+" reminders!");
QuickLook.present("Done! "+totalCount+" AT reminders for the week (blackouts skipped).");

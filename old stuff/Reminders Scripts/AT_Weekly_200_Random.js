// AT Reminders - Weekly, 200/day, random intervals, massage blackouts skipped
// Scriptable (iOS) — creates reminders for next Mon-Sun

const prompts = ["Is your neck free?","Let your head float up.","Are your shoulders dropping away from your ears?","Notice the weight of your head.","Is your jaw clenched?","Let your back lengthen and widen.","Where is your weight right now?","Is your breathing restricted anywhere?","Let your knees go forward and away.","Notice your contact with the ground.","Is your chest collapsed?","Let your spine decompress.","Are you gripping with your hands?","Notice the space behind your eyes.","Is your tongue pressed to the roof of your mouth?","Let your shoulders widen.","Are you bracing your legs?","Notice your lower back—is it compressed?","Let your head lead, body follow.","Are you holding your breath?","Notice the width of your upper back.","Is your pelvis tucked or tilted?","Let your arms hang freely.","Are you squinting?","Notice the length of your spine.","Is your neck shortening?","Let your ribs move with your breath.","Are you pulling your head back?","Notice the softness behind your knees.","Is your belly gripping?","Let your face soften.","Are your toes curled?","Notice the relationship between your head and atlas.","Is your sternum lifting?","Let your sitting bones drop.","Are you leaning into one hip?","Notice the space between your vertebrae.","Is your chin jutting forward?","Let your eyes soften and widen.","Are you rushing?","Notice the weight dropping through your heels.","Is your upper chest tight?","Let your neck be long.","Are your hands tense?","Notice the horizon line of your eyes.","Is your head tipped to one side?","Let your breath come to you.","Are you end-gaining right now?","Notice the primary control.","Is your back narrowing?","Let your ankles be free.","Are you over-efforting?","Notice the ease available to you.","Is your head balanced on your spine?","Let your lower back soften.","Are you bracing your core?","Notice the length from crown to tailbone.","Is your throat constricted?","Let your hips release.","Are you pulling down?","Notice inhibition—pause before acting.","Is your neck muscles tight?","Let your weight be supported.","Are you lifting your chest unnecessarily?","Notice if you're anticipating the next thing.","Is your head free to nod?","Let your shoulder blades slide down your back.","Are you contracting to stay upright?","Notice the direction of your gaze.","Is your lower jaw hanging free?","Let your whole back breathe.","Are you gripping the floor with your feet?","Notice where effort is unnecessary.","Is your sternum compressed?","Let your arms lengthen from your back.","Are you pulling your shoulders forward?","Notice the relationship of your ears to your shoulders.","Is your breathing shallow?","Let your neck release forward and up.","Are you holding tension in your forehead?","Notice your head as a weight balanced on your spine.","Is your mid-back collapsing?","Let your entire spine be involved in movement.","Are you fixing your gaze too hard?","Notice the ease in your peripheral vision.","Is your weight forward on your toes?","Let your skull float away from your atlas.","Are you bracing for something that isn't happening?","Notice the space between your shoulder blades.","Is your neck shortening as you think?","Let your whole self be taller.","Are you compressing downward as you sit?","Notice the relationship between your eyes and your neck.","Is your upper arm rotating inward?","Let your ribs be free to expand sideways.","Are you rushing through this moment?","Notice the quality of your attention right now.","Is your sacrum tucked under?","Let your whole back surface widen and lengthen.","Pause. Inhibit. Direct. Move."];

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
function shuffle(arr) {
  const a=[...arr];
  for(let i=a.length-1;i>0;i--){const j=Math.floor(Math.random()*(i+1));[a[i],a[j]]=[a[j],a[i]];}
  return a;
}

const cal = await Calendar.forReminders();
const reminderCal = cal.find(c => c.title === "Alexander Technique") || cal[0];

const today = new Date();
const daysToMonday = (8 - today.getDay()) % 7 || 7;
const monday = new Date(today);
monday.setDate(today.getDate() + daysToMonday);
monday.setHours(0,0,0,0);

let totalCount = 0;

for (let dayOffset = 0; dayOffset < 7; dayOffset++) {
  const day = new Date(monday);
  day.setDate(monday.getDate() + dayOffset);
  const dow = day.getDay();

  const validMinutes = [];
  for (let m = 7*60; m < 21*60; m++) {
    if (!isBlocked(dow, m)) validMinutes.push(m);
  }

  const count = Math.min(200, validMinutes.length);
  const picked = shuffle(validMinutes).slice(0, count).sort((a,b)=>a-b);
  const dayPrompts = shuffle([...prompts,...prompts]).slice(0, count);

  for (let i = 0; i < count; i++) {
    const r = new Reminder();
    r.title = dayPrompts[i];
    r.calendar = reminderCal;
    const d = new Date(day);
    d.setHours(Math.floor(picked[i]/60));
    d.setMinutes(picked[i]%60);
    d.setSeconds(0);
    r.dueDate = d;
    r.dueDateIncludesTime = true;
    await r.save();
    totalCount++;
  }
}

Script.setShortcutOutput("Created "+totalCount+" reminders!");
QuickLook.present("Done! "+totalCount+" random AT reminders for the week (blackouts skipped).");

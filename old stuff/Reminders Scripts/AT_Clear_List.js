// Clear Alexander Technique Reminders List - Scriptable (iOS)
// Removes all reminders from the "Alexander Technique" list

const listName = "Alexander Technique";

const cals = await Calendar.forReminders();
const targetCal = cals.find(c => c.title === listName);

if (!targetCal) {
  let alert = new Alert();
  alert.title = "List Not Found";
  alert.message = `Could not find a Reminders list named "${listName}".`;
  alert.addAction("OK");
  await alert.present();
} else {
  const reminders = await Reminder.all([targetCal]);

  for (const r of reminders) {
    r.remove();
  }

  let alert = new Alert();
  alert.title = "Done";
  alert.message = `Cleared ${reminders.length} reminder${reminders.length !== 1 ? "s" : ""} from "${listName}".`;
  alert.addAction("OK");
  await alert.present();
}

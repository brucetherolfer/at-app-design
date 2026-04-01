

Now let me build the iOS speaking script. Give me a moment —**AT_Speak.js** should be in your Downloads. 

Here's the setup once you've got it in Scriptable:

1. Save the script in Scriptable, name it **"AT Speak"**
2. Open **Shortcuts** → Automation tab → **New Automation → Time of Day**
3. The trick for ~7 min spacing: create **two automations**, both set to repeat **every 15 minutes** — one starting at 7:00am, one starting at 7:07am. That gives you a prompt roughly every 7-8 minutes with a slight offset feel
4. Each automation: add action **"Run Scriptable Script" → AT Speak**, then turn **OFF** "Ask Before Running" and **OFF** "Notify When Run"
5. The script handles all the blackout logic itself — if it fires during a massage window it just silently exits

The voice will come out of your phone speaker if no AirPods are connected, or through AirPods if they are. Want to test it manually in Scriptable first before setting up the Shortcuts automations?
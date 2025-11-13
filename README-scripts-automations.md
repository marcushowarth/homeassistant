# Scripts Automations

The point of documenting this was to highlight a couple of script ideas I use.




### Free Electricity Day Tomorrow

**Description:** a number of steps to mean we get most of [free electrity sessions](https://octopus.energy/free-electricity/) It's quite nice to kick off if an email is received informing of the free session and the next day get notification of how much we used. We can get 5/6Kw during the session. 

* Wait until 8:30 - not very cleaver but sun is up
* set the work mode to Feed-in first so not to charge the battery 
* set max SoC to 100%
* set up the charge period to start and end at the free electric window start and end
* at the start record the current SoC and Grid Consumption
* at the end record the current SoC and Grid Consumption
* reset the charge period settings

---
### Free Electricity Day Today

**Description:** as "Free Electricity Day Tomorrow" but without the wait until 8:30. There might be scope to add force discharge before the free session starts.

---
### Bedtime

**Description:** Handy to group some actions if turning in before the normal scripted time, eg. turning off the garden lights, fish tank lights, giving 5 mins for house lighting "Overnight Dim" mode.

* Being a script I can easily run this from my watch.

---
### Heat workshop overnight

**Description:** Automates the heater to run during the ECO peak hours. Still expensive so not used. It adds usage to a spreadsheet and emails alerts.


---
### Stop using battery (set Min SoC to current level)

**Description:** Can't remember why I wrote this. It can do what it says on the tin, useful should you want to stop using the battery before the peak tariff during winter and heavy useage during the  morning?.

---
### 'Bedroom Light: Marcus up'

**Description:** Basically puts the morning routine of the bedroom lamp on "holiday mode" until a later time for the wife!

* Being a script I can easily run this from my watch. There's also an "Early rise" scene that turns on lights ready for coffee and workout.

---

### Update Octopus Energy Tariffs with Change Detection

**Description:** Using the HACS Plugin [Octopus Energy](https://bottlecapdave.github.io/HomeAssistant-OctopusEnergy/) to monitor the tariff and update the helpers for tariff prices.

* If a change to the tariffs is detected, it will update the tariff helpers and email me.

---
### Cross Trainer Fan 45min override

**Description:** There's automations that turns off the cross trainer fans in the workshop when no person is detected (they are turned on by *Switches: Pool room: Turn on cross trainer fans if hot and motion detected*) - This script allows me to override that for 45 minutes so even if I'm out of sight of the CCTV camera they will stay on for me to finish my workout.

* Being a script I can easily run this from my watch.

---

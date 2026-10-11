# Energy Automations

The point of documenting this was to highlight what I have working with [FOXESS MODBUS](https://github.com/nathanmarlor/foxess_modbus):
* Energy dashboard setup [with tariffs as by example](https://www.speaktothegeek.co.uk/2024/03/octopus-smart-tariffs-and-home-assistants-energy-dashboard/)
* Use [OctopusEnergy](https://github.com/BottlecapDave/HomeAssistant-OctopusEnergy) to update price entities using automations
* Use the [Sol Cast API](https://solcast.com.au/) for the next day's PV forecast and automate the overnight SoC level
* Anticipate a charge required before the Peak Tariff to avoid excessive charging
* Ability to set a period of **Force Discharge** during peak tariff if away or excess PV
* Battery: Charge Reduction - [courtesy of Dave Foster](https://foxesscommunity.com/viewtopic.php?t=946)
* Plan a [free electricity session](https://octopus.energy/free-electricity/) ahead of time: arm a dated slot and the battery is emptied beforehand, grid-charged during it, and the hour costed as `free`

### Energy: Octopus Flux Tariffs

**Description:** Sets the tariff

Used in the energy dashboard to display the current costs and usage information.

* Triggers at each Flux boundary (and on HA start) and calls the script **Energy: apply tariff for the current time** (see [Scripts](README-scripts-automations.md)), which works out eco / day / peak from the Flux time helpers and sets all four tariff selects.
* The workshop grid consumption utility meter has a fourth tariff, `free`. The script keeps it on `free` while an armed free electricity slot is running, so a Flux boundary inside a slot doesn't undo it.

---
### Energy: Free electricity slot (armed)

**Description:** Runs a free electricity slot set ahead of time on the Battery & Tariffs dashboard → **FREE ELECTRICITY** tab (start/end date+time, Armed toggle, pre-slot SoC target and offset). Does nothing unless Armed is on.

* **22:30 the night before** (after the 22:15 PV forecast automation): caps Max SoC ECO at the pre-slot target so the overnight charge doesn't fill the battery.
* **Before the slot:** Force Discharge down to the target. Lead time = (SoC − target) × 13.75 kWh ÷ 3 kW + 30 min. Only starts if SoC is above target + offset. Force Discharge rather than Self Use, as Self Use still charges from PV regardless of Max SoC.
* **Target reached:** Feed-in First until the slot.
* **Slot start:** grid charge period set to the slot, Max SoC 100%, Self Use, workshop grid tariff → `free`, start logged/emailed.
* **Slot end:** Self Use, charge period reset, Max SoC back to day/peak, disarms, re-applies the tariff, end logged/emailed.
* Known gaps: a slot in 14:00–16:00 clashes with the pre-peak charge period 2 automation; a slot in 16:00–19:00 overlaps the peak export work-mode polling; disarming mid-slot skips the end restore.

---
### Energy: Battery Max SoC setting

**Description:** Sets the Max SoC according to the time of day based on tariffs using the input number values on dashboard

* Notabably the Max SoC would be 100% between 2am and 5am during the winter months. 

---
### Energy: Flux tariff: Work Mode around peak tariff times when Force exporting

**Description:** Sets the inverter's Work Mode at start and end of peak tariff times

* Could be force discharge if the export flag is set.

---
### Energy: Battery Min SoC setting

**Description:** Sets the Min SoC according to the time of day based on tariffs using the input number values on dashboard


---
### Energy: Battery Switch Work mode from Force Discharge to Feed-in First - when target Force Discharge SoC level achieved

**Description:** Sets the work mode back to Feed-in First (from Force Discharge) once the target SoC acheived. - it 'polls' every 5 minutes during the 16th, 17th & 18th hours to check condition


---

### Energy: Battery: Enable 2nd charge period before Peak Tariff period

**Description:** Sets the 2nd charge period to enable in the hour before the peak tariff if SoC below Max SoC minus Daytime Charge Offset %

This is to ensure the battery has enough to avoid using peak tariff.  

---
### Energy: Battery: Disable 2nd charge period before the Peak Tarriff

**Description:** Disables the 2nd charge period if SoC >= the batteries current Max SoC % in hour before peak tarriff

---
### Energy: Battery: Enable 1st charge period during Eco Tariff period

**Description:** Enables the 1st charge period if SoC below Max SoC minus ECO Charge Offset %


---
### Energy: Battery: Disable 1st charge period during Eco Tariff period

**Description:** Disables the 1st charge period if SoC >= the batteries current Max SoC %


---
### Energy: Battery Switch Work mode from Feed-in First to Self Use - below target Force Discharge SoC level

**Description:** Sets the work mode back to Self Use if workmode is Feed-in First and the SoC is below the target SoC - it 'polls' every 5 minutes during the 16th, 17th & 18th hours to check condition


---
### Energy: Battery: Charge Reduction

**Description:** This is a simple automation that sets the charge current to 4A above 93% SoC and then increases it backs to 35A (the default max setting) when the battery drops below 90%.
https://foxesscommunity.com/viewtopic.php?t=946

---
### Energy: Battery: Max SoC according to the alternative cooking value

**Description:** Sets the Max SoC according to the alternative cooking value

* not sure how useful this is but it's a simple automation that sets the Max SoC higher value when the the cooker has been used during the day. This could be simplified by having the SoC level required during Peak Tariff be based on the day of the week if say usage higher at weekends. 

---
### Energy: set Max SoC ECO based on tomorrow's PV forecast

**Description:** Sets the Max SoC ECO according to the forecast for tomorrow

This uses the Solcast API to get the forecast for tomorrow and sets the Max SoC ECO according to the forecasted PV output. Using High/Med/Low thresholds from the dashboard. 

PV forecast is higher then:
* input_number.pv_forecasthigh_threshold - sets the Max SoC ECO to input_number.max_soc_eco_high
* input_number.pv_forecastmed_threshold - sets the Max SoC ECO to input_number.max_soc_eco_med
* input_number.pv_forecastlow_threshold - sets the Max SoC ECO to input_number.max_soc_eco_low
* else - sets the Max SoC ECO to input_number.max_soc_eco_default

e.g. default to 100%, but if next day's forecast beats any threshold the the battery will be set not to charge to a lesser level to avoid excessive charging.

---
### Energy: Reset the Max SoC ECO to default

**Description:** 



---
### Energy: set flag to force peak export based on tomorrow's PV forecast

**Description:** Sets the flag to force peak export based on tomorrow's PV forecast


---
### Energy: Daily: Update Octopus Energy Tariffs

**Description:** Run daily at 7am to update import/export rates from Octopus Energy.


---

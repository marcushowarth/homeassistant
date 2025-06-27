# Energy Automations

## oh dear.. TODO
Below should have been reviewed before pushing!! 😂

The main point of documenting this was to highlight what I have working with [FOXESS MODBUS](https://github.com/nathanmarlor/foxess_modbus):
* Energy dashboard setup [with tariffs as by example](https://www.speaktothegeek.co.uk/2024/03/octopus-smart-tariffs-and-home-assistants-energy-dashboard/)
* Use [OctopusEnergy](https://github.com/BottlecapDave/HomeAssistant-OctopusEnergy) to update price entities using automations
* Use the [Sol Cast API](https://solcast.com.au/) for the next day's PV forecast and automate the overnight SoC level
* Anticipate a charge required before the Peak Tariff to avoid excessive charging
* Ability to set a period of **Force Discharge** during peak tariff if away or excess PV
* Battery: Charge Reduction - [courtesy of Dave Foster](https://foxesscommunity.com/viewtopic.php?t=946)

### Energy: Octopus Flux Tariffs

**Description:** Sets the tariff

**Triggers:**
- `time` (at: input_datetime.off_peak_energy_start, variables: {'tariff': 'eco'})
- `time` (at: input_datetime.off_peak_energy_end, variables: {'tariff': 'day'})
- `time` (at: input_datetime.peak_energy_start, variables: {'tariff': 'peak'})
- `time` (at: input_datetime.peak_energy_end, variables: {'tariff': 'day'})

**Conditions:**
- None

**Actions:**
- `unknown` (service: select.select_option, target: {'entity_id': 'select.grid_consumption_house'}, data: {'option': '{{ tariff }}'})
- `unknown` (service: select.select_option, target: {'entity_id': 'select.grid_consumption_workshop'}, data: {'option': '{{ tariff }}'})
- `unknown` (service: select.select_option, target: {'entity_id': 'select.feed_in_house'}, data: {'option': '{{ tariff }}'})
- `unknown` (service: select.select_option, target: {'entity_id': 'select.feed_in_workshop'}, data: {'option': '{{ tariff }}'})

---
### Energy: Battery Max SoC setting

**Description:** Sets the Max SoC according to the time of day based on tariffs using the input number values on dashboard

**Triggers:**
- `time` (at: input_datetime.off_peak_energy_start, variables: {'maxSoC': "{{ states('input_number.max_soc_eco') | float(states('number.workshop_min_soc')) }}"})
- `time` (at: input_datetime.off_peak_energy_end, variables: {'maxSoC': "{{ states('input_number.max_soc_day') | float(states('number.workshop_min_soc')) }}"})
- `time` (at: input_datetime.peak_energy_start, variables: {'maxSoC': "{{ states('input_number.max_soc_peak') | float(states('number.workshop_min_soc')) }}"})
- `time` (at: input_datetime.peak_energy_end, variables: {'maxSoC': "{{ states('input_number.max_soc_day') | float(states('number.workshop_min_soc')) }}"})

**Conditions:**
- None

**Actions:**
- `unknown` (service: number.set_value, target: {'entity_id': 'number.workshop_max_soc'}, data: {'value': '{{ maxSoC }}'})

---
### Energy: Flux tariff: Work Mode around peak tariff times when Force exporting

**Description:** Sets the inverter's Work Mode at start and end of peak tariff times

**Triggers:**
- `time` (at: input_datetime.peak_energy_start, variables: {'workmode': 'Force Discharge'}, trigger: time)
- `time` (at: input_datetime.peak_energy_end, variables: {'workmode': 'Self Use'}, trigger: time)

**Conditions:**
- `unknown` (condition: state, entity_id: input_boolean.peak_tariff_export_enabled, state: on)

**Actions:**
- `unknown` (target: {'entity_id': 'select.workshop_work_mode'}, data: {'option': '{{ workmode }}'}, action: select.select_option)

---
### Energy: Battery Min SoC setting

**Description:** Sets the Min SoC according to the time of day based on tariffs using the input number values on dashboard

**Triggers:**
- `time` (at: input_datetime.off_peak_energy_start, variables: {'minSoC': "{{ float(states('input_number.min_soc_eco')) }}"})
- `time` (at: input_datetime.off_peak_energy_end, variables: {'minSoC': "{{ float(states('input_number.min_soc_day')) }}"})
- `time` (at: input_datetime.peak_energy_start, variables: {'minSoC': "{{ float(states('input_number.min_soc_peak')) }}"})
- `time` (at: input_datetime.peak_energy_end, variables: {'minSoC': "{{ float(states('input_number.min_soc_day')) }}"})

**Conditions:**
- None

**Actions:**
- `unknown` (service: number.set_value, target: {'entity_id': 'number.workshop_min_soc'}, data: {'value': '{{ minSoC }}'})
- `unknown` (service: number.set_value, target: {'entity_id': 'number.workshop_min_soc_on_grid'}, data: {'value': '{{ minSoC }}'})

---
### Energy: Battery Switch Work mode from Force Discharge to Feed-in First - when target Force Discharge SoC level achieved

**Description:** Sets the work mode back to Feed-in First (from Force Discharge) once the target SoC acheived. - it 'polls' every 5 minutes during the 16th, 17th & 18th hours to check condition

**Triggers:**
- `time_pattern` (hours: 16, minutes: /5)
- `time_pattern` (hours: 17, minutes: /5)
- `time_pattern` (hours: 18, minutes: /5)

**Conditions:**
- `unknown` (and: [{'condition': 'template', 'value_template': "{{ states('select.workshop_work_mode') == 'Force Discharge' }}"}, {'condition': 'template', 'value_template': "{{ states('sensor.workshop_battery_soc')|float(0) <= states('input_number.target_soc_force_export')|float(0) }}"}])

**Actions:**
- `unknown` (variables: {'workmode': 'Feed-in First'})
- `unknown` (service: select.select_option, target: {'entity_id': 'select.workshop_work_mode'}, data: {'option': '{{ workmode }}'})

---
### Energy: Battery: Enable 2nd charge period before Peak Tariff period

**Description:** Sets the 2nd charge period to enable in the hour before the peak tariff if SoC below Max SoC minus Daytime Charge Offset %

**Triggers:**
- `time_pattern` (hours: 15, minutes: /5)

**Conditions:**
- `unknown` (and: [{'condition': 'template', 'value_template': "{{ states('binary_sensor.workshop_time_period_2_enable_force_charge') == 'off' }}"}, {'condition': 'template', 'value_template': "{{ states('sensor.workshop_battery_soc')|float(0) <=\n   states('number.workshop_max_soc')|float(0) -\n   states('input_number.daytime_charge_offset')|float(0) }}"}])

**Actions:**
- `unknown` (service: foxess_modbus.update_charge_period, data: {'inverter': '1185fbf7ef097c175604da2d3bb46177', 'charge_period': '2', 'enable_charge_from_grid': True, 'enable_force_charge': True, 'start': '15:00:00', 'end': '15:55:00'})
- `unknown` (service: ifttt.trigger, data: {'event': 'HA_trigger_sheet', 'value1': 'Daytime pre-PEAK charge log', 'value2': "Grid Consumption so far today = {{ states('sensor.workshop_grid_consumption_energy_today') }} KWh", 'value3': "Enabled at {{ states('sensor.workshop_battery_soc') }}%"})

---
### Energy: Battery: Disable 2nd charge period before the Peak Tarriff

**Description:** Disables the 2nd charge period if SoC >= the batteries current Max SoC % in hour before peak tarriff

**Triggers:**
- `time_pattern` (hours: 15, minutes: /5)
- `time` (at: 16:00:00)

**Conditions:**
- `unknown` (and: [{'condition': 'template', 'value_template': "{{ states('binary_sensor.workshop_time_period_2_enable_force_charge') == 'on' }}"}, {'condition': 'template', 'value_template': "{{ states('sensor.workshop_battery_soc')|float(0) >=\n   states('number.workshop_max_soc')|float(0) }}"}])

**Actions:**
- `unknown` (service: foxess_modbus.update_charge_period, data: {'inverter': '1185fbf7ef097c175604da2d3bb46177', 'charge_period': '2', 'enable_charge_from_grid': True, 'enable_force_charge': False, 'start': '15:00:00', 'end': '15:55:00'})
- `unknown` (service: ifttt.trigger, data: {'event': 'HA_trigger_sheet', 'value1': 'Daytime pre-PEAK charge log', 'value2': "Grid Consumption so far today = {{ states('sensor.workshop_grid_consumption_energy_today') }} KWh", 'value3': "Disabled at {{ states('sensor.workshop_battery_soc') }}%"})

---
### Energy: Battery: Enable 1st charge period during Eco Tariff period

**Description:** Enables the 1st charge period if SoC below Max SoC minus ECO Charge Offset %

**Triggers:**
- `time_pattern` (hours: 2, minutes: /5)
- `time_pattern` (hours: 3, minutes: /5)
- `time_pattern` (hours: 4, minutes: /5)

**Conditions:**
- `unknown` (and: [{'condition': 'template', 'value_template': "{{ states('binary_sensor.workshop_time_period_1_enable_force_charge') == 'off' }}"}, {'condition': 'template', 'value_template': "{{ states('sensor.workshop_battery_soc')|float(0) <=\n   states('number.workshop_max_soc')|float(0) -\n   states('input_number.eco_charge_offset')|float(0) }}"}])

**Actions:**
- `unknown` (service: foxess_modbus.update_charge_period, data: {'inverter': '1185fbf7ef097c175604da2d3bb46177', 'charge_period': '1', 'enable_charge_from_grid': True, 'enable_force_charge': True, 'start': '02:00:00', 'end': '04:55:00'})
- `unknown` (service: ifttt.trigger, data: {'event': 'HA_trigger_sheet', 'value1': 'Overnight ECO charge log', 'value2': "Grid Consumption so far today = {{ states('sensor.workshop_grid_consumption_energy_today') }} KWh", 'value3': "Enabled at {{ states('sensor.workshop_battery_soc') }}%"})

---
### Energy: Battery: Disable 1st charge period during Eco Tariff period

**Description:** Disables the 1st charge period if SoC >= the batteries current Max SoC %

**Triggers:**
- `time_pattern` (hours: 2, minutes: /5)
- `time_pattern` (hours: 3, minutes: /5)
- `time_pattern` (hours: 4, minutes: /5)
- `time` (at: 05:00:00)

**Conditions:**
- `unknown` (and: [{'condition': 'template', 'value_template': "{{ states('binary_sensor.workshop_time_period_1_enable_force_charge') == 'on' }}"}, {'condition': 'template', 'value_template': "{{ states('sensor.workshop_battery_soc')|float(0) >=\n   states('number.workshop_max_soc')|float(0) }}"}])

**Actions:**
- `unknown` (service: foxess_modbus.update_charge_period, data: {'inverter': '1185fbf7ef097c175604da2d3bb46177', 'charge_period': '1', 'enable_charge_from_grid': True, 'enable_force_charge': False, 'start': '02:00:00', 'end': '04:55:00'})
- `unknown` (service: ifttt.trigger, data: {'event': 'HA_trigger_sheet', 'value1': 'Overnight ECO charge log', 'value2': "Grid Consumption so far today = {{ states('sensor.workshop_grid_consumption_energy_today') }} KWh", 'value3': "Disabled at {{ states('sensor.workshop_battery_soc') }}%"})

---
### Energy: Battery Switch Work mode from Feed-in First to Self Use - below target Force Discharge SoC level

**Description:** Sets the work mode back to Self Use if workmode is Feed-in First and the SoC is below the target SoC - it 'polls' every 5 minutes during the 16th, 17th & 18th hours to check condition

**Triggers:**
- `time_pattern` (hours: 16, minutes: /5)
- `time_pattern` (hours: 17, minutes: /5)
- `time_pattern` (hours: 18, minutes: /5)

**Conditions:**
- `unknown` (and: [{'condition': 'template', 'value_template': "{{ states('select.workshop_work_mode') == 'Feed-in First' }}"}, {'condition': 'template', 'value_template': "{{ states('sensor.workshop_battery_soc')|float(0) < states('input_number.target_soc_force_export')|float(0) }}"}])

**Actions:**
- `unknown` (variables: {'workmode': 'Self Use'})
- `unknown` (service: select.select_option, target: {'entity_id': 'select.workshop_work_mode'}, data: {'option': '{{ workmode }}'})

---
### Energy: Battery: Charge Reduction

**Description:** This is a simple automation that sets the charge current to 4A above 93% SoC and then increases it backs to 35A (the default max setting) when the battery drops below 90%.
https://foxesscommunity.com/viewtopic.php?t=946

**Triggers:**
- `time_pattern` (minutes: /10)

**Conditions:**
- `unknown` (condition: or, conditions: [{'condition': 'numeric_state', 'entity_id': 'sensor.workshop_battery_soc', 'below': 90}, {'condition': 'numeric_state', 'entity_id': 'sensor.workshop_battery_soc', 'above': 93}])

**Actions:**
- `unknown` (if: [{'condition': 'numeric_state', 'entity_id': 'sensor.workshop_battery_soc', 'above': 92}], then: [{'if': [{'condition': 'numeric_state', 'entity_id': 'sensor.workshop_max_charge_current', 'above': 10}], 'then': [{'service': 'number.set_value', 'data': {'value': 4}, 'target': {'entity_id': 'number.workshop_max_charge_current'}}, {'service': 'logbook.log', 'data': {'message': 'Setting Max Charge to 4A', 'name': 'Max Charge'}}]}], else: [{'if': [{'condition': 'numeric_state', 'entity_id': 'sensor.workshop_battery_soc', 'below': 90}], 'then': [{'if': [{'condition': 'numeric_state', 'entity_id': 'sensor.workshop_max_charge_current', 'below': 10}], 'then': [{'service': 'number.set_value', 'data': {'value': 35}, 'target': {'entity_id': 'number.workshop_max_charge_current'}}, {'service': 'logbook.log', 'data': {'message': 'Setting Max Charge to 35A', 'name': 'Max Charge'}}]}]}])

---
### Energy: Battery: Max SoC according to the alternative cooking value

**Description:** Sets the Max SoC according to the alternative cooking value

**Triggers:**
- `time` (at: 14:55:00, variables: {'maxSoC': "{{ states('input_number.max_soc_day_alternative_cooking') | float(states('number.workshop_min_soc')) }}"})

**Conditions:**
- `unknown` (condition: template, value_template: {{ states('sensor.oven_today_energy')|float(0) >=
     states('input_number.energy_trigger_cooking')|float(0) }})

**Actions:**
- `unknown` (service: number.set_value, target: {'entity_id': 'number.workshop_max_soc'}, data: {'value': '{{ maxSoC }}'})
- `unknown` (service: notify.marcus_email, data: {'message': "Oven current power {{ states('sensor.oven_current_power') }}W, so far today it's used {{ states('sensor.oven_today_energy') }}kWh and the heater in the workshop is currently using {{ states('sensor.heater_current_power') }}W, so far today it's used {{ states('sensor.heater_today_energy') }}kWh Either one of these has triggered Max SoC to now be set to {{ states('number.workshop_max_soc') }}% (instead of normal Max SoC DAY {{ states('input_number.max_soc_day') }}%). The Battery SoC is currently {{ states('sensor.workshop_battery_soc') }}% (so there's a {{ states('sensor.workshop_battery_soc')|float(0) - states('number.workshop_max_soc')|float(0)  }}% difference there before 4pm peak starts in about an hour.)", 'title': "Bumped up Max SoC Day as looks like we're cooking or using heater"})

---
### Energy: set Max SoC ECO based on tomorrow's PV forecast

**Description:** Sets the Max SoC ECO according to the forecast for tomorrow

**Triggers:**
- `time` (at: 22:15:00, trigger: time)

**Conditions:**
- None

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'numeric_state', 'entity_id': 'sensor.solcast_pv_forecast_forecast_tomorrow', 'above': 'input_number.pv_forecasthigh_threshold'}], 'sequence': [{'target': {'entity_id': 'input_number.max_soc_eco'}, 'data': {'value': "{{ states('input_number.max_soc_eco_high') | float(0) }}"}, 'action': 'input_number.set_value'}, {'data': {'message': "Setting Max SoC ECO to {{ states('input_number.max_soc_eco_high') }}% as PV forcast is {{ states('sensor.solcast_pv_forecast_forecast_tomorrow') }}kWh", 'name': 'Max SoC ECO'}, 'action': 'logbook.log'}]}, {'conditions': [{'condition': 'numeric_state', 'entity_id': 'sensor.solcast_pv_forecast_forecast_tomorrow', 'above': 'input_number.pv_forecastmed_threshold'}], 'sequence': [{'target': {'entity_id': 'input_number.max_soc_eco'}, 'data': {'value': "{{ states('input_number.max_soc_eco_medium') | float(0) }}"}, 'action': 'input_number.set_value'}, {'data': {'message': "Setting Max SoC ECO to {{ states('input_number.max_soc_eco_medium') }}% as PV forcast is {{ states('sensor.solcast_pv_forecast_forecast_tomorrow') }}kWh", 'name': 'Max SoC ECO'}, 'action': 'logbook.log'}]}, {'conditions': [{'condition': 'numeric_state', 'entity_id': 'sensor.solcast_pv_forecast_forecast_tomorrow', 'above': 'input_number.pv_forecastlow_threshold'}], 'sequence': [{'target': {'entity_id': 'input_number.max_soc_eco'}, 'data': {'value': "{{ states('input_number.max_soc_eco_low') | float(0) }}"}, 'action': 'input_number.set_value'}, {'data': {'message': "Setting Max SoC ECO to {{ states('input_number.max_soc_eco_low') }}% as PV forcast is {{ states('sensor.solcast_pv_forecast_forecast_tomorrow') }}kWh", 'name': 'Max SoC ECO'}, 'action': 'logbook.log'}]}], default: [{'target': {'entity_id': 'input_number.max_soc_eco'}, 'data': {'value': "{{ states('input_number.max_soc_eco_default') | float(0) }}"}, 'action': 'input_number.set_value'}, {'data': {'message': "Setting Max SoC EC to default {{ states('input_number.max_soc_eco_default') }}% PV forcast is {{ states('sensor.solcast_pv_forecast_forecast_tomorrow') }}kWh - check why default?", 'name': 'Max SoC ECO'}, 'action': 'logbook.log'}])
- `unknown` (data: {'event': 'HA_trigger_calendar', 'value1': "Max SoC ECO = {{ states('input_number.max_soc_eco') }}% PV forecast {{ states('sensor.solcast_pv_forecast_forecast_tomorrow') }}kWh"}, action: ifttt.trigger)
- `unknown` (data: {'event': 'HA_trigger_sheet', 'value1': 'PV Forecasts setting Max SoC ECO', 'value2': "Tomorrow PV forecast {{ states('sensor.solcast_pv_forecast_forecast_tomorrow') }}kWh", 'value3': "Todays actual PV {{ states('sensor.generation_today') }}kWh"}, action: ifttt.trigger)
- `unknown` (data: {'message': "Tomorrow's forecast PV = {{ states('sensor.solcast_pv_forecast_forecast_tomorrow') }} kWh Max SoC ECO set to {{ states('input_number.max_soc_eco') }}% for the overnight charge."}, action: notify.marcus_email)

---
### Energy: Reset the Max SoC ECO to default

**Description:** 

**Triggers:**
- `time` (at: input_datetime.off_peak_energy_end, trigger: time)

**Conditions:**
- None

**Actions:**
- `unknown` (target: {'entity_id': 'input_number.max_soc_eco'}, data: {'value': "{{ states('input_number.max_soc_eco_default') | float(0) }}"}, action: input_number.set_value)

---
### Energy: set flag to force peak export based on tomorrow's PV forecast

**Description:** Sets the flag to force peak export based on tomorrow's PV forecast

**Triggers:**
- `time` (at: 22:20:00, trigger: time)

**Conditions:**
- None

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'numeric_state', 'entity_id': 'sensor.solcast_pv_forecast_forecast_tomorrow', 'above': 'input_number.input_number_pv_forecastpeak_export_threshold'}], 'sequence': [{'action': 'input_boolean.turn_on', 'metadata': {}, 'data': {}, 'target': {'entity_id': 'input_boolean.peak_tariff_export_enabled'}}]}], default: [{'action': 'input_boolean.turn_off', 'metadata': {}, 'data': {}, 'target': {'entity_id': 'input_boolean.peak_tariff_export_enabled'}}])
- `unknown` (data: {'message': "Tomorrow's forecast PV = {{ states('sensor.solcast_pv_forecast_forecast_tomorrow') }} kWh so the flag to export during peak tariff set to {{ states('input_boolean.peak_tariff_export_enabled') }} for tomorrow."}, action: notify.marcus_email)

---
### Energy: Daily: Update Octopus Energy Tariffs

**Description:** Run daily at 7am to update import/export rates from Octopus Energy.

**Triggers:**
- `time` (at: 07:00:00, trigger: time)

**Conditions:**
- None

**Actions:**
- `unknown` (action: script.update_octopus_energy_tariffs_with_change_detection, data: {})

---

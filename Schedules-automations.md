# Schedules Automations

### Schedules: Bedroom Lamp Schedule

**Description:** Full bedroom light automation from 07:00 to 09:00 on weekdays unless holiday mode is active

**Triggers:**
- `time_pattern` (minutes: /5, trigger: time_pattern)

**Conditions:**
- `unknown` (condition: template, value_template: {{ not is_state('input_boolean.holiday_bedroom_lamp', 'on') }})
- `unknown` (condition: template, value_template: {{ now().weekday() in [0, 1, 2, 3, 4] }})

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '07:00' }}"}], 'sequence': [{'target': {'entity_id': 'scene.bedroom_light_green_3'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '07:20' }}"}], 'sequence': [{'target': {'entity_id': 'scene.bedroom_light_2700k_50'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '07:50' }}"}], 'sequence': [{'target': {'entity_id': 'scene.bedroom_light_3200k_25'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '08:00' }}"}], 'sequence': [{'target': {'entity_id': 'scene.bedroom_light_4000k_50'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '08:30' }}"}], 'sequence': [{'target': {'entity_id': 'scene.bedroom_light_5000k_65'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '08:50' }}"}], 'sequence': [{'target': {'entity_id': 'scene.bedroom_light_red_100'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '09:00' }}"}], 'sequence': [{'target': {'entity_id': 'scene.bedroom_light_2700k_50'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '09:10' }}"}], 'sequence': [{'target': {'entity_id': 'light.bedroom_lamp'}, 'action': 'light.turn_off', 'data': {}}]}])

---
### Schedules: Fish Tank Lighting

**Description:** Turn on fish tank light at 18:30 or 20 minutes before sunset, and off at 22:00.

**Triggers:**
- `time` (at: 18:30:00, trigger: time)
- `sun` (event: sunset, offset: -00:20:00, trigger: sun)
- `time` (at: 22:00:00, trigger: time)

**Conditions:**
- None

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '22:00' }}"}], 'sequence': [{'target': {'entity_id': 'light.controller_dimmable_bee234'}, 'action': 'light.turn_off'}]}], default: [{'target': {'entity_id': 'light.controller_dimmable_bee234'}, 'action': 'light.turn_on'}])

---
### Schedules: Landing Lighting

**Description:** Landing light control: weekday/weekend mornings, sunset on, and evening off.

**Triggers:**
- `time` (at: 06:00:00, trigger: time)
- `time` (at: 07:00:00, trigger: time)
- `sun` (event: sunrise, offset: 00:10:00, trigger: sun, id: sunrise_offset)
- `sun` (event: sunset, offset: -00:10:00, trigger: sun, id: sunset_offset)
- `time` (at: 22:20:00, trigger: time)

**Conditions:**
- `unknown` (condition: state, entity_id: input_boolean.holiday_landing_light, state: off)

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '06:00' and now().weekday() in [0,1,2,3,4] }}\n"}, {'condition': 'sun', 'before': 'sunrise'}], 'sequence': [{'target': {'entity_id': 'light.landing_light'}, 'action': 'light.turn_on'}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '07:00' and now().weekday() in [5,6] }}\n"}, {'condition': 'sun', 'before': 'sunrise'}], 'sequence': [{'target': {'entity_id': 'light.landing_light'}, 'action': 'light.turn_on'}]}, {'conditions': [{'condition': 'trigger', 'id': 'sunrise_offset'}], 'sequence': [{'target': {'entity_id': 'light.landing_light'}, 'action': 'light.turn_off'}]}, {'conditions': [{'condition': 'trigger', 'id': 'sunset_offset'}], 'sequence': [{'target': {'entity_id': 'light.landing_light'}, 'action': 'light.turn_on'}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '22:20' }}"}], 'sequence': [{'target': {'entity_id': 'light.landing_light'}, 'action': 'light.turn_off'}]}])

---
### Schedules: Garden Lighting

**Description:** Controls garden lighting: sunrise/morning on, sunset dim, and evening off with weekend variant.

**Triggers:**
- `time` (at: 06:30:00, trigger: time)
- `time` (at: 07:30:00, trigger: time)
- `sun` (event: sunrise, trigger: sun)
- `sun` (event: sunset, trigger: sun)
- `time` (at: 21:45:00, trigger: time)
- `time` (at: 22:20:00, trigger: time)
- `time` (at: 23:00:00, trigger: time)

**Conditions:**
- None

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '06:30' and now().weekday() in [0,1,2,3,4] }}"}, {'condition': 'sun', 'before': 'sunrise'}], 'sequence': [{'target': {'entity_id': 'scene.garden_on'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '07:30' and now().weekday() in [5,6] }}"}, {'condition': 'sun', 'before': 'sunrise'}], 'sequence': [{'target': {'entity_id': 'scene.garden_on'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'trigger', 'id': 'sunrise'}], 'sequence': [{'target': {'entity_id': 'scene.garden_off'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'trigger', 'id': 'sunset'}], 'sequence': [{'target': {'entity_id': 'scene.garden_50'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '22:20' and now().weekday() in [0,1,2,3,6] }}"}], 'sequence': [{'target': {'entity_id': 'scene.garden_off'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '23:00' and now().weekday() in [4,5] }}"}], 'sequence': [{'target': {'entity_id': 'scene.garden_off'}, 'action': 'scene.turn_on', 'data': {}}]}])

---
### Schedules: House Lighting

**Description:** Automates LED scenes throughout the house by time and weekday.

**Triggers:**
- `time` (at: 05:20:00, trigger: time)
- `time` (at: 07:20:00, trigger: time)
- `time` (at: 11:00:00, trigger: time)
- `time` (at: 16:00:00, trigger: time)
- `time` (at: 20:00:00, trigger: time)
- `time` (at: 22:40:00, trigger: time)
- `time` (at: 00:00:00, trigger: time)

**Conditions:**
- None

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '05:20' and now().weekday() in [0,1,2,3,4] }}"}], 'sequence': [{'target': {'entity_id': 'scene.lighting_green'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '07:20' and now().weekday() in [5,6] }}"}], 'sequence': [{'target': {'entity_id': 'scene.lighting_green'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '11:00' }}"}], 'sequence': [{'target': {'entity_id': 'scene.lighting_blue'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '16:00' }}"}], 'sequence': [{'target': {'entity_id': 'scene.lighting_green'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '20:00' }}"}], 'sequence': [{'target': {'entity_id': 'scene.lighting_purple'}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '22:40' and now().weekday() in [0,1,2,3,6] }}"}], 'sequence': [{'target': {'entity_id': 'scene.overnight_dim'}, 'action': 'scene.turn_on', 'data': {}}, {'target': {'entity_id': 'input_boolean.overnight_dim_active'}, 'action': 'input_boolean.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '00:00' and now().weekday() in [5,6] }}"}], 'sequence': [{'target': {'entity_id': 'scene.overnight_dim'}, 'action': 'scene.turn_on', 'data': {}}, {'target': {'entity_id': 'input_boolean.overnight_dim_active'}, 'action': 'input_boolean.turn_on', 'data': {}}]}])

---
### Schedules: Extension Lamp (Sunrise & Sunset Edge Cases)

**Description:** Controls Tapo L510 lamp on workday mornings before sunrise, and post-sunset only if before 19:45.

**Triggers:**
- `time` (at: 05:50:00, trigger: time)
- `sun` (event: sunset, trigger: sun)
- `time` (at: 19:45:00, trigger: time)
- `sun` (event: sunrise, trigger: sun)

**Conditions:**
- None

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'template', 'value_template': "{{ now().weekday() in [0,1,2,3,4] and now().strftime('%H:%M') == '05:50' and state_attr('sun.sun', 'elevation') < 0 }}"}], 'sequence': [{'target': {'entity_id': 'light.extension_lamp'}, 'action': 'light.turn_on'}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == (state_attr('sun.sun', 'next_setting') | as_datetime | as_local).strftime('%H:%M') and (state_attr('sun.sun', 'next_setting') | as_datetime | as_local).strftime('%H:%M') < '19:45' }}"}], 'sequence': [{'target': {'entity_id': 'light.extension_lamp'}, 'action': 'light.turn_on'}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '19:45' }}"}], 'sequence': [{'target': {'entity_id': 'light.extension_lamp'}, 'action': 'light.turn_off'}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == (state_attr('sun.sun', 'next_rising') | as_datetime | as_local).strftime('%H:%M') }}"}], 'sequence': [{'target': {'entity_id': 'light.extension_lamp'}, 'action': 'light.turn_off'}]}])

---
### Schedules: Bug Zapper Fixed Times

**Description:** Controls Tapo plug for Bug Zapper at fixed times AM and PM.

**Triggers:**
- `time` (at: 07:00:00, trigger: time)
- `time` (at: 10:00:00, trigger: time)
- `time` (at: 17:00:00, trigger: time)
- `time` (at: 20:30:00, trigger: time)

**Conditions:**
- None

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '07:00' or now().strftime('%H:%M') == '17:00' }}"}], 'sequence': [{'target': {'entity_id': 'switch.bugzapper'}, 'action': 'switch.turn_on'}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '10:00' or now().strftime('%H:%M') == '20:30' }}"}], 'sequence': [{'target': {'entity_id': 'switch.bugzapper'}, 'action': 'switch.turn_off'}]}])

---
### Schedules: Bug Zapper Motion Activated (Excludes Fixed ON Periods)

**Description:** Turns on bug zapper with kitchen motion between 05:00–22:00, avoids auto-OFF during fixed ON periods (07–10, 17–20:30). Outside 22:00–05:00, zapper will turn off.

**Triggers:**
- `state` (entity_id: binary_sensor.motion_kitchen_occupancy, to: on, id: motion_on, trigger: state)
- `state` (entity_id: binary_sensor.motion_kitchen_occupancy, to: off, for: {'minutes': 10}, id: motion_off, trigger: state)

**Conditions:**
- None

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'trigger', 'id': 'motion_on'}, {'condition': 'time', 'after': '05:00:00', 'before': '22:00:00'}], 'sequence': [{'target': {'entity_id': 'switch.bugzapper'}, 'action': 'switch.turn_on'}]}, {'conditions': [{'condition': 'trigger', 'id': 'motion_off'}, {'condition': 'not', 'conditions': [{'condition': 'or', 'conditions': [{'condition': 'time', 'after': '07:00:00', 'before': '10:00:00'}, {'condition': 'time', 'after': '17:00:00', 'before': '20:30:00'}]}]}], 'sequence': [{'target': {'entity_id': 'switch.bugzapper'}, 'action': 'switch.turn_off'}]}])

---
### Schedules: eBike Charger Availability

**Description:** Ensures switch.ebike_charger is ON from sunrise until 20:00 every day.

**Triggers:**
- `sun` (event: sunrise, trigger: sun)
- `time` (at: 20:00:00, trigger: time)

**Conditions:**
- None

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'sun', 'after': 'sunrise'}], 'sequence': [{'target': {'entity_id': 'switch.ebike_charger'}, 'action': 'switch.turn_on'}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '20:00' }}"}], 'sequence': [{'target': {'entity_id': 'switch.ebike_charger'}, 'action': 'switch.turn_off'}]}])

---
### Schedules: Firestick Reboot (Weekly)

**Description:** Turns off the Amazon Firestick TV switch every Monday from 05:00 to 06:00 to force a reset.

**Triggers:**
- `time` (at: 05:00:00, trigger: time)

**Conditions:**
- `unknown` (condition: time, weekday: ['mon'])

**Actions:**
- `unknown` (target: {'entity_id': 'switch.amazon_firestick_tv'}, action: switch.turn_off)
- `unknown` (delay: {'hours': 1})
- `unknown` (target: {'entity_id': 'switch.amazon_firestick_tv'}, action: switch.turn_on)

---
### Schedules: Dishwasher Reboot (Weekly)

**Description:** Turns off the Dishwasher switch every Monday from 05:00 to 06:00 to force a reset.

**Triggers:**
- `time` (at: 05:00:00, trigger: time)

**Conditions:**
- `unknown` (condition: time, weekday: ['mon'])

**Actions:**
- `unknown` (target: {'entity_id': 'switch.dishwasher'}, action: switch.turn_off)
- `unknown` (delay: {'hours': 1})
- `unknown` (target: {'entity_id': 'switch.dishwasher'}, action: switch.turn_on)

---
### Schedules: Christmas Lights (Dec 1 – Jan 1, with Holiday Overnight)

**Description:** Christmas lights ON at sunset and OFF at 23:20 between Dec 1 and Jan 1, except on 24th, 25th, and 31st Dec when they stay ON until sunrise.

**Triggers:**
- `sun` (event: sunset, trigger: sun)
- `time` (at: 23:20:00, trigger: time)
- `sun` (event: sunrise, trigger: sun)

**Conditions:**
- `unknown` (condition: template, value_template: {{ (now().month == 12 and now().day >= 1) or (now().month == 1 and now().day == 1) }})

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'sun', 'after': 'sunset'}], 'sequence': [{'target': {'entity_id': 'switch.christmas_lights'}, 'action': 'switch.turn_on'}]}, {'conditions': [{'condition': 'template', 'value_template': "{{ now().strftime('%H:%M') == '23:20' }}"}, {'condition': 'template', 'value_template': '{{ now().day not in [24, 25, 31] }}'}], 'sequence': [{'target': {'entity_id': 'switch.christmas_lights'}, 'action': 'switch.turn_off'}]}, {'conditions': [{'condition': 'sun', 'after': 'sunrise'}, {'condition': 'template', 'value_template': '{{ now().day in [24, 25, 31] or (now().month == 1 and now().day == 1) }}'}], 'sequence': [{'target': {'entity_id': 'switch.christmas_lights'}, 'action': 'switch.turn_off'}]}])

---
### Schedules: Bedroom Fans (Temp + Time Windows)

**Description:** Control bedroom fans based on temperature threshold and time windows.
- Weekdays (Sun–Thu): 21:30-08:00
- Weekends (Fri–Sat): 22:15–10:00
- Blocked if override is ON


**Triggers:**
- `state` (entity_id: binary_sensor.min_temp_fans_bedroom_exceeded, trigger: state)
- `time_pattern` (minutes: /5, trigger: time_pattern)

**Conditions:**
- None

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'state', 'entity_id': 'input_boolean.bedroom_fan_override_off', 'state': 'off'}, {'condition': 'state', 'entity_id': 'binary_sensor.min_temp_fans_bedroom_exceeded', 'state': 'on'}, {'condition': 'or', 'conditions': [{'condition': 'and', 'conditions': [{'condition': 'time', 'after': '21:30:00'}, {'condition': 'template', 'value_template': '{{ now().weekday() in [6, 0, 1, 2, 3] }}'}]}, {'condition': 'and', 'conditions': [{'condition': 'time', 'before': '08:00:00'}, {'condition': 'template', 'value_template': '{{ now().weekday() in [0, 1, 2, 3, 4] }}'}]}, {'condition': 'and', 'conditions': [{'condition': 'time', 'after': '22:15:00'}, {'condition': 'template', 'value_template': '{{ now().weekday() in [4, 5] }}'}]}, {'condition': 'and', 'conditions': [{'condition': 'time', 'before': '10:00:00'}, {'condition': 'template', 'value_template': '{{ now().weekday() in [5, 6] }}'}]}]}], 'sequence': [{'target': {'entity_id': 'switch.bedroom_fans'}, 'action': 'switch.turn_on', 'data': {}}]}, {'conditions': [], 'sequence': [{'target': {'entity_id': 'switch.bedroom_fans'}, 'action': 'switch.turn_off', 'data': {}}]}])

---
### Schedules: Office Fan (Weekdays Temp + Time)

**Description:** Controls the office ceiling fan based on temperature and time: - Active Mon–Fri between office_start and office_end - Turns ON when threshold exceeded and override is OFF - Turns OFF outside of schedule or when threshold no longer exceeded

**Triggers:**
- `state` (entity_id: binary_sensor.min_temp_fans_office_exceeded, trigger: state)
- `time_pattern` (minutes: /5, trigger: time_pattern)

**Conditions:**
- None

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'state', 'entity_id': 'input_boolean.office_fan_override_off', 'state': 'off'}, {'condition': 'state', 'entity_id': 'binary_sensor.min_temp_fans_office_exceeded', 'state': 'on'}, {'condition': 'time', 'after': 'input_datetime.office_start', 'before': 'input_datetime.office_end'}, {'condition': 'template', 'value_template': '{{ now().weekday() in [0, 1, 2, 3, 4] }}'}], 'sequence': [{'target': {'entity_id': 'switch.switch_office_light'}, 'action': 'switch.turn_on', 'data': {}}]}, {'conditions': [], 'sequence': [{'target': {'entity_id': 'switch.switch_office_light'}, 'action': 'switch.turn_off', 'data': {}}]}])

---

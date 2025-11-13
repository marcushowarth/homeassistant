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

---
### Schedules: Landing Lighting

**Description:** Landing light control: weekday/weekend mornings, sunset on, and evening off.


---
### Schedules: Garden Lighting

**Description:** Controls garden lighting: sunrise/morning on, sunset dim, and evening off with weekend variant.


---
### Schedules: House Lighting

**Description:** Automates LED scenes throughout the house by time and weekday.


---
### Schedules: Extension Lamp (Sunrise & Sunset Edge Cases)

**Description:** Controls Tapo L510 lamp on workday mornings before sunrise, and post-sunset only if before 19:45.

---
### Schedules: Bug Zapper Fixed Times

**Description:** Controls Tapo plug for Bug Zapper at fixed times AM and PM.



---
### Schedules: Bug Zapper Motion Activated (Excludes Fixed ON Periods)

**Description:** Turns on bug zapper with kitchen motion between 05:00–22:00, avoids auto-OFF during fixed ON periods (07–10, 17–20:30). Outside 22:00–05:00, zapper will turn off.

**Triggers:**


---
### Schedules: eBike Charger Availability

**Description:** Ensures switch.ebike_charger is ON from sunrise until 20:00 every day.


---
### Schedules: Firestick Reboot (Weekly)

**Description:** Turns off the Amazon Firestick TV switch every Monday from 05:00 to 06:00 to force a reset.


---
### Schedules: Dishwasher Reboot (Weekly)

**Description:** Turns off the Dishwasher switch every Monday from 05:00 to 06:00 to force a reset.

**Triggers:**
- `time` (at: 05:00:00, trigger: time)



---
### Schedules: Christmas Lights (Dec 1 – Jan 1, with Holiday Overnight)

**Description:** Christmas lights ON at sunset and OFF at 23:20 between Dec 1 and Jan 1, except on 24th, 25th, and 31st Dec when they stay ON until sunrise.

**Triggers:**
- `sun` (event: sunset, trigger: sun)
- `time` (at: 23:20:00, trigger: time)
- `sun` (event: sunrise, trigger: sun)



---
### Schedules: Bedroom Fans (Temp + Time Windows)

**Description:** Control bedroom fans based on temperature threshold and time windows.
- Weekdays (Sun–Thu): 21:30-08:00
- Weekends (Fri–Sat): 22:15–10:00
- Blocked if override is ON


---
### Schedules: Office Fan (Weekdays Temp + Time)

**Description:** Controls the office ceiling fan based on temperature and time: - Active Mon–Fri between office_start and office_end - Turns ON when threshold exceeded and override is OFF - Turns OFF outside of schedule or when threshold no longer exceeded

---

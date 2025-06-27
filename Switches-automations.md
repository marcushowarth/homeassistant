# Switches Automations

### Switches: Pool room: Turn off TV if no motion detected

**Description:** 

**Triggers:**
- `state` (trigger: state, entity_id: ['binary_sensor.pool_room_person'], to: off, for: {'hours': 0, 'minutes': 45, 'seconds': 0})

**Conditions:**
- `unknown` (condition: device, type: is_on, device_id: e22bd9643a03ccfdd146071f933bceb0, entity_id: cd7e44c44030b60a17ea655e6d2cbb1b, domain: switch, for: {'hours': 0, 'minutes': 30, 'seconds': 0})

**Actions:**
- `unknown` (type: turn_off, device_id: e22bd9643a03ccfdd146071f933bceb0, entity_id: cd7e44c44030b60a17ea655e6d2cbb1b, domain: switch)

---
### Switches: Pool room: Turn on lamp if dark and motion detected

**Description:** 

**Triggers:**
- `state` (trigger: state, entity_id: ['binary_sensor.pool_room_person'], to: on)

**Conditions:**
- `unknown` (condition: sun, before: sunrise)

**Actions:**
- `unknown` (action: scene.turn_on, metadata: {}, data: {}, target: {'entity_id': 'scene.pool_room_light_blue'})
- `unknown` (delay: {'hours': 0, 'minutes': 10, 'seconds': 0, 'milliseconds': 0})
- `unknown` (type: turn_off, device_id: 884f68553e69441148296ac281012994, entity_id: 48390b26e6605aa1e1fd911cfdfcdbec, domain: light)

---
### Switches: Pool room: Turn off lamp if dark and no motion detected

**Description:** 

**Triggers:**
- `state` (trigger: state, entity_id: ['binary_sensor.pool_room_person'], to: off, for: {'hours': 0, 'minutes': 10, 'seconds': 0})

**Conditions:**
- `unknown` (condition: sun, before: sunrise)

**Actions:**
- `unknown` (type: turn_off, device_id: 884f68553e69441148296ac281012994, entity_id: 48390b26e6605aa1e1fd911cfdfcdbec, domain: light)

---
### Switches: Garden: Turn on corridor (add to calendar) if dark and person detected (CCTV)

**Description:** Activates scene to light corridor if person detected before sunrise and it's currently off. It then uses the IFTTT applet to make calender entry.

**Triggers:**
- `state` (entity_id: binary_sensor.garden_person, to: on, trigger: state)

**Conditions:**
- `unknown` (condition: sun, before: sunrise)
- `unknown` (condition: template, value_template: {{ 
  is_state('light.pool_east', 'off') and
  is_state('light.workshop_west', 'off') and
  is_state('light.patio_east', 'off')
}}
)

**Actions:**
- `unknown` (target: {'entity_id': 'scene.garden_corridor_50'}, action: scene.turn_on, data: {})
- `unknown` (delay: 00:01:00)
- `unknown` (target: {'entity_id': 'scene.garden_off'}, action: scene.turn_on, data: {})
- `unknown` (data: {'event': 'HA_trigger_calendar', 'value1': "[Garden] has detected a person at {{ now().strftime('%H:%M') }}", 'value2': '14 Farmington Ave, Sutton SM1 3PT'}, action: ifttt.trigger)

---
### Switches: Landing: dynamic brightness adjustment overnight

**Description:** Increase brightness on motion during overnight dim, reduce after both sensors clear with a small delay.

**Triggers:**
- `state` (entity_id: ['binary_sensor.motion_hallway_occupancy', 'binary_sensor.motion_landing_occupancy'], to: on, id: motion_on, trigger: state)
- `state` (entity_id: ['binary_sensor.motion_hallway_occupancy', 'binary_sensor.motion_landing_occupancy'], to: off, id: motion_off, trigger: state)

**Conditions:**
- `unknown` (condition: state, entity_id: input_boolean.overnight_dim_active, state: on)

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'trigger', 'id': 'motion_on'}], 'sequence': [{'target': {'entity_id': 'scene.landing_hall_on'}, 'action': 'scene.turn_on'}, {'target': {'entity_id': 'light.controller_rgb_c1f45a'}, 'data': {'brightness_pct': 80}, 'action': 'light.turn_on'}]}, {'conditions': [{'condition': 'trigger', 'id': 'motion_off'}], 'sequence': [{'delay': '00:00:05'}, {'condition': 'and', 'conditions': [{'condition': 'state', 'entity_id': 'binary_sensor.motion_hallway_occupancy', 'state': 'off'}, {'condition': 'state', 'entity_id': 'binary_sensor.motion_landing_occupancy', 'state': 'off'}]}, {'target': {'entity_id': 'scene.landing_hall_off'}, 'action': 'scene.turn_on'}, {'target': {'entity_id': 'light.controller_rgb_c1f45a'}, 'data': {'brightness_pct': 3}, 'action': 'light.turn_on'}]}])

---
### Switches: Kitchen: dynamic lighting on motion

**Description:** Turn on kitchen lights on motion, dim after clear with small delay.

**Triggers:**
- `state` (entity_id: binary_sensor.motion_kitchen_occupancy, to: on, id: motion_on, trigger: state)
- `state` (entity_id: binary_sensor.motion_kitchen_occupancy, to: off, id: motion_off, trigger: state)

**Conditions:**
- `unknown` (condition: state, entity_id: input_boolean.overnight_dim_active, state: on)

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'trigger', 'id': 'motion_on'}], 'sequence': [{'target': {'entity_id': ['light.kitchen_floor_strip_light', 'light.kitchen_fridge_light_strip']}, 'data': {'brightness_pct': 100}, 'action': 'light.turn_on'}]}, {'conditions': [{'condition': 'trigger', 'id': 'motion_off'}], 'sequence': [{'delay': '00:00:05'}, {'condition': 'state', 'entity_id': 'binary_sensor.motion_kitchen_occupancy', 'state': 'off'}, {'target': {'entity_id': ['light.kitchen_floor_strip_light', 'light.kitchen_fridge_light_strip']}, 'data': {'brightness_pct': 3}, 'action': 'light.turn_on'}]}])

---
### Switches: Utility Room: dynamic lighting on motion

**Description:** Turn on utility room light on motion, dim after clear with small delay.

**Triggers:**
- `state` (entity_id: binary_sensor.motion_utility_occupancy, to: on, id: motion_on, trigger: state)
- `state` (entity_id: binary_sensor.motion_utility_occupancy, to: off, id: motion_off, trigger: state)

**Conditions:**
- `unknown` (condition: state, entity_id: input_boolean.overnight_dim_active, state: on)

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'trigger', 'id': 'motion_on'}], 'sequence': [{'target': {'entity_id': 'light.controller_rgb_c1f544'}, 'data': {'brightness_pct': 60}, 'action': 'light.turn_on'}]}, {'conditions': [{'condition': 'trigger', 'id': 'motion_off'}], 'sequence': [{'delay': '00:00:05'}, {'condition': 'state', 'entity_id': 'binary_sensor.motion_utility_occupancy', 'state': 'off'}, {'target': {'entity_id': 'light.controller_rgb_c1f544'}, 'data': {'brightness_pct': 3}, 'action': 'light.turn_on'}]}])

---
### Switches: Landing: dynamic evening after sunset

**Description:** Increase brightness on motion during overnight dim, reduce after both sensors clear with a small delay.

**Triggers:**
- `state` (entity_id: ['binary_sensor.motion_hallway_occupancy', 'binary_sensor.motion_landing_occupancy'], to: on, id: motion_on, trigger: state)
- `state` (entity_id: ['binary_sensor.motion_hallway_occupancy', 'binary_sensor.motion_landing_occupancy'], to: off, id: motion_off, trigger: state)

**Conditions:**
- `unknown` (condition: state, entity_id: input_boolean.overnight_dim_active, state: off)
- `unknown` (condition: sun, after: sunset)

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'trigger', 'id': 'motion_on'}], 'sequence': [{'target': {'entity_id': ['scene.landing_on_bright']}, 'action': 'scene.turn_on', 'data': {}}]}, {'conditions': [{'condition': 'trigger', 'id': 'motion_off'}], 'sequence': [{'delay': '00:00:05'}, {'condition': 'and', 'conditions': [{'condition': 'state', 'entity_id': 'binary_sensor.motion_hallway_occupancy', 'state': 'off'}, {'condition': 'state', 'entity_id': 'binary_sensor.motion_landing_occupancy', 'state': 'off'}]}, {'target': {'entity_id': ['scene.landing_off']}, 'action': 'scene.turn_on', 'data': {}}]}])

---
### Switches: Utility: dynamic evening after sunset

**Description:** Increase brightness on motion after sunset, reduce after sensor clears with a small delay.

**Triggers:**
- `state` (entity_id: ['binary_sensor.motion_utility_occupancy'], to: on, id: motion_on, trigger: state)
- `state` (entity_id: ['binary_sensor.motion_utility_occupancy'], to: off, id: motion_off, trigger: state)

**Conditions:**
- `unknown` (condition: state, entity_id: input_boolean.overnight_dim_active, state: off)
- `unknown` (condition: sun, after: sunset)

**Actions:**
- `unknown` (choose: [{'conditions': [{'condition': 'trigger', 'id': 'motion_on'}], 'sequence': [{'target': {'entity_id': 'light.controller_rgb_c1f544'}, 'data': {'brightness_pct': 100}, 'action': 'light.turn_on'}]}, {'conditions': [{'condition': 'trigger', 'id': 'motion_off'}], 'sequence': [{'delay': '00:00:05'}, {'condition': 'state', 'entity_id': 'binary_sensor.motion_utility_occupancy', 'state': 'off'}, {'target': {'entity_id': 'light.controller_rgb_c1f544'}, 'data': {'brightness_pct': 60}, 'action': 'light.turn_on'}]}])

---
### Switches: Pool room: Turn on cross trainer fans if hot and motion detected

**Description:** 

**Triggers:**
- `state` (trigger: state, entity_id: ['binary_sensor.pool_room_person'], to: on)

**Conditions:**
- `unknown` (condition: numeric_state, entity_id: sensor.workshop_temperature, above: input_number.min_temp_fans_workshop)

**Actions:**
- `unknown` (type: turn_on, device_id: c2538969a005b978a1aeeb0549ff0b1d, entity_id: e2022028bb105f89442376c67e10f9fe, domain: switch)

---
### Switches: Pool room: Turn off cross trainer fans if no motion detected

**Description:** 

**Triggers:**
- `state` (trigger: state, entity_id: ['binary_sensor.pool_room_person'], to: off, for: {'hours': 0, 'minutes': 15, 'seconds': 0})

**Conditions:**
- None

**Actions:**
- `unknown` (type: turn_off, device_id: c2538969a005b978a1aeeb0549ff0b1d, entity_id: e2022028bb105f89442376c67e10f9fe, domain: switch)

---
### Switches: Workshop: Blink bulb Green if Door Bell Visitor

**Description:** Blinks the workshop alert bulb GREEN for 1 minute when the doorbell rings.

**Triggers:**
- `state` (entity_id: binary_sensor.door_bell_visitor, to: on, trigger: state)

**Conditions:**
- None

**Actions:**
- `unknown` (repeat: {'sequence': [{'data': {'rgb_color': [0, 255, 0], 'brightness': 255}, 'target': {'entity_id': 'light.alert_bulb'}, 'action': 'light.turn_on'}, {'delay': '00:00:01'}, {'target': {'entity_id': 'light.alert_bulb'}, 'action': 'light.turn_off', 'data': {}}, {'delay': '00:00:01'}], 'until': [{'condition': 'template', 'value_template': '{{ repeat.index >= 30 }}'}]})

---
### Switches: Workshop: Blink bulb Red if Person Detected (Drive East)

**Description:** Blinks the workshop alert bulb RED for 30 seconds when a person is detected on the Drive East camera.

**Triggers:**
- `state` (entity_id: binary_sensor.drive_east_person, to: on, trigger: state)

**Conditions:**
- None

**Actions:**
- `unknown` (repeat: {'sequence': [{'data': {'rgb_color': [255, 0, 0], 'brightness': 255}, 'target': {'entity_id': 'light.alert_bulb'}, 'action': 'light.turn_on'}, {'delay': '00:00:01'}, {'target': {'entity_id': 'light.alert_bulb'}, 'action': 'light.turn_off', 'data': {}}, {'delay': '00:00:01'}], 'until': [{'condition': 'template', 'value_template': '{{ repeat.index >= 15 }}'}]})

---
### Switches: Workshop: Blink bulb Blue if Person Detected in Royston Alley

**Description:** Blinks the workshop alert bulb BLUE for 30 seconds when a person is detected in Royston Alley.

**Triggers:**
- `state` (entity_id: binary_sensor.royston_alley_person, to: on, trigger: state)

**Conditions:**
- None

**Actions:**
- `unknown` (repeat: {'sequence': [{'data': {'rgb_color': [0, 0, 255], 'brightness': 255}, 'target': {'entity_id': 'light.alert_bulb'}, 'action': 'light.turn_on'}, {'delay': '00:00:01'}, {'target': {'entity_id': 'light.alert_bulb'}, 'action': 'light.turn_off', 'data': {}}, {'delay': '00:00:01'}], 'until': [{'condition': 'template', 'value_template': '{{ repeat.index >= 15 }}'}]})

---

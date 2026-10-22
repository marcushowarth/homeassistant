# Home Automation Stack 🏡

![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-41BDF5?logo=home-assistant&logoColor=white)
![Zigbee2MQTT](https://img.shields.io/badge/Zigbee2MQTT-FFCC00?logo=zigbee&logoColor=black)
![Mosquitto](https://img.shields.io/badge/MQTT-660066?logo=eclipsemosquitto&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-10.6.22--Debian-003545?logo=mariadb&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20LTS-E95420?logo=ubuntu&logoColor=white)


## 🔗 Home Assistant Intro

A good intro/background to our setup can be [found here](https://foxesscommunity.com/viewtopic.php?t=633) 

## 🔗 Home Assistant Automation Summaries

A categorized breakdown of key automations in this Home Assistant setup:

- [📈 Energy Automations](README-energy-automations.md)  
  High-level automations for managing battery charging, grid import/export settings, and tariff-based behavior using Octopus Flux and PV forecasts to limit overnight charge levels using .

- [⏰ Schedules Automations](README-schedules-automations.md)  
  Time-based routines for indoor and outdoor lighting, appliances (e.g. dishwasher, Firestick), and seasonal behaviors like Christmas lights.

- [💡 Switches Automations](README-switches-automations.md)  
  Motion-activated and context-aware control of lights, fans, and other smart switches throughout the home, often with dynamic brightness or temperature-based logic.

- [💡 Scripts](README-scripts-automations.md)  
  Making the most of Free Electricity sessions or handy tasks like turning off the garden lights at bedtime. 

## 🔗 Notes

- [💡 Entities Config example](entities/README.md)
  No longer required but helpful to keep where manual config may not be available through the UI.

---
# Home Assistant, Mosquitto MQTT, and Zigbee2MQTT Setup

This project runs a Home Automation stack using Docker Compose.  
It includes:

- 🏡 **Home Assistant** – Main home automation platform
- 📡 **Mosquitto** – MQTT broker
- 🧠 **Zigbee2MQTT** – Zigbee network manager and bridge
- 🗄️ **MariaDB** – Home Assistant's recorder database
- 🎬 **Plex** – media server
- 🔋 **Predbat** – battery planner (sandboxed trial)

---

## 🐳 Docker Compose Services

| Service         | Purpose                         | URL                             |
|-----------------|----------------------------------|---------------------------------|
| Home Assistant  | Main dashboard and automations   | http://farmington:8123          |
| Mosquitto MQTT  | MQTT broker for Zigbee and HA     | MQTT on `farmington:1883`       |
| Zigbee2MQTT     | Zigbee device controller + UI    | http://farmington:8080          |
| MariaDB         | Recorder database                | port `3307`                     |
| Plex            | Media server                     | port `32400`                    |
| Predbat         | Battery planner (read-only trial) | host network                   |

The MariaDB passwords come from a git-ignored `.env` next to the compose file. Copy `.env.example` to `.env` and fill it in before `docker compose up`.

---

## 📋 How to Use

```bash
# Start everything
docker compose up -d

# Stop everything
docker compose down

# See running containers
docker compose ps

# View logs (live follow)
docker compose logs -f

# Pull updated images
docker compose pull

# Restart a single service
docker compose restart zigbee2mqtt
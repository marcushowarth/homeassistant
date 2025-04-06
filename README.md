# Home Automation Stack 🏡

![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-41BDF5?logo=home-assistant&logoColor=white)
![Zigbee2MQTT](https://img.shields.io/badge/Zigbee2MQTT-FFCC00?logo=zigbee&logoColor=black)
![Mosquitto](https://img.shields.io/badge/MQTT-660066?logo=eclipsemosquitto&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20LTS-E95420?logo=ubuntu&logoColor=white)

---
# Home Assistant, Mosquitto MQTT, and Zigbee2MQTT Setup

This project runs a Home Automation stack using Docker Compose.  
It includes:

- 🏡 **Home Assistant** – Main home automation platform
- 📡 **Mosquitto** – MQTT broker
- 🧠 **Zigbee2MQTT** – Zigbee network manager and bridge

---

## 🐳 Docker Compose Services

| Service         | Purpose                         | URL                             |
|-----------------|----------------------------------|---------------------------------|
| Home Assistant  | Main dashboard and automations   | http://farmington:8123          |
| Mosquitto MQTT  | MQTT broker for Zigbee and HA     | MQTT on `farmington:1883`       |
| Zigbee2MQTT     | Zigbee device controller + UI    | http://farmington:8080          |

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
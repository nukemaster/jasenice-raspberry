# jasenice-raspberry
## Configuration
Edit configuration 
- install/opt/RPi-Reporter-MQTT2HA-Daemon/**config.ini** *(configure sending device metricts to HA)* 
```sh 
sensor_name <- name of 
device hostname <- IP of mqtt server 
username, password <- credentials to mqtt 
``` 
- install/etc/jasenice/**DS18B20_ensureOn.py** *(checking 1w 
sensors and reset them if needed)* 
```sh
  sensors <- contains list of tuples (pin id, sensor name) 
``` 
- install/etc/jasenice/**mqttio_config.yml** *(configure comunication with HA)* 
[documentation](https://mqtt-io.app/2.2.9/#/). Sensor needs to be in sections **sensor_modules** and **sendor_inputs** 
```sh 
mqtt.host <- IP of mqtt 
server mqtt.user, mqtt.password <- credentials to mqtt 
mqtt.ha_discovery.name <- name of device 
```
## Instalation
After all configuration in files is done (can be run multiple times to apply changes in configuration) 
```sh 
sudo ./install.sh 
``` 
This script should download and install all dependencies, copy configuration files to proper places and setup services. To watch service status (can be useful to debug 
problems) 
```sh 
watch systemctl status mqttio.service 
watch systemctl status DS18B20_ensure.service 
watch systemctl status RPiReporter.service
```

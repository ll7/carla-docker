# CARLA mit Docker

## Versionen der Images

|Paket              |Version                    |
|-------------------|---------------------------|
|CARLA              |carlasim/carla:0.9.10.1    |
|CARLA-ROS-Bridge   |carla-ros-bridge:0.9.10.1  |
|CARLA-Docker       |carla/docker:0.1.0         |

## Installation der Images
 
1. Navigieren Sie in den Ordner, den sie aus dem Archiv extrahiert haben
2. Öffnen sie ein Terminal in diesem Ordner und führen sie das Makefile (mit dem Befehl `make`) aus 
   > Sie können die Images mit dem Makefile auch einzeln installieren:
   > - ```make carla``` : Installiert das Paket ```CARLA``` und ```CARLA-Docker```
   > - ```make ros-bridge``` : Installiert das Paket ```CARLA-ROS-Bridge```

## Starten der Container

### Zu Beginn (nicht bei jedem Starten der Container)

Um den Containern den Zugriff auf den Hostrechner für das Rendering mittels der GPU und für die lokalen Ports zu gewähren, führen sie folgenden Befehl einmal zu Beginn aus:
```
sudo xhost +local:root
```

### Beim Beenden (falls der Rechner nicht heruntergefahren wird)

Um den Zugriff wieder rückgängig zu machen, führen Sie folgenden Befehl aus.
```
sudo xhost -local:root
```

### Starten des CARLA-Servers

Um den CARLA-Server mit dem Standard-Image zu starten, führen Sie folgenden Befehl aus:
```
docker run --rm -p 2000-2002:2000-2002 --net=host --runtime=nvidia --gpus all -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 carlasim/carla:0.9.10.1 /bin/bash -c './CarlaUE4.sh -ResX=800 -ResY=600 -nosound -windowed -opengl'
```

### Starten des Clients

Um den Client mit einer interaktiven Konsole zu starten, um beispielsweise die PythonAPI via ```python3``` zu benutzen, führen Sie folgenden Befehl aus:
```
docker run --rm -it -p 2000-2002:2000-2002 --net=host --runtime=nvidia --gpus all -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 carla/docker:0.1.0 /bin/bash
```

### Starten der ROS-Bridge:

Um die ROS-Bridge zu starten, führen Sie zunächst die Datei `run.sh` innerhalb des Ordners ```ros-bridge``` aus:
```
cd ros-bridge/docker/
./run.sh
```
Dies startet den Container mit einer interaktiven Konsole, in der sie via `roslaunch` die gewohnten ROS-Pakete starten können:
```
roslaunch carla_ros_bridge carla_ros_bridge.launch
```

## Erklärung der Sourcedateien/-ordner

### carla_docker

Innerhalb des Dockerfile wird dem Image die Ubuntu Standard-Truetype Schriftart mitgegeben und das Paket ```fontconfig``` installiert. Grund dafür ist, dass das HUD von CARLA bzw. das vom HUD benutzte Paket ```pygame``` auf ```fontconfig``` zugreift, um eine Standardschriftart von Ubuntu zu bekommen. Da das Betriebssystem des Images keine Schriftarten enthält, wird ihm die bereitgestellte mitgegeben.
> Eine Anleitung für das Installieren einer Schriftart in Docker-Images ist in der Datei ```add_font.txt``` beschrieben.

### docker

Dieser Ordner ersetzt den Ordner ```docker``` innerhalb der ROS-Bridge bei der Installation. Die Gründe dafür sind:
- Versionierung: Statt den Tag ```latest``` zu verwenden wird dem Docker-Image die aktuelle Version der ROS-Bridge als Tag zugewiesen.
- Ausführungsablauf: Statt den Container standardmäßig mit der ROS-Bridge zu starten, erlaubt die modifizierte Datei ```run.sh``` mittels ```roslaunch``` in der interaktiven Konsole die Pakete manuell auszuführen.
- Versionswechsel: Das vom Github-Repository bereitgestellte Docker-Image verwendet nicht die neueste Version ```0.9.10.1``` der ROS-Bridge. Das angepasste Dockerfile ermöglicht dies.

## Bekannte Fehler

### Treiberprobleme des ROS-Bridge Containers

Obwohl der CARLA-Client mit der PythonAPI ein Fenster für ein EgoVehicle erzeugen kann, bekommt man bei dem selben Versuch innerhalb des Containers der ROS-Bridge folgende Fehlermeldung:
```
libGL error: No matching fbConfigs or visuals found
libGL error: failed to load driver: swrast
X Error of failed request:  GLXBadContext
  Major opcode of failed request:  151 (GLX)
  Minor opcode of failed request:  6 (X_GLXIsDirect)
  Serial number of failed request:  98
  Current serial number in output stream:  97
```
Dies hängt dem Anschein nach damit zusammen, dass der Container nicht die richtigen Treiber für das Anzeigen eines Fenster der GPU besitzt. Nach einer Recherche ist es dem Anschein nach möglich, dem Container den spezifischen Treiber der GPU mitzugeben, was den Container aber nur auf einer speziellen GPU ausführbar macht.
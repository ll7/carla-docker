FROM carlasim/carla:0.9.10.1

USER root

RUN mkdir -p /usr/share/fonts/truetype/ubuntu
ADD /fonts/truetype/ubuntu /usr/share/fonts/truetype/ubuntu

RUN apt-get update
RUN apt-get install fontconfig python3-pip libtiff5-dev libjpeg-dev -y
RUN apt-get update
RUN pip3 install -r PythonAPI/util/requirements.txt

USER carla

RUN echo "export PYTHONPATH=${PYTHONPATH}:~/PythonAPI/carla/dist/carla-0.9.10-py3.7-linux-x86_64.egg" >> ~/.bashrc
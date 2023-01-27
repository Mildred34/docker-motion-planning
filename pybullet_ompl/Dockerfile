FROM ubuntu:22.04

LABEL Alexis Hou "alexis.hou@instar-robotics.com"

# Ajouter un utilisateur
RUN useradd -ms /bin/bash alex

# Paramètre d'environnement
ENV HOME=/home/alex
ENV WS=/home/alex/workspace

# Going to home
WORKDIR $HOME

# Dépendences à lancer en root
RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
 git-all

RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
inetutils-ping \
vim \
findutils

RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
wget

RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
unzip

RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
gedit \
gdb \
meld \
kate \
exuberant-ctags \
python3 \
python3.10-venv

RUN apt-get -y upgrade && apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
python3-pip

# Going to workspace
RUN mkdir workspace
WORKDIR $WS

# Copy motion planning folder into workspace
COPY ./motion-planning .

# Dépendences pybullets
# Création d'un environnement
#CMD python -m venv env

# Activation de l'environnement
# RUN  . ./env/bin/activate

RUN DEBIAN_FRONTEND=noninteractive pip3 install \
pybullet

# Install dependencies of the package
RUN DEBIAN_FRONTEND=noninteractive pip3 install -r \
requirements.txt

WORKDIR $HOME

# OMPL Installation
# Copy Script to install ompl
# Volume is shared only at the end of building
COPY ./install-ompl-ubuntu.sh .
RUN DEBIAN_FRONTEND=noninteractive chmod u+x install-ompl-ubuntu.sh
RUN DEBIAN_FRONTEND=noninteractive ./install-ompl-ubuntu.sh --python

# Quitter l'environnement
# RUN  deactivate

#RUN git config --global user.email alexis.hou@instar-robotics.com && \
#    git config --global user.name midred34

# Réduction de la taille de l'image
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

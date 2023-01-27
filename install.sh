#!/usr/bin/env bash

# Logging
declare -A levels=([DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3)
script_logging_level="DEBUG"

# CONSTANT PARAMETERS
VERSION_SCRIPT="V0.3"
VERSION_IMAGE="0.2"

# PARAMETERS
CONFIG="DEFAULT" # DEFAULT or NVIDIA
HELP=false
VERSION=false
MODE="DEFAULT"

# Color logs, display only the level you want and add an header like 'debug',...
logThis() {
    local log_message=$1
    local log_priority=$2

    #check if level exists
    [[ ${levels[$log_priority]} ]] || return 1

    #check if level is enough
    (( ${levels[$log_priority]} < ${levels[$script_logging_level]} )) && return 2

    #log here
    if [ ${levels[$log_priority]} == ${levels[DEBUG]} ]; then
      echo -e "\e[36m${log_priority} : ${log_message}\e[0m"
    elif [ ${levels[$log_priority]} == ${levels[INFO]} ]; then
      echo "${log_priority} : ${log_message}"
    elif [ ${levels[$log_priority]} == ${levels[WARN]} ]; then
      echo -e "\e[33m${log_priority} : ${log_message}\e[0m"
    elif [ ${levels[$log_priority]} == ${levels[ERROR]} ]; then
      echo -e "\e[31m${log_priority} : ${log_message}\e[0m"
    fi
}

function print_usage
{
    echo "Usage: install.sh [-h]"
    echo ""
    echo "This script create a docker image"
    echo "for the trooper project"
    echo "And then launch a container"
    echo ""
    echo "Options:"
    echo "-h --help : Display help"
    echo ""
}

function print_version
{
  echo $VERSION_SCRIPT
  echo ""
}


POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    HELP=true
    shift # past argument
    shift # past value
    ;;
    -v|--version)
    VERSION=true
    shift # past argument
    shift # past value
    ;;
    -c|--config)
    CONFIG="$2"
    shift # past argument
    shift # past value
    ;;
    -m|--mode)
    MODE="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


# Test arguments
if [ "${HELP}" == true ]; then
	print_usage
    exit 0
elif [ "${VERSION}" == true ]; then
  print_version
    exit 0
fi

# Interruption
control_c() {
    local result

    logThis "Une interruption keyboard a été détectée." "WARNING"
    logThis "Arrêt du script..." "INFO"

    exit 1
}

# Interruption si ctrl+C
trap control_c SIGINT

# Création de l'image
logThis "Création de l'image de notre docker..." "INFO"
docker-compose build pybullet_ompl

# Lancement du container
logThis "Lancement du container..." "INFO"

# Docker Containers with X11 support
docker-compose run pybullet_ompl

logThis "Votre container est lancé..." "INFO"
logThis "N'oubliez pas de retirer les permission pour le display avec la commande xhost -local:root en fin d'utilisation !" "WARNING"

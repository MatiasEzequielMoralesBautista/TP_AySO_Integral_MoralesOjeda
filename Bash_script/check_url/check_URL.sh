#!/bin/bash
clear

###############################
#
# Parametros:
#  - Lista Dominios y URL
#
#  Tareas:
#  - Se debera generar la estructura de directorio pedida con 1 solo comando con las tecnicas enseñadas en clases
#  - Generar los archivos de logs requeridos.
#
###############################
LISTA=$"/home/vagrant/repogit/UTN-FRA_SO_TP-Integral/Bash_script/check_url/Lista_URL.txt"

LOG_FILE=$"/var/log/status_url.log"

# Creo la siguiente estructura
sudo mkdir -p /home/vagrant/tmp/head-check/{Error/{cliente,servidor},ok/}

ANT_IFS=$IFS
IFS=$'\n'

#---- Dentro del bucle ----#
for LINEA in $(grep -v '^#' "$LISTA" | awk '{print $1, $2}'); do

  DOMINIO=$(echo "$LINEA" | awk '{print $1}')
  URL=$(echo "$LINEA" | awk '{print $2}')
  # Obtener el código de estado HTTP
  STATUS_CODE=$(curl -LI -o /dev/null -w '%{http_code}\n' -s "$URL")
  # Fecha y hora actual en formato yyyymmdd_hhmmss
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")


  # Registrar en el archivo /var/log/status_url.log
  echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" |sudo tee -a  "$LOG_FILE"

  # Dejo el archivo de dominio.log correspondiente

  OK=200
  CLIENTE=400
  SERVIDOR=500

  if [[ $STATUS_CODE == $OK ]]; then
      sudo touch "/home/vagrant/tmp/head-check/ok/$DOMINIO.log"
  fi

  if [[ ( $STATUS_CODE -ge $CLIENTE ) && ( $STATUS_CODE -lt $SERVIDOR ) ]]; then
      sudo touch "/home/vagrant/tmp/head-check/Error/cliente/$DOMINIO.log"
  fi

  if [[ ( $STATUS_CODE -ge $CLIENTE ) && ( $STATUS_CODE -lt $SERVIDOR ) ]]; then
      sudo touch "/home/vagrant/tmp/head-check/Error/servidor/$DOMINIO.log"
  fi

done
#-------------------------#

IFS=$ANT_IFS

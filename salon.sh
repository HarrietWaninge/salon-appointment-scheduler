#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -c"

echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then echo -e "\n$1"
  fi

# get all services 
LIST_OF_SERVICES=$($PSQL "select service_id,name from services")
# read all services
echo "$LIST_OF_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do 
if [[
echo "$SERVICE_ID, $SERVICE_NAME"
done


# print all services 

# ask and read answer

}

MAIN_MENU 
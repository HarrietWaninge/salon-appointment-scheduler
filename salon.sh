#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"
echo -e "\n Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]
  then echo -e "\n$1\n"
  fi

# get all services 
LIST_OF_SERVICES=$($PSQL "select * from services order by service_id")
# read all services
echo "$LIST_OF_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do 
echo "$SERVICE_ID) $SERVICE_NAME"
done

# ask and read answer
read SERVICE_ID_SELECTED

# check if service is number
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
# if service is not a number, send to main
then
MAIN_MENU "Please enter a number"
else
# if service is a number, check if it is the id of a service
SERVICE_NAME=$($PSQL "select regexp_replace(name, '^\s+\s+$', '', 'g') from services where service_id = $SERVICE_ID_SELECTED")
#regexp_replace(eventdate, '^\s+|\s+$', '', 'g')
echo "$SERVICE_NAME"
if [[ -z $SERVICE_NAME  ]]
then
# if service doesn't exist, send back to main
MAIN_MENU "That is not an existing service" 
fi
fi
# customer has entered valid service.
# get phone number 
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
# check if customer already exists
if [[ -z $CUSTOMER_NAME ]]
then 
# if it doesn't exist, create new customer 
echo -e "\nI don't have a record for that phone number, what's your name?"
# ask name 
read CUSTOMER_NAME
# insert into customer database
INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
fi
FORMATTED_SERVICE=$(echo "$SERVICE_NAME" | sed -E 's/^[ \t]*//;s/[ \t]*$//')

echo "What time would you like your $FORMATTED_SERVICE, $CUSTOMER_NAME?"



}

MAIN_MENU 
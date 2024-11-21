#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"
echo -e "\n Welcome to My Salon, how can I help you?\n"

FORMAT_RESULT() {
  echo $(echo $1 | sed -E 's/^[ \t]*//;s/[ \t]*$//')
}

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

 case $SERVICE_ID_SELECTED in
    1) HANDLE_SERVICE ;;
    2) HANDLE_SERVICE ;;
    3) HANDLE_SERVICE ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac

# check if service is number
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  # if service is not a number, send to main
  then
  MAIN_MENU "Please enter a number"
  else
  # if service is a number, check if it is the id of a service
  SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")

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

echo "What time would you like your $(FORMAT_RESULT "$SERVICE_NAME"), $(FORMAT_RESULT "$CUSTOMER_NAME")?"

read SERVICE_TIME

CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
echo "I have put you down for a $(FORMAT_RESULT "$SERVICE_NAME") at $SERVICE_TIME, $CUSTOMER_NAME."
}


MAIN_MENU 


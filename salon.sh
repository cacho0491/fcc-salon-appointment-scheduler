#! /bin/bash

echo -e "\n~~~~ MY SALON ~~~~"
echo -e "\nWelcome to my Salon, how can I help you?\n"

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  if [[ $1 ]]
    then
      echo -e "\n$1"
  fi

  SERVICES_SELECTION=$($PSQL "SELECT * FROM services ORDER BY service_id")
  echo "$SERVICES_SELECTION" | while read SERVICE_ID BAR SERVICE_NAME
    do
      echo "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) BOOK 1 cut ;;
    2) BOOK 2 color;;
    3) BOOK 3 perm ;;
    4) BOOK 4 style ;;
    5) BOOK 5 trim ;;
    6) EXIT ;;
    *) MAIN_MENU "Sorry I could not find that service! Please try again:" ;;
  esac
}

BOOK() {
  echo "Service ID, $1, $2"
  echo "What's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # if phone dosen't exists
  if [[ -z $CUSTOMER_ID ]]
    then
      # get user name and insert into customers table
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

        echo -e "\nAt what time would you like your appointment?"
      read SERVICE_TIME
      # insert into appointments table
      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $1, '$SERVICE_TIME')")

      echo -e "\nI have put you down for a $2 at $SERVICE_TIME, $CUSTOMER_NAME."

  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
     echo -e "\nAt what time would you like your appointment?"
      read SERVICE_TIME
      # insert into appointments table
      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $1, '$SERVICE_TIME')")

      echo -e "\nI have put you down for a $2 at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
  

  # if success added to table
  # show message
  # show main_menu
}

COLOR() {
  echo "Color"
}

PERM() {
  echo "Perm"
}

STYLE() {
  echo "Style"
}

TRIM() {
  echo "Trim"
}

EXIT() {
  echo -e "\nThanks for stopping by\n"
}

MAIN_MENU

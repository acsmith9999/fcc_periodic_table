#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#check for argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  #check if argument is numeric
  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    #search by element number
    ELEMENT=$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1;")
  else
    #search by symbol or name
    ELEMENT=$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1' OR name = '$1';")
  fi
  #cannot find element
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    #echo element props
    echo $ELEMENT | while IFS="|" read TYPE_ID ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT SYMBOL NAME TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi





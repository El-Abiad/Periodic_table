#!/bin/bash 

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# No input is provided
if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi
# Fetch id 
if [[ $1 =~ ^[0-9]+$ ]]; then
  atomic_number=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
else
  atomic_number=$($PSQL "SELECT atomic_number FROM elements WHERE symbol ILIKE '$1' OR name ILIKE '$1';")
fi
# No recored found
if [[ -z $atomic_number ]]; then
  echo "I could not find that element in the database."
  exit 0
fi
# Get all the info
name=$($PSQL "SELECT name FROM elements WHERE atomic_number=$atomic_number;")
symbol=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$atomic_number;")
type_id=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$atomic_number;")
type=$($PSQL "SELECT type FROM types WHERE type_id=$type_id;")
atomic_mass=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$atomic_number;")
melting_point=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$atomic_number;")
boiling_point=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$atomic_number;")
# display the info
echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."

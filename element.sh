#!/bin/bash

# Database connection command
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Function to get element information
get_element_info() {
  local query="SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number = '$1' OR e.symbol = '$1' OR e.name = '$1';"
  echo $($PSQL "$query")
}

# Check if argument is provided
if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Get element information
element_info=$(get_element_info "$1")

# Check if element exists
if [ -z "$element_info" ]; then
  echo "I could not find that element in the database."
else
  IFS='|' read -r atomic_number name symbol type atomic_mass melting_point_celsius boiling_point_celsius <<< "$element_info"
  echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
fi

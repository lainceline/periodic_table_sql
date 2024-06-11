#!/bin/bash

# Database connection details
DB_NAME="periodic_table"
DB_USER="your_db_user"
DB_HOST="your_db_host"
DB_PORT="your_db_port"

# Function to get element information
get_element_info() {
  local query="
    SELECT
      e.atomic_number,
      e.name,
      e.symbol,
      p.type,
      p.atomic_mass,
      p.melting_point_celsius,
      p.boiling_point_celsius
    FROM elements e
    JOIN properties p ON e.atomic_number = p.atomic_number
    WHERE e.atomic_number = '$1' OR e.symbol = '$1' OR e.name = '$1';
  "
  psql -U $DB_USER -d $DB_NAME -h $DB_HOST -p $DB_PORT -t -c "$query"
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

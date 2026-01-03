#! /bin/bash

#here we will have the name validation that is used by both database and table
#used in database_functions/create_db.sh and table_functions/create_table.sh
#use :- source ./common.sh in the script to use it


#function for name validation 

validate_name() {
#check if name is empty
    local name="$1"
    if [[ -z "$name" ]]; 
    then
     echo "ERROR: Name cannot be empty"
     return 1
    fi

#check if name is valid for database and table
    if ! echo "$name" | grep -q "^[a-zA-Z]"
    then
     echo "ERROR: Name must start with a letter"
     return 1
    fi

#check that the name conntain vaild characters are used (letters,nums,underscore)
    if ! echo "$name" | grep -q "^[a-zA-Z0-9_]*$" 
    then
     echo "Error: Name can only contain letters, numbers, and underscores"   
     return 1
    fi

#check that the name is too long (-Eq is for extended regular expression)
 if ! echo "$name" | grep -Eq "^.{1,30}$"
 then
  echo "Error: Name is too long (max 30 characters)"
  return 1
 fi

# if all checks pass, return 0
 return 0
 
    
}

#DATABASE DIRECTORY WHERE ALL DATABASES ARE STORED
DATABASE_DIR="./databases"
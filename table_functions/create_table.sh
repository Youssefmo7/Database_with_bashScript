#!/bin/bash

# the script will create a new table in the current database
#it create two files:
# 1.tablename.meta  : for the metadata of the table
# 2.tablename.data  : for the actual data of the table


source ./common.sh

#laod name validation from common.sh
source ./common.sh

echo ""
echo "============== CREATE TABLE =============="
echo ""

#read and validate the table name from user

while true;
    do
    echo -n "Enter table name (or 'q' to quit): "
    read table_name
    
    if [[ "$table_name" == "q" ]]; then
        echo "Operation cancelled."
        exit 0
    fi
    
    if validate_name "$table_name"; then
        break  # valid name - exit the loop
    fi

done


#check if the table already exists
if [-f "$CURRENT_DB/$table_name.meta" ]; 
 then
    echo "Error: Table '$table_name' already exists."
    exit 1
fi

# Get number of columns from user
while true;
do 
    echo -n "Enter number of columns :"
    read num_columns 
    # check if the number of columns is equals to a number and greater than 0
    if [[ "$num_columns" =~ ^[0-9]+$ ]] && [ "$num_columns" -gt 0 ]; 
    then
        break
    else
        echo "Error: Invalid number of columns."
        echo "Please enter a valid number greater than 0."
    fi
done


#create empty metadata file
# '>' this command will create a new file and overwrite the existing one if it exists

> "$CURRENT_DB/$table_name.meta"

echo ""
echo "Define your columns:"
echo "(Data types: int, string)"
echo "(Primary key: pk)"
echo ""

#loop through the number of columns and ask the user for the column name and type
#i will create a counter from 1 to num_columns
col_counter=1
while ["$col_counter" -le "$num_columns"];
do 
    echo -n "Enter column $col_counter name: "
    read col_name

    # check if the column name is valid
    if validate_name "$col_name"; then
        break
    else
        echo "Error: Invalid column name."
        echo "Please enter a valid column name."
    fi
done

# get the data type from user
while true;
do
    echo -n "Enter data type for column $col_name (int, string): "
    read col_type
# check if the data type is valid 
if [[ "$col_type" == "int" || "$col_type" == "string" ]]; 
   then
    break
else
    echo "Error: Invalid data type."
    echo "Please enter a valid data type (int, string)."
    fi
done

# get the primary key from user
while true;
do
    echo -n "Is this column a primary key? (y/n): "
    read primary_column
    if [[ "$primary_column" == "y" || "$primary_column" == "n" ]];
    then
        break
    else
        echo "Error: Invalid primary key."
        echo "Please enter a valid primary key (y/n)."
    fi
done

#valdiate that the primary key is unique
if [[ "$primary_column" == "y" ]];
then
    #check if the primary key is already in the metadata file
    if grep -q "^$col_name:$col_type:pk:" "$CURRENT_DB/$table_name.meta";
    then
        echo "Error: Primary key must be unique."
        exit 1
    fi
fi

#validate data type
#convert to lowercase for comparison why?
#because the data type is stored in the metadata file in lowercase
col_type=$(echo "$col_type" | tr '[:upper:]' '[:lower:]')
if [[ "$col_type" != "int" && "$col_type" != "string" ]];
then
    echo "Error: Invalid data type."
    echo "Please enter a valid data type (int, string)."
    exit 1
fi

#add the column to the metadata file
#the meta format is: column_name:data_type:primary_key

echo "$col_name:$col_type:$primary_column" >> "$CURRENT_DB/$table_name.meta"
echo ""

#increment the column counter
col_counter=$((col_counter + 1))
done

#create empty data file
> "$CURRENT_DB/$table_name.data"

echo "Table '$table_name' created successfully."

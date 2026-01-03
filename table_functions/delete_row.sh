#!/bin/bash

#in this script it will delete a row from the table
#it will delete a row using the primary key


source ./common.sh

echo ""
echo "============== DELETE ROW =============="
echo ""

#show available tables
echo "Tables in $CURRENT_DB_NAME:"
for meta_file in "$CURRENT_DB"/*.meta
do
#check if the file is a regular file
    if [ -f "$meta_file" ]
    then
#get the table name from the meta file
        basename "$meta_file" .meta
    fi
done
echo ""

#ask which table to delete

echo "Enter table name:"
read table_name

#check if the table exists
if [ ! -f "$CURRENT_DB/$table_name.meta" ]
then 
    echo "Error: Table '$table_name' does not exist."
    exit 1
fi

#get the meta and data files
meta_file="$CURRENT_DB/$table_name.meta"
data_file="$CURRENT_DB/$table_name.data"

#check if the table has data
#-s checks if file has content (size > 0)
if [ ! -s "$data_file" ]
then 
    echo "No data in table '$table_name'."
    exit 0
fi


#get the primary key from the metadata file using awk
#the meta format is: column_name:data_type:primary_key
#so $3 is the primary key (stored as "pk" or "n")
# {print $1} prints the first column (primary key)
primary_key=$(awk -F: '$3 == "pk" {print $1}' "$meta_file")

#ask for the primary key value
echo "Enter the primary key value to delete:"
read primary_key_value

#check if the primary key value exists in the table
if ! grep -q "^$primary_key_value:" "$data_file";
then
    echo "Error: Primary key value '$primary_key_value' does not exist in table '$table_name'."
    exit 1
fi

#show the row to be deleted to check if the user wants to delete it or not
echo ""
echo "========== ROW TO BE DELETED =========="
echo ""

# awk -F to set the field separator to colon
# -v pk="$primary_key_value" to set the primary key value
# $1 == pk {print $0} to print the row if the primary key value matches
awk -F: -v pk="$primary_key_value" '$1 == pk {print $0}' "$data_file"
echo ""

#ask for confirmation
echo "Are you sure you want to delete this row? (y/n):"
read confirm

#^[yY][eE]?[sS]?$ is a regex to match yes or yes with any case 
if [[ "$confirm" =~ ^[yY][eE]?[sS]?$ ]]
then
  #create a temporary file to store the data without the row to be deleted
  temp_file=$(mktemp)
  #-F: to set the field separator to colon
  #-v pk="$primary_key_value" to set the primary key value
  #$1 != pk {print $0} to print the row if the primary key value does not match
  awk -F: -v pk="$primary_key_value" '$1 != pk {print $0}' "$data_file" > "$temp_file"
  mv "$temp_file" "$data_file"
  echo "Row deleted successfully."
else
    echo "Deletion cancelled."
fi
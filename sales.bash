#!/bin/bash

##########################################################################
#
#AUTHOR: Triantafyllidis Antonios
#DATE: 15/2/2018
#
#Script desciption: 
# This script allows the user to insert records of people and the amount
# of sales they made. It calculates the bonus that each person receives based 
# on the amount of sales they did. 
#
# The user can enter multiple records or one by one and later save those records in
# a file. 
#
# The user can count how many records exist in the file and also display them
# sorted alphabetically by the name of the salesperson or by the amount of sales.
#
# The user can also sort and display records that he hasn't saved in the file also.
#
# 
#
#How to run this script:
# There might be a possibility to install gcc in order to run this script.
# Normally you should follow the following directions.
# 1. Navigate to the directory the script resides from the terminal.
# 2. Type in: chmod 755 sales.sh
# 3. Press enter and type in: ./sales.sh
# 4. The menus will guide you through the various jobs you would like to accomplish.
# 5. Voila!
#
#
#
#What the script requires:
# The script requires:
#  For the insertion of a new salesperson:
#   A name which starts with a capital letter and has at least one more letter
#   A sales amount either integer or double regardless of size
#   
#   State the number of entries that the user will insert as multiple entries. Only integers allowed here.
#
#   Integers for the navigation in the menus
#
#
#
#
#What is the output and where it goes:
# The script outputs the user's bonus in the console when a user is entered to the system. 
# Any warning messages are displayed in the console.
# Records listing and records counting on the console.
# The records are saved in a file named "records.txt" placed in the same directory the script resides.
# The script never replaces the file. It appends to it.
#
#
#Assumptions the script makes about its environment:
# The script will create a file named "records.txt" to the directory it resides when the user 
# chooses to save the inserted records into a file.
#
# To display the records from the file, the file MUST be on the same directory the script is in. 
# It is recommended to not mess with records.txt or if you do delete a record, make sure you leave no new lines in the txt.
#
##########################################################################


#Making sure that wherever this script is run from, there will be no problem finding the records.txt.
#...As long as records.txt is IN THE SAME directory...
THISSCRIPT="$(realpath "$0")"
THISSCRIPTSDIR="${THISSCRIPT%/*}"
dynamicPathOfRecords="$THISSCRIPTSDIR/records.txt"

#The array that serves as a temporary buffer
declare -a arrayOfRecords


##########################################################################
##############FUNCTION DECLARATION START
##########################################################################

#This function counts all the records in the records.txt
function countRecords {
    #Check if the file exists first
    if [[ -f $dynamicPathOfRecords ]]; then
        #Declare an array
        declare -a arrayToCount
        #Loop through the rows of the file and insert them one by one in the array
        while IFS= read -r line; do arrayToCount+=("$line"); done < "$dynamicPathOfRecords"
        #Print the number of indexes in the arrow.
        echo "The file contains ${#arrayToCount[@]} records."
    else
        echo "There is no file created. Please insert new records first."
    fi
    
}

###########################################################################################################################################

# Takes ONE arguement, one array to sort in the format: array[@]
function bubbleSortAndDisplay {
    #This array holds the array passed as arguement to the function
    declare -a arrayToSort=("${!1}")

    #Declaring local variable that will be used to determine which word to keep from the String row that comes from the file
    local stringPositionCutter=1

    #Controls if the user input validation is completed
    local exitApproved=false
    #Loop here to keep the user in this loop until he enters the right input

    while [ "$exitApproved" = false ]
    do
    printf "How would you like the records to be sorted? \n 1. By Name \n 2. By Sales \n"
    read option

    #Validate input
    #Options are 1 or 2 
    if [[ $option =~ ^[1]{1}$ ]]; then
    stringPositionCutter=1
    exitApproved=true
    elif [[ $option =~ ^[2]{1}$ ]]; then
    stringPositionCutter=2
    exitApproved=true
    else
    echo "Not a valid option selected. Please try again."
    exitApproved=false
    fi
    done

    #Get the length of the array that was filled by the records from records.txt
    len="${#arrayToSort[@]}"

    #Bubblesorting the array
    for (( i = 0; i < $len; i++ ))
    do
        for (( j = $i; j < $len; j++ ))
        do
            #Get the current row
            currentRow=${arrayToSort[$i]}
            #Depending on what the user chose, get either the name or the amount of sales from the current row
            substrCurrentRow=$(echo $currentRow | cut -d " " -f $stringPositionCutter)
            #Get the next row
            nextRow=${arrayToSort[$j]}
            #Depending on what the user chose, get either the name or the amount of sales from the next row
            substrNextRow=$(echo $nextRow | cut -d " " -f $stringPositionCutter)

            #If the user selected to sort by names
            if [ $stringPositionCutter -eq 1 ]; then
                #Treat the comparison variables as Strings
                if [ "$substrCurrentRow" \> "$substrNextRow" ]; then
                    #lines change places with each other if the condition is true
                    buffer=${arrayToSort[$i]}
                    arrayToSort[$i]=${arrayToSort[$j]}
                    arrayToSort[$j]=$buffer
                fi
            else
                #Treat the comparison variables as numbers
                if [ $substrCurrentRow -gt $substrNextRow ]; then
                    #lines change places with each other if the condition is true
                    buffer=${arrayToSort[$i]}
                    arrayToSort[$i]=${arrayToSort[$j]}
                    arrayToSort[$j]=$buffer
                fi
            fi
        done
    done
    #Once the sorting is completed, display the sorted records
    printf "Displaying previous records... \n"

    #This loop puts a pound symbol (£) before the sales amount and bonus amount before printing them
    for (( x = 0; x < $len; x++ ))
    do
        element=${arrayToSort[$x]}
        elementItemSales=$(echo $element | cut -d " " -f 2)
        element=$(echo $element | sed s/$elementItemSales/"£""$elementItemSales"/)
        elementItemBonus=$(echo $element | cut -d " " -f 3)
        echo $element | sed s/" "$elementItemBonus/" £""$elementItemBonus"/
    done
}
###########################################################################################################################################

function displayRecordsFromBuffer {
    # Sorting the global arrayOfRecords that serves as a temporary buffer
    local len=${#arrayOfRecords[@]}
    if [ $len -eq 0 ]
        then
        printf "\nNo records to display.\n"
    else
        bubbleSortAndDisplay arrayOfRecords[@]
    fi
}



###########################################################################################################################################

#This function reads inserted records from records.txt and echoes them.
function displayRecordsFromFile {

#Declaring an array that will be used to store all records from the file
declare -a arrayToDisplayFromFile



if [[ -f $dynamicPathOfRecords ]]; then
        #The IFS before read prevents leading/trailing whitespace from being trimmed.
    #The -r option prevents backslash escapes from being interpreted.
    #This loop reads a line from records.txt and assigns it in the last index of the arrayToSort array
    #When it ends, it re-reads the file to check if there are extra lines.
    #If there are it runs again until there is nothing else to display.
    while IFS= read -r line; do arrayToDisplayFromFile+=("$line"); done < "$dynamicPathOfRecords"

    # Passing the array to the sorting function
    bubbleSortAndDisplay arrayToDisplayFromFile[@]
    

    else
        echo "There is no file created. Please insert new records first."
fi
}  




###########################################################################################################################################


#This function adds a new record
function addNewSalesman {

#The two variables that will be used to determine if the input was correct
salesPersonOK=false
salesAmountOK=false


while [ "$salesPersonOK" = false ];
do
    echo "Please type in the name of the Salesperson:"
    read salesPerson
    if [[ $salesPerson =~ ^[A-Z]{1}[a-z|A-Z]+$ ]]
        then
        salesPersonOK=true
    else
        echo "Your input was invalid. Only alphabetical characters allowed.The first letter must be capital and the name must be at least 2 characters long."
        salesPersonOK=false
    fi
done

#Same logic with sales as well
while [ "$salesAmountOK" = false ];
do
    echo "Please type in the monetary amount that the person made in sales: "
    read QuarterlySales

    if [[ $QuarterlySales =~ ^([0-9]+)[\.]([0-9]+)$ ]]
        then
        salesAmountOK=true
    elif [[ $QuarterlySales =~ ^[0-9]+$ ]]
        then
        salesAmountOK=true
    else
        echo "Your input was invalid. Only integers or floating point numbers are allowed."
        salesAmountOK=false
    fi
done

#Basic calculator is used to ensure that floating numbers and long integers will be calculated normally.
#A local variable is also used for good practice, as global variables are to be avoided when possible.
local bonus=0

if (( $(bc <<< "$QuarterlySales <= 99999") ))
    then
    bonus=0
elif (( $(bc <<< "$QuarterlySales >= 100000") && $(bc <<< "$QuarterlySales <= 999999") ))
    then
    bonus=750
else
    bonus=1500
fi

echo "Employee "$salesPerson" made £"$QuarterlySales" and for that receives £"$bonus" bonus."

#Add that entry to the buffer
arrayOfRecords+=("$salesPerson"" ""$QuarterlySales"" ""$bonus")

}  


###########################################################################################################################################

#Inserts multiple records in the buffer array
function addMultipleRecords {

    local numberOfEntriesOK=false
    #Do not exit this loop unless the user inputs a valid number for inserts
    while [[ "$numberOfEntriesOK" = false ]]; do
        printf "Please enter the number of records you would like to add. \n"
        read numberOfEntries
        #Validate user input that it is a number
        if [[ $numberOfEntries =~ ^[0-9]+$ ]]; then
            #totalNumber variable represents the number the array should have after the user insertion
            totalNumber=$(($numberOfEntries + ${#arrayOfRecords[@]}))
            #While the array does NOT contain that many records keep asking input from the user
            while [[ "${#arrayOfRecords[@]}" -lt totalNumber ]];
            do
                addNewSalesman
            done
            numberOfEntriesOK=true
        else
            echo "Only numbers are allowed."
        fi

    done
    
}


###########################################################################################################################################

#Saves all the records that exist in the buffer array into the file
function saveRecords {
    local len=${#arrayOfRecords[@]}
    if [ $len -lt 1 ]
        then
        echo "There are no records kept in the temporary buffer."
    else
        for (( i = 0; i < $len; i++ ))
        do
            echo ${arrayOfRecords[$i]} >> "$THISSCRIPTSDIR/records.txt"
        done
        echo ${#arrayOfRecords[@]} " records were succesfully inserted to records.txt"
        unset arrayOfRecords
    fi
}

##########################################################################
##############FUNCTION DECLARATION END    
##########################################################################







#Printf is used so that we can use the new line character \n
printf "\nWelcome to the Sales Archiver \n\n"

exitApproved=false

#This is the loop the program runs and according to the choice of the user, the corresponding function is called. 
while [ "$exitApproved" = false ];
do
    printf "\nSelect an option by typing the corresponding number and press enter. \n 
    1. Display records from file \n 
    2. Display Records from temporary catalog (The temprary catalog is discarded when you exit the program)\n
    3. Insert one new Record \n 
    4. Insert Multiple Records \n 
    5. Count Records in file \n 
    6. Save Records to File \n
    0. Exit \n"
    read choice

#If the user's input is 1 then invoke the function to display the existing records
if [[ $choice =~ ^[1]{1}$ ]]
    then 
    displayRecordsFromFile
elif [[ $choice =~ ^[2]{1}$ ]]
    then 
    displayRecordsFromBuffer
#If the user's input is 2 then invoke the function to input a new record
elif [[ $choice =~ ^[3]{1}$ ]]
    then
    printf "The temporary catalog contains "${#arrayOfRecords[@]}" employees. \n"
    addNewSalesman
elif [[ $choice =~ ^[4]{1}$ ]]
    then
    printf "The temporary catalog contains "${#arrayOfRecords[@]}" employees. \n"
    addMultipleRecords
elif [[ $choice =~ ^[5]{1}$ ]]
    then 
    countRecords
elif [[ $choice =~ ^[6]{1}$ ]]
    then
    saveRecords
#If 0 then the program exits
elif [[ $choice =~ ^[0]{1}$ ]]
    then
    exitApproved=true
else
    echo "Not a valid option selected. Please try again."
fi
done

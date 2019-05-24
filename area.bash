##########################################################################
#
#AUTHOR: Triantafyllidis Antonios
#DATE: 2/2/2018
#
#Script desciption: 
# This script is used to convert the area of a rectangle 
# from centimeters into square centimetres and in square inches
#
#How to run this script:
# There might be a possibility to install gcc in order to run this script.
# Normally you should follow the following deirections.
# 1. Navigate to the directory the script resides from the terminal.
# 2. Type in: chmod 755 area.sh
# 3. Press enter and type in: ./area.sh
# 4. Voila!
#
#What the script requires:
# The script will ask for the width and height of the rectangle in centimeters.
# The script accepts floating point numbers as well
#
#What is the output and where it goes:
# The script outputs the area of the rectangle in centimeters and square inches
# The result is displayed as soon as the user inputs correctly width and height on the console.
#
##########################################################################



#The two variables that will be used to determine if the input was correct



##########################################################################
##############FUNCTION DECLARATION START
##########################################################################

function calculate {
local widthOK=false
local heightOK=false
#while widthOK variable is not true, the while loop will continue to ask input
#the widthOK variable changes to true only when the user inputs either an integer or decimal number
#in any other case of input the variable remains false
while [ "$widthOK" = false ];
do
    echo "Please type in the width of the rectangle in cm:"
    read width
    if [[ $width =~ ^([0-9]+)[\.]([0-9]+)$ ]]
        then
        widthOK=true
    elif [[ $width =~ ^[0-9]+$ ]]
        then
        widthOK=true
    else
        echo "Your input was invalid. Only integers or floating point numbers are allowed."
        widthOK=false
    fi
done

#Same logic with height as well
while [ "$heightOK" = false ];
do
    echo "Please type in the height of the rectangle in cm: "
    read height
    if [[ $height =~ ^([0-9]+)[\.]([0-9]+)$ ]]
        then
        heightOK=true
    elif [[ $height =~ ^[0-9]+$ ]]
        then
        heightOK=true
    else
        echo "Your input was invalid. Only integers or floating point numbers are allowed."
        heightOK=false
    fi
done

#Using the here-string (<<<) instead of pipe to avoid running the command to the right side of pipe in a new subshell.
#This has happened having resources in mind.
#The -l is so that the basic calculator to include decimal operations.
#The square area of the rectangle is calculated by width x height
area=$(bc -l <<< "$width*$height")


#Area in inches is calculated by first converting width and height to inches and then multyplying them together
areaInches=$(bc -l <<< "($width / 2.54)*($height / 2.54)")
#To calculate square meters, the square centimeters are divided by 10000 (1 square cm = 0.0001 square meter)
squareMeters=$(bc -l <<< "$area / 10000")

#print the results
echo "The area of the rectangle in Square Meters is " $squareMeters
echo "The area of the rectangle in Square Inches is " $areaInches
}

##########################################################################
##############FUNCTION DECLARATION END
##########################################################################


echo "Welcome to the rectangle calculator!"

exitApproved=false

#This is the loop the program runs and according to the choice of the user, the corresponding function is called. 
while [ "$exitApproved" = false ];
do
    printf "\nSelect an option by typing the corresponding number and press enter. \n 1. Calculate areas \n 0. Exit \n"

    read choice

    if [[ $choice =~ ^[1]{1}$ ]]
        then
        calculate
    elif [[ $choice =~ ^[0]{1}$ ]]
        then
        exitApproved=true
    else
        echo "Your input was invalid. Please choose one of the menu options."
    fi
done


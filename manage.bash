#!/usr/bin/sudo bash
##########################################################################
#
#AUTHOR: Triantafyllidis Antonios
#DATE: 15/2/2018
#
#Script desciption: 
# This script is used to create, delete, edit users and groups. Also to create
# scheduled backups of a directory in crontab on a time frequency or in a specific date.
#
#
#
#How to run this script:
# There might be a possibility to install gcc in order to run this script.
# Normally you should follow the following directions.
# 1. Navigate to the directory the script resides from the terminal.
# 2. Type in: chmod 755 manage.sh
# 3. Press enter and type in: ./manage.sh
# 4. The menus will guide you through the various jobs you would like to accomplish.
# 5. Voila!
#
#
#
#What the script requires:
# This script depends in no additional files to run.
# For backup files and their output see below.
#
#
#What is the output and where it goes:
# Once the user has created a scheduled backup, the file crontab.txt is created,
# in the same directory as this script. The crontab file is mandatory in order a cronjob 
# to be scheduled. 
# Backup outputs go to the directory the user stated.
#
#
#Assumptions the script makes about its environment:
# In order to insert a new job in cron, the script must use the crontab.txt with the generated
# cron job through THIS script!
#
#
#
##########################################################################

#Globals
completeStringDate=""
completeStringRegInterval=""
THISSCRIPT="$(realpath "$0")"
THISSCRIPTSDIR="${THISSCRIPT%/*}"
dynamicPathOfCronFile="$THISSCRIPTSDIR/cron.txt"
#Globals


##########################################################################
##############FUNCTION DECLARATION START
##########################################################################


########
# STRING FORMATING FUNCTIONS START
# Functions that format strings and print them on the terminal
########

# Takes a string as arguement and prints it with red coloring
function showErrorMessage {
    stringToPrint="$1"
    tput setab 1
    tput bold
    printf "$stringToPrint"
    tput sgr0
    tput setaf 7
}

# Takes a string as arguement and prints it with blue coloring
function showNotificationMessage {
    stringToPrint="$1"
    tput setab 4
    tput bold
    printf "$stringToPrint"
    tput sgr0
    tput setaf 7
}

########
# STRING FORMATING FUNCTIONS END
########




########
# TIME CONVERTION FUNCTIONS START
# Functions that convert portions of time and create a pattern that will be used to set the frequency of the execution of the cron job.
########
function convertMinutes {
    local num=$1
    local min="*"
    local hour="*"
    local day="*"
    local month="*"
    local weekDay="*"

    local symbol="*/"

    if((num>59));then
        ((min=num%60))
        min="$symbol$min"
        ((hour=num/60))
        hour="$symbol$hour"
    else
        ((min=num))
        min="$symbol$min"
    fi
    
    #Global
    completeStringRegInterval="$min $hour $day $month $weekDay"
    
}

function convertHours {
    local num=$1
    local min="*"
    local hour="*"
    local day="*"
    local month="*"
    local weekDay="*"


    local symbol="*/"

    if((num>23));then
        ((hour=num%24))
        hour="$symbol$hour"
        ((day=num/24))
        day="$symbol$day"
    else
        ((hour=num))
        hour="$symbol$hour"
    fi
    
    #Global
    completeStringRegInterval="$min $hour $day $month $weekDay"
}

function convertDays {
    local num=$1
    local min="*"
    local hour="*"
    local day="*"
    local month="*"
    local weekDay="*"
    
    local symbol="*/"

    if((num>30));then
        ((day=num%31))
        day="$symbol$day"
        ((month=num/31))
        month="$symbol$month"
    else
        ((day=num))
        day="$symbol$day"
    fi
    
    #Global
    completeStringRegInterval="$min $hour $day $month $weekDay"
}

########
# TIME CONVERTION FUNCTIONS END
########

#################################################################################################################################
#################################################################################################################################

# Function that will form a cron date and time pattern by taking input from the user. 
# This function affects the completeStringDate Global variable
function getTimeAndDate {
    # m h d m w
    local minute
    local hour
    local day
    local month
    local weekday="*"

    local minuteOK=false    
    local hourOK=false
    local dayOK=false
    local monthOK=false

    showNotificationMessage "Setting all variables as * will backup the directory every minute.\n"
        # Loop through the input until the user inserts the correct number. 
    while [[ "$monthOK" = false ]]; do
        printf "\nInsert the month:\nTo not define a specific month, press *\nFrom 1 to 12\n"
        read month
        if [[ $month =~ ^([1-9]|1[0-2])$ ]]; then
            monthOK=true
            # Accept asterisks as input.
        elif [[ $month =~ ^\*$ ]]; then
            month="*"
            monthOK=true
        else
            monthOK=false
            showErrorMessage "Incorrect input. Please try again\n"
        fi
    done
        # Loop through the input until the user inserts the correct number. 
    while [[ "$dayOK" = false ]]; do
        printf "\nInsert the day of the month:\nTo not define a specific day, press *\nFrom 1 to 31\n"
        read day
        if [[ $day =~ ^([1-9]|1[0-9]|2[0-9]|3[0-1])$ ]]; then
            dayOK=true
            # Accept asterisks as input.
        elif [[ $day =~ ^\*$ ]]; then
            day="*"
            dayOK=true
        else
            dayOK=false
            showErrorMessage "Incorrect input. Please try again\n"
        fi
    done
    # Loop through the input until the user inserts the correct number. 
    while [[ "$hourOK" = false ]]; do
        printf "\nInsert the hour:\nTo not define a specific hour, press *\nFrom 0 to 23\n"
        read hour
        if [[ $hour =~ ^([0-9]|1[0-9]|2[0-3])$ ]]; then
            hourOK=true
            # Accept asterisks as input.
        elif [[ $hour =~ ^\*$ ]]; then
            hour="*"
            hourOK=true
        else
            hourOK=false
            showErrorMessage "Incorrect input. Please try again\n"
        fi
    done
    # Loop through the input until the user inserts the correct number. 
    while [[ "$minuteOK" = false ]]; do
        printf "\nInsert the minute:\nTo not define a specific minute, press *\nFrom 0 to 59\n"
        read minute
        if [[ $minute =~ ^([0-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9]|5[0-9])$ ]]; then
            minuteOK=true
            # Accept asterisks as input.
        elif [[ $minute =~ ^\*$ ]]; then
            minute="*"
            minuteOK=true
        else
            minuteOK=false
            showErrorMessage "Incorrect input. Please try again\n"
        fi
    done
    
    #Global
    completeStringDate="$minute $hour $day $month $weekday"
}




#################################################################################################################################


# Function that will form a cron date and time frequency pattern by taking input from the user. 
# This function calls, based on user input the time conversion functions
function getRegularInterval {
    local choice
    local interval

    local inputOK=false

    local minutesOK=false
    local hoursOK=false
    local daysOK=false

    # Keep asking the user for input until he selects the correct number that corresponds to a menu
    while [[ "$inputOK" = false ]]; do
        printf "\nIn what form would you like to set the frequency of the backup?\n
        1. Minutes\n
        2. Hours\n
        3. Days\n
        4. Back\n"

        read choice
        if [[ $choice =~ ^[1]{1}$ ]]
            then 
            inputOK=true
            while [[ "$minutesOK" = false ]]; do
                # 1440 minutes are 24 hours. Making sure that the user will not input more than 24 hours in the form of minutes. 
                # There is a different menu for that. 
                printf "Please insert every how many minutes would you like your directory to be saved.\n"
                read interval

                if [[ $interval -le 1440 && $interval -ge 1 ]]; then
                    minutesOK=true
                    convertMinutes $interval
                else 
                    showErrorMessage "\nInvalid input. Maximum range 1440 minutes = 24 hours. Please try again.\n"
                    minutesOK=false
                fi
            done
        elif [[ $choice =~ ^[2]{1}$ ]]
            then
            inputOK=true
            while [[ "$hoursOK" = false ]]; do
                 # 720 hours are 30 days. Making sure that the user will not input more than 30 days in the form of hours. 
                # There is a different menu for that. 
                printf "Please insert every how many hours would you like your directory to be saved.\n"
                read interval
                if [[ $interval -le 720 && $interval -ge 1 ]]; then
                    hoursOK=true
                    convertHours $interval
                else 
                    showErrorMessage "\nInvalid input. Maximum range 720 hours = 30 days. Please try again.\n"
                    hoursOK=false
                fi
            done
        elif [[ $choice =~ ^[3]{1}$ ]]
            then
            inputOK=true
            while [[ "$daysOK" = false ]]; do
                 # 365 days are 12 months. Making sure that the user will not input more than 12 months in the form of days. 
                # The user can use the menu that accepts a date rather than frquency. Frequency is for shorter periods of backup, hence why, the user is allowed to set, up to a year here. 
                printf "Please insert every how many days would you like your directory to be saved.\n"
                read interval
                if [[ $interval -le 365 && $interval -ge 1 ]]; then
                    dayOK=true
                    convertDays $interval

                else 
                    showErrorMessage "\nInvalid input. Maximum range 365 days = 12 months. Please try again.\n"
                    daysOK=false
                fi
            done
        elif [[ $choice =~ ^[4]{1}$ ]]
            then
            return
        else
            inputOK=false
            showErrorMessage "\nInvalid option. Please try again.\n"
        fi
    done
    
}


#################################################################################################################################


# This function forms the cronjob string that will be inserted into the cron file before inserting the job to crontab.
function gatherCronInfo {
    tput clear
    #Get the source directory
    local sourceDirectory
    printf "\nPlease copy and paste the path of the directory you would like to save.\n
    Navigate to the directory you want via the terminal and issue the command 'pwd'. Copy and paste the path here.\n
    The path must not have a slash in the end.\n"
    read sourceDirectory

    #Get the destination directory
    local destinationDirectory
    printf "\nPlease copy and paste the path of the directory you would like to store the backups into.\n
    Navigate to the directory you want via the terminal and issue the command 'pwd'. Copy and paste the path here.\n
    The path must not have a slash in the end.\n"
    read destinationDirectory

    local choice
    local timeAndDate
    local choiceOK=false
    #Make sure to keep the user in the loop until he selects something valid
    while [[ "$choiceOK" = false ]]; do
        #The user can select to either have his directory backedup at a specific date or in regular intervals
        # The appropriate functions will be invoked.
        printf "\nYou can either set a date and time that you want to back-up the directory or you can set a time interval to back up the directory.\n
        1. Set in date/time\n
        2. Set a time interval\n"
        read choice

        if [[ $choice =~ ^[1]{1}$ ]]
            then 
            choiceOK=true
            getTimeAndDate
            echo "$completeString"
        elif [[ $choice =~ ^[2]{1}$ ]]
            then
            choiceOK=true
            getRegularInterval
        else
            choiceOK=false
            tput setab 1
            showErrorMessage "Invalid option. Please try again.\n"
        fi
    done
    
    # Keeps the begining of the name of the compressed backup
    local backupFileName="/backup_"
    # Keeps the command that will be inserted in the cron file and everytime the job runs, this command will output the date that the job ran.
    # Used for putting the date to the compressed file name
    local backupFileNameDate="\$(date +\%Y-\%m-\%d_\%H:\%M:\%S)"
    # Gets the folder name that will be backedup by taking that part out of the sourceDirectory String
    # Used as part of the compressed backed up file, when the user selects for one to not be created.
    local backUpGenericName=${sourceDirectory##/*/}
    # THe file extension of the compressed file. 
    local backupFileNameEnding=".tar.gz"
    # The file name of the log file
    local logFileName="/log.txt"

    local backupDate="\$(date -r $destinationDirectory$logFileName +\%H:\%M:\%S)"
    local dateOneTime=$(date +\%Y-\%m-\%d_\%H:\%M:\%S)

    read -p "Would you like a new archive to be created every time the backup happens?[y/n]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
        then
        showNotificationMessage "\nNew file will be created.\n"
        # First create an initial zip of the directory.
        tar zcvf $destinationDirectory$backupFileName$dateOneTime$backupFileNameEnding $sourceDirectory &> $destinationDirectory$logFileName; cat $destinationDirectory$logFileName | zenity --text-info --title=\"Backup Manager\" --display=:0.0 &>/dev/null
        # Give permissions to the user for both the archive and the log file.
        chmod a+rwx $destinationDirectory$backupFileName$dateOneTime$backupFileNameEnding
        chmod a+rwx $destinationDirectory$logFileName
        # If completeStringDate global variable is null, it means that completeStringRegInterval isn't
        if [[ -z "$completeStringDate" ]]; then
            # Hence use completeStringRegInterval
            # Echoing the string into the cron file
            # Everytime the cron job is executed, zenity is used to display in a form, the files that were backed up
            echo "$completeStringRegInterval tar zpcvf $destinationDirectory$backupFileName$backupFileNameDate$backupFileNameEnding $sourceDirectory --after-date=$backupDate &> $destinationDirectory$logFileName; cat $destinationDirectory$logFileName | zenity --text-info --title=\"Backup Manager\" --display=:0.0 " >> "$THISSCRIPTSDIR/cron.txt" 
            startCron "$THISSCRIPTSDIR/cron.txt"
        elif [[ -z "$completeStringRegInterval" ]]; then
            echo "$completeStringDate tar zpcvf $destinationDirectory$backupFileName$backupFileNameDate$backupFileNameEnding $sourceDirectory --after-date=$backupDate &> $destinationDirectory$logFileName; cat $destinationDirectory$logFileName | zenity --text-info --title=\"Backup Manager\" --display=:0.0 " >> "$THISSCRIPTSDIR/cron.txt" 
            startCron "$THISSCRIPTSDIR/cron.txt"   
        fi
    else
        # First create an initial zip of the directory.
        tar zcvf $destinationDirectory$backupFileName$backUpGenericName$backupFileNameEnding $sourceDirectory &> $destinationDirectory$logFileName; cat $destinationDirectory$logFileName | zenity --text-info --title=\"Backup Manager\" --display=:0.0 &>/dev/null
        # Give permissions to the user for both the archive and the log file.
        chmod a+rwx $destinationDirectory$backupFileName$backUpGenericName$backupFileNameEnding
        chmod a+rwx $destinationDirectory$logFileName
        showNotificationMessage "\nNo new file will be created.\n"
        if [[ -z "$completeStringDate" ]]; then
            echo "$completeStringRegInterval tar czpvf $destinationDirectory$backupFileName$backUpGenericName$backupFileNameEnding $sourceDirectory &> $destinationDirectory$logFileName; cat $destinationDirectory$logFileName | zenity --text-info --title=\"Backup Manager\" --display=:0.0 " >> "$THISSCRIPTSDIR/cron.txt"  
            startCron "$THISSCRIPTSDIR/cron.txt"
        elif [[ -z "$completeStringRegInterval" ]]; then
            echo "$completeStringDate tar czpvf $destinationDirectory$backupFileName$backUpGenericName$backupFileNameEnding $sourceDirectory &> $destinationDirectory$logFileName; cat $destinationDirectory$logFileName | zenity --text-info --title=\"Backup Manager\" --display=:0.0 " >> "$THISSCRIPTSDIR/cron.txt" 
            startCron "$THISSCRIPTSDIR/cron.txt"
        fi
    fi
}

##################################################################################################################################################
# This function resets the crotab list of the current user, and refills it with jobs that reside into the cron file
# The path of the cron file is passed as arguement. 
function startCron {
    local pathOfCronTXT=$1
    crontab -u $USER -r &>/dev/null
    crontab -u $USER $pathOfCronTXT
    showNotificationMessage "Cronjob is added!"
}

##################################################################################################################################################

# Adds new group to the system after validations are made to the input of the user. 
function addNewGroup {

    local exitApproved=false
    local groupName
    local groupNameOK=false

    # Validating the groupname

    while [ "$groupNameOK" = false ];
    do
        echo -n "Enter the name for the new group please: "
        read groupName
        # Accepting letters and numbers minimum 1 maximum 32 characters
        if [[ $groupName =~ ^[a-z|A-Z|0-9]{1,32}$ ]]
            then
            groupNameOK=true
        else
            showErrorMessage "\nYour input was invalid. Alphabetical and numerical characters allowed. Max length is 32 characters."
            groupNameOK=false
        fi
    done

    #Verify that there isn't a group with the same name
    groupadd $groupName > /dev/null 2>&1
    resultState=$?
    if [[ resultState -eq 9 ]]; then
        showErrorMessage "\nThere is already a group with that name. \n"
        return
    elif [[ resultState -eq 0 ]]; then
        showNotificationMessage "\nGroup $groupname was added succesfully! \n"
    else
        showErrorMessage "\nThere was a problem with the group creation. Please try again \n"
        return
    fi
}




##################################################################################################################################################


# Adds a new user to the system after certain validations are made to the user's input.
function addNewUser {

    local exitApproved=false

    local unameOK=false
    local passOK=false

    local uname
    local passwd

    # Validating the username

    while [ "$unameOK" = false ];
    do
        echo -n "Enter the username of the new user please: "
        read uname
        # Accepting letters and numbers minimum 1 maximum 32 characters
        if [[ $uname =~ ^[a-z|A-Z|0-9]{1,32}$ ]]
            then
            unameOK=true
        else
            showErrorMessage "\n Your input was invalid. Alphabetical and numerical characters allowed. Max length is 32 characters."
            unameOK=false
        fi
    done

    #Searches if there is a user with that name.
    #If that command finds a user it returns 1
    #The output of stdout and stderr are redirected (both standard output and errors) to /dev/null 
    #https://askubuntu.com/questions/474556/hiding-output-of-a-command
    id $uname > /dev/null 2>&1
    if [ ! $? -eq 1 ] 
        # If the previous command returns 1, it means that a user is found by that name
        # The function informs the user and returns
        then    
        showNotificationMessage "User $username does already exist."
        echo "Please choose another username."
        return
    fi 

    # Validating password 

    while [ "$passOK" = false ];
    do
        printf "Enter the password for the new user please: "
        read -s passwd
         # Accepting letters and numbers minimum 1 maximum 32 characters
         if [[ $passwd =~ ^[a-z|A-Z|0-9]{1,32}$ ]]
            then
            passOK=true
        else
            showErrorMessage "\nYour input was invalid. Alphabetical and numerical characters allowed. Max length is 32 characters."
            passOK=false
        fi
    done

    #  Adding the user
    #https://gist.github.com/thimbl/877090
    useradd -p "$passwd" -d /home/"$uname" -m -g users -s /bin/bash "$uname"
    if [[ $? ]]; then
        showNotificationMessage "\nUser $uname is added succesfully!"
    elif [[ ! $? ]]; then
        showErrorMessage "\nThere was a problem with the creation of the new account. \n Please try again."
        return
    fi
}

##################################################################################################################################################


# Deletes a group from the system, not the primary one, and as long as the requested group exists.
function deleteGroup {
    local groupToDelete

    printf "\nPlease type in the name of the group to delete: \n"

    read groupToDelete
    # Searches for the name of the group requested in the group list
    # Output is redirected to dev/null
    egrep -i -w "^$groupToDelete" /etc/group > /dev/null 2>&1
    local resultState1=$?
    # the output of the command is stored in a variable
    if [[ $resultState1 -eq 0 ]]; then
        # 0 means that a group is found by the requested name
        showNotificationMessage "\nA group was found by that name.\n"
        # asking confirmation from the user
        read -p "Are you sure you want to delete? [y/n]" -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]
            then
            # delete the requested group. All output that this command might print to the terminal is silenced. 
            groupdel $groupToDelete > /dev/null 2>&1
            local resultState2=$?
            # return status 8 is the error number for an attempt to delete the primary group.
            if [[ resultState2 -eq 8 ]] 
                then
                showErrorMessage "\nYou cannot delete primary user's group. You need to delete the user first.\n"
                return
                # return status 0 means that the function executed normally and without any errors
            elif [[ resultState2 -eq 0 ]]; then
                showNotificationMessage "\nGroup $groupToDelete is deleted!\n"
            fi
        else
            showNotificationMessage "\nDeletion cancelled.\n"
            return
        fi
    elif [[ $resultState1 -eq 1 ]]; then
        showErrorMessage "\nThere is no group by that name. Please try again.\n"
    else
        showErrorMessage "\nA problem occured. Please try again.\n"
        return
    fi
}

##################################################################################################################################################

# Delete the requested user after the name is validated and the user indeed exists. 
function deleteUser {
    local uname
    # https://www.linuxquestions.org/linux/answers/Networking/How_to_list_all_your_USERs
    # Showing all the users that were created without the extra users that the machine is showing. 
    # SHowing only those that have their home directories in /home share

    showNotificationMessage "\n Showing users made by the administrator: \n"
    cat /etc/passwd |grep "/home" |cut -d: -f1
    printf "\nPlease type in the name of the user to delete: \n"

    read uname

    #Searches if there is a user with that name.
    #If that command finds a user it returns 1
    #The output of stdout and stderr are redirected (both standard output and errors) to /dev/null 
    #https://askubuntu.com/questions/474556/hiding-output-of-a-command
    id $uname > /dev/null 2>&1
    local resultOfNameSearch=$?
    if [[ $resultOfNameSearch -eq 0 ]] 
        then
        #https://stackoverflow.com/questions/1885525/how-do-i-prompt-a-user-for-confirmation-in-bash-script    
        showNotificationMessage "A user was found by that name.\n"
        read -p "Are you sure you want to delete? [y/n]" -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]
            then
            userdel -r -f "$uname" > /dev/null 2>&1
            local result=$?
            if [[ result -eq 0 ]]; then
                showNotificationMessage "\nUser $uname is deleted!"
            elif [[ result -ne 0 ]]; then
                showErrorMessage "\nThere was a problem with the deletion of that user. Please try again."
                return
            fi
        else
            showNotificationMessage "\nUser deletion canceled.\n"
        fi
    else
        showErrorMessage "\nNo user was found by that name.\n"
    fi 
    
}



##################################################################################################################################################


# Rename a user
function changeUserName {

    local userName
    local newName
    showNotificationMessage "\n Showing users made by the administrator: \n"
    # LIst all user names EXCEPT system-made users to help the user of the script have a visual on who exists
    cat /etc/passwd |grep "/home" |cut -d: -f1
    printf "\nPlease type in the name of the user to edit: \n"

    read userName
    #Searches if there is a user with that name.
    #If that command finds a user it returns 0
    id $userName > /dev/null 2>&1
    local resultOfNameSearch=$?
    if [[ $resultOfNameSearch -eq 0 ]] 
        then
        local newNameOK=false
        while [[ "$newNameOK" = false  ]]; do
            printf "\nPlease type in the new name for user $uname\n"
            read newName
            if [[ $newName =~ ^[a-z|A-Z|0-9]{1,32}$ ]]; then
                groupadd $newName
                usermod -d /home/$newName -m -g $newName -l $newName $userName
                newNameOK=true
                showNotificationMessage "\nUsername changed!\n"

            else
                showErrorMessage "\nYour input was invalid. Alphabetical and numerical characters allowed. Max length is 32 characters."
            fi
        done
        
    else
        showErrorMessage "\nNo user was found by that name.\n"
    fi
}



##################################################################################################################################################


function changeUserPassword {

    showNotificationMessage "\n Showing users made by the administrator: \n"
    # Searching in the etc/passwd for all the users that arein the /home group and prints them on the screen
    cat /etc/passwd |grep "/home" |cut -d: -f1
    printf "\nPlease type in the name of the user to edit: \n"
    local userName
    read userName
    #Searches if there is a user with that name.
    #If that command finds a user it returns 1
    id $userName > /dev/null 2>&1
    local resultOfNameSearch=$?
    if [[ $resultOfNameSearch -eq 0 ]] 
        then
        passwd $userName > /dev/null
        if [[ $? -eq 0 ]]; then
            showNotificationMessage "\nPassword changed!"
        else
            showErrorMessage "\nThere was a problem with password update. Please try again."
        fi
    else
        showErrorMessage "\nNo user was found by that name.\n"
    fi
}



##################################################################################################################################################


function changeGroupName {
    local exitApproved=false
    local groupToRename
    local newName

    while [[ "$exitApproved" = false ]]; do
        printf "\nPlease type in the name of the group you would like to rename: \n"

        read groupToRename
        # Searches in etc/group for the requested group name
        # The state of this command is kept in a variable
        egrep -w "^$groupToRename" /etc/group > /dev/null 2>&1
        local resultState1=$?
        if [[ $resultState1 -eq 0 ]]; then
            # if the state is 0 then it means that a group by that name is found
            printf "\nPlease type in the new name for the group: \n"
            # Asking for a new name for the requested group
            read newName
            # Renaming the group
            # Keep the result code of the groupmod command
            # Send all the output to dev/null to write custom output
            groupmod -n $newName $groupToRename > /dev/null 2>&1
            local result2=$?
            if [[ result2 -eq 0 ]]; then
                showNotificationMessage "\nGroup name changed!"
                exitApproved=true
            elif [[ result2 -eq 9 ]]; then
                showErrorMessage "\nThis name is already taken by another group.\n"
                exitApproved=false
            elif [[ result2 -ne 0 ]]; then
                showErrorMessage "\nThere was a problem with the rename. Please try again.\n"
                exitApproved=false
            fi
        elif [[ resultState1 -ne 0 ]]; then
            # If there is no group named after the requested name, ask the user if he would like to create a new one by that name.
            showNotificationMessage "\nThere is no group by that name.\n"
            read -p "Would you like to create a new one? [y/n]" -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                addNewGroup
		return
            elif [[ $REPLY =~ ^[Nn]$ ]]; then
                return
            fi
        fi    
    done

}

    ##################################################################################################################################################
    function insertUserToGRoup {
        local userToPut
        local groupToPut
        local exitApproved=false
        # Being in a loop until correct input is given
        while [[ "$exitApproved" = false ]]; do
            printf "\n Showing users made by the administrator: \n"
            # Searching in the etc/passwd for all the users that arein the /home group and prints them on the screen
            cat /etc/passwd |grep "/home" |cut -d: -f1
            printf "\nPlease type in the name of the user that is to be added to a group: \n"

            read userToPut
                #Searches if there is a user with that name.
                #If that command finds a user it returns 1
                id $userToPut > /dev/null 2>&1
                local resultOfNameSearch=$?
                # If the return value is 0, it means that a user is found
                if [[ $resultOfNameSearch -eq 0 ]]
                    then
                    printf "\nIn which group to add the user? \n"
                    read groupToPut
                            # Searches in etc/group for the requested group name
                            # The return value of this command is kept in a variable
                            # any output is redirected to dev/null
                    egrep -w "^$groupToPut" /etc/group > /dev/null 2>&1
                    local resultState1=$?
                    # If the return value is 0 it means that a group is found, hence the user will be added to the group
                    if [[ $resultState1 -eq 0 ]]; then
                        usermod -a -G $groupToPut $userToPut
                        exitApproved=true
                        showNotificationMessage "User added to the group!"
                        # If the return value is NOT 0 it means that a group is not found hence an errror meassage will be displayed.
                        # THe user is prompted to try again
                    elif [[ $resultState -ne 0 ]]; then

                        showErrorMessage "This group does not exist. Please try again."
                        exitApproved=false
                    fi
                    # If the return value is NOT 0, it means that the requested user is not found
                    # THe user is prompted to try again
                elif [[ $resultOfNameSearch -ne 0 ]]; then
                    showErrorMessage "This user does not exist. Please try again."
                    exitApproved=false

                fi
            done

        }

    ##################################################################################################################################################
    function removeUserFromGRoup {
        local userToRemove
        local groupRemovingFrom
        local exitApproved=false

        while [[ "$exitApproved" = false ]]; do
            printf "\nPlease insert name of the user: \n"

            read userToRemove
                #Searches if there is a user with that name.
                #If that command finds a user it returns 0
            id $userToRemove > /dev/null 2>&1
            local resultOfNameSearch=$?
            # If the return value of the search is 0, it means that the user with the requested name is found
            if [[ $resultOfNameSearch -eq 0 ]]
                then
                printf "The user $userToRemove is in the following groups:\n"
                # lists the group that the requested user is in
                lid -n $userToRemove
                printf "\nFrom which group to remove the user? \n"
                read groupRemovingFrom
                                            # Searches in etc/group for the requested group name
                            # The return value of this command is kept in a variable
                            # any output is redirected to dev/null
                egrep -w "^$groupRemovingFrom" /etc/group > /dev/null 2>&1
                local resultState1=$?
                # if the return value of the search is 0 it means that a group was found by that name
                if [[ $resultState1 -eq 0 ]]; then
                    # remove the requested user from the requested group
                    gpasswd -d $userToRemove $groupRemovingFrom
                    showNotificationMessage "User removed from the group!"
                    printf "\nGroup $groupRemovingFrom now contains the following members:\n"
                    # after the deletion, show the users remaining in that group
                    lid -g $groupRemovingFrom
                    exitApproved=true
                elif [[ $resultState -ne 0 ]]; then
                    showErrorMessage "This group does not exist. Please try again."
                    exitApproved=false
                fi
            elif [[ $resultOfNameSearch -ne 0 ]]; then
                showErrorMessage "This user does not exist. Please try again."
                exitApproved=false
                
            fi
        done
    }
    ##################################################################################################################################################


    function editGroup {
        exitApproved=false

    #This is the loop the program runs and according to the choice of the user, the corresponding function is called. 
    while [ "$exitApproved" = false ];
    do
        printf "\nSelect an option by typing the corresponding number and press enter. \n 
        1. Edit name
        2. Insert User to Group
        3. Remove User to Group
        4. Back
        0. Exit \n"
        read choice

        #If the user's input is 1 then invoke the function to display the existing records
        if [[ $choice =~ ^[1]{1}$ ]]
            then 
            changeGroupName
        #If the user's input is 2 then invoke the function to input a new record
    elif [[ $choice =~ ^[2]{1}$ ]]
        then
        insertUserToGRoup
    elif [[ $choice =~ ^[3]{1}$ ]]
        then
        removeUserFromGRoup        
    elif [[ $choice =~ ^[4]{1}$ ]]
        then
        return
        #If 0 then the program exits
    elif [[ $choice =~ ^[0]{1}$ ]]
        then
        exitApproved=true
    else
        showErrorMessage "Not a valid option selected. Please try again."
    fi
done
}



##################################################################################################################################################



function editUser {

    exitApproved=false

    #This is the loop the program runs and according to the choice of the user, the corresponding function is called. 
    while [ "$exitApproved" = false ];
    do
        printf "\nSelect an option by typing the corresponding number and press enter. \n 
        1. Edit name
        2. Edit password
        3. Back
        0. Exit \n"
        read choice

        #If the user's input is 1 then invoke the function to display the existing records
        if [[ $choice =~ ^[1]{1}$ ]]
            then 
            changeUserName
        #If the user's input is 2 then invoke the function to input a new record
    elif [[ $choice =~ ^[2]{1}$ ]]
        then
        changeUserPassword
    elif [[ $choice =~ ^[3]{1}$ ]]
        then
        return
        #If 0 then the program exits
    elif [[ $choice =~ ^[0]{1}$ ]]
        then
        exitApproved=true
    else
        showErrorMessage "Not a valid option selected. Please try again."
    fi
done
    #Searches if there is a user with that name.
    #If that command finds a user it returns 1
    #The output of stdout and stderr are redirected (both standard output and errors) to /dev/null 
    #https://askubuntu.com/questions/474556/hiding-output-of-a-command
}

#######################################################################################################################



function submenuUserManagement {

    exitApproved=false

    #This is the loop the program runs and according to the choice of the user, the corresponding function is called. 
    while [ "$exitApproved" = false ];
    do
        printf "\nSelect an option by typing the corresponding number and press enter. \n 
        1. Add new Group
        2. Add new User
        3. Delete Group
        4. Delete User
        5. Edit Group
        6. Edit User
        7. Back
        0. Exit \n"
        read choice

        #If the user's input is 1 then invoke the function to display the existing records
        if [[ $choice =~ ^[1]{1}$ ]]
            then 
            addNewGroup
        #If the user's input is 2 then invoke the function to input a new record
    elif [[ $choice =~ ^[2]{1}$ ]]
       then
       addNewUser
   elif [[ $choice =~ ^[3]{1}$ ]]
    then
    deleteGroup
elif [[ $choice =~ ^[4]{1}$ ]]
    then
    deleteUser
elif [[ $choice =~ ^[5]{1}$ ]]
    then
    editGroup
elif [[ $choice =~ ^[6]{1}$ ]]
    then
    editUser
elif [[ $choice =~ ^[7]{1}$ ]]
    then
    return
        #If 0 then the program exits
    elif [[ $choice =~ ^[0]{1}$ ]]
       then
       exitApproved=true
   else
       showErrorMessage "Not a valid option selected. Please try again."
   fi
done
}



function submenuFileArchiver {
    tput clear
    printf "Before the process can begin, please make sure that you have the following: \n
    --The path of the inventory that you would like to backup\n
    --The path of the destination directory to save the backup to.\n
    --Either the date that you want to backup the directory OR the frequency of the backup\n
    --Decide if you would like a new backup compressed file to be created each time or not.\n\n"
    read -p "Are you ready to proceed? [y/n]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
        then
        gatherCronInfo
    else
        return
    fi

}

##################################################################################################################################################
##########################################################################
##############FUNCTION DECLARATION END
##########################################################################


#Printf is used so that we can use the new line character \n
tput clear
tput setaf 3
printf "17419238 - CSY2002\n"
tput sgr0
tput setab 7
tput setaf 0
tput bold
printf "\nM A I N - M E N U\n" 
printf "\nWelcome to the User Manager and File archiver program \n\n"
tput sgr0
tput setaf 7

exitApproved=false

#This is the loop the program runs and according to the choice of the user, the corresponding function is called. 
while [ "$exitApproved" = false ];
do
    printf "\nSelect an option by typing the corresponding number and press enter. \n 
    1. Archive directory
    2. Manage Users / Groups
    0. Exit \n"

    read choice
    #If the user's input is 1 then invoke the function to display the archiver submenu
    if [[ $choice =~ ^[1]{1}$ ]]
       then 
       submenuFileArchiver
    #If the user's input is 2 then invoke the function to show the user management submenu
elif [[ $choice =~ ^[2]{1}$ ]]
    then
    submenuUserManagement
    #If 0 then the program exits
elif [[ $choice =~ ^[0]{1}$ ]]
    then
    exitApproved=true
else
    showErrorMessage "Not a valid option selected. Please try again."
fi
done

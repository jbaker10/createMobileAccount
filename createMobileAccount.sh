#!/bin/sh

#  createmobileaccount.sh
#  
#
#  Created by Jeremiah Baker on 3/7/14.
#

#########################################################
## This script requires an external application called Cocoa Dialog which can be download from https://mstratman.github.io/cocoadialog/
## This script must be run from an administrator account
##
#########################################################


## Changes the directory to the current directory holding the cocoaDialog app
CD=/Library/DIRECTORY/CocoaDialog.app/Contents/MacOS/CocoaDialog
echo $CD

## Sets the user to the login name as opposed to using whoami as this gets messed up when running a sudo command, it sees the user as root
#user=`logname`
getUser=`$CD standard-inputbox --title "Enter Username" --informative-text "Please enter your username below" --no-cancel --float`
user=`echo $getUser | awk '{print $NF}'`



i=0

## The checkPasswords functions is a while loop that will run a total of 3 times if necessary. Each time it will ask the user for their password twice, and then compare the strings to make sure they match. If they do not match, it will display an error and restart the loop until it has run 3 times at which point it will tell the user to contact their IT department

checkPasswords(){
    while [ $i -lt 3 ]; 
        do

            ## It was necessary to set the password variable twice for each password entered because the first one uses the built in cocoaDialog flags to take in the passwords, and the second one strips an unwanted space out that is added by default in the cocoaDialog variable

            getPwd1=`$CD secure-standard-inputbox --title "Enter Password" --informative-text "Please enter your password below to create the user: "$user" on this disk:" --no-cancel --float`
            pwd1=`echo $getPwd1 | awk '{print $NF}'`


            getPwd2=`$CD secure-standard-inputbox --title "Re-enter Password" --informative-text "Please enter your password again for verification:" --no-cancel --float`
            pwd2=`echo $getPwd2 | awk '{print $NF}'`


            ## This checks to see if the strings DO NOT match, if they don't, it adds 1 to the counter (i) and then displays an error and calls the function again to have the user re-enter their password again

            if [ $pwd2 != $pwd1 ];
                then
                    #echo "Passwords do not match";
                    #$CD ok-msgbox --title "" --text "Your passwords do not match" --informative-text "Please click OK and try again" --float
                    
                    let i=i+1;
                    echo $i
                    if [ $i == 1 ];
                    then
                        #echo "You have two more attempts"
                        $CD ok-msgbox --title "" --text "Your passwords do not match" --informative-text "You have two more attempts" --float --no-cancel
                    elif [ $i == 2 ];
                    then
                        #echo "You have one more attempt"
                        $CD ok-msgbox --title "" --text "Your passwords do not match" --informative-text "You have one more attempt" --float --no-cancel

                    elif [ $i == 3 ];
                    then
                        #echo "Please contact your IT department if you are having trouble with your password entry"
                        $CD ok-msgbox --title "" --text "Your passwords do not match" --informative-text "Please screenshot this error (Bad Password) and contact your IT department" --float --no-cancel
                    fi
                    checkPasswords;
            else
            	createMobileAccount;
            fi
        done
}


createMobileAccount(){
    sudo /System/Library/CoreServices/ManagedClient.app/Contents/Resources/createmobileaccount -n $user -p $pwd1
    exit 0
}

checkPasswords;



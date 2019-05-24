
# Shell Second Year Assignment
This repository contains three Shell scripts as part of the second year, second semester Operating Systems module assignment. 
The user guides of all three scripts are displayed below.

***

## Area.bash

***
A shell script to prompt the user for two numbers, representing width and height of a rectangle in cm, and display the area of the rectangle both in square centimetres and in square inches.
<br><br>
After the user starts the program, the program immediately welcomes the user and displays the options, these are, to calculate an area or exit. <br>
The first option prompts the user for input of width and height. 
Exit, terminates the script. <br>
The user must enter either a decimal number or an integer. (e.g. 34, or 34.5). Letters, symbols or pressing Enter without input, is not allowed. <br>
The program will not restrict the user on the length of the number.
After the width is correct, the program asks for height.
When the user inputs it, then the program displays the result in square inches and square meters. 
<br>

## Sales.bash

***
A Linux Bash shell script to compute the bonus for a salesperson by employing bubblesort. <br><br>

As a prerequisite, the file named “records.txt” must be in the same directory that the script is in, in order to retrieve existing records. If it’s not there, then when the user tries to save new records, a new file will be created.
The user can:<br>
<br>
* Add a record that is saved temporarily to the memory
* Add multiple records that are saved temporarily to memory
* Display and sort the records (by sales amount or by name) that are kept in the memory
* Save the records from memory to the file
* Display and sort the records (by sales amount or by name) from the file
* Count all records in the file.
<br>
There are numbered menus that the user can navigate by typing the corresponding number for the functionality he wants. 
The records inserted to the program, are saved only temporarily to the memory unless they are saved to the file (records.txt).
<br><br>
If the user selects to insert a new record, the system asks for a name, and requires it to be with its first letter capital. It also asks for the Quarterly Sales of the Salesman, and accepts floating and long integers. Once the user’s data is validated and inserted, a message is shown about the bonus of the newly inserted employee and the program still does not terminate. 
<br><br>
If the user requests to insert multiple records to the file, the program asks first for the number of records that the user wants to insert. Then the user can insert the users one by one as if he would do if he was inserting one. 
In case of Exit, the program terminates.
<br>

## Manage.bash

***
A shell script (using the tar command) which allows a Manager to add new users to a system and archives all the files in a chosen directory which have been modified recently. Crontab has been used to schedule the backup.<br><br>

<p>The user is prompted to select between the two main menus: the user management or the file archiver.&nbsp;</p>
<p>Selecting the user/group management, prompts the user to select which functionality he wants to initiate. The functionalities of this part of the program are described below.</p>
<p></p>
<ol>
<li style="text-indent: -.25in;">Add new Group &ndash; Asks for a group name and inserts the group if there is no other group with the same name, forbids the insertion and prompts the user again if there is.</li>
<li style="text-indent: -.25in;">Add new User &ndash; Adds a new user in the system if there is no user with the same name.</li>
<li style="text-indent: -.25in;">Delete Group &ndash; Deletes the specified group if it exists.</li>
<li style="text-indent: -.25in;">Delete User &ndash; Deletes the specified User if exists. Cannot delete the primary group.</li>
<li style="text-indent: -.25in;">Edit Group &ndash; Provides options for editing a group. They are displayed below.
<ol>
<li style="margin-left: 1.0in; text-indent: -.25in;">Edit group name &ndash; Edits a group&rsquo;s name</li>
<li style="margin-left: 1.0in; text-indent: -.25in;">Insert User to group &ndash; Inserts a user to the specified group</li>
<li style="margin-left: 1.0in; text-indent: -.25in;">Remove user from group</li>
<li style="margin-left: 1.0in; text-indent: -.25in;">Back</li>
<li style="margin-left: 1.0in; text-indent: -.25in;">Exit</li>
</ol>
</li>
<li style="text-indent: -.25in;">Edit User
<ol>
<li style="margin-left: 1.0in; text-indent: -.25in;">Edit name &ndash; Change the name of a user</li>
<li style="margin-left: 1.0in; text-indent: -.25in;">Edit password &ndash; Change the password of a user</li>
<li style="margin-left: 1.0in; text-indent: -.25in;">Back</li>
<li style="margin-left: 1.0in; text-indent: -.25in;">Exit</li>
</ol>
</li>
<li style="text-indent: -.25in;">Back</li>
<li style="text-indent: -.25in;">Exit</li>
</ol>
<p></p>
<p>Selecting the Archive Directory menu, prompts to a different menu. Instructions are given to the user as to what he must have prepared in order to proceed. The instructions are displayed below:</p>
<br>
![tut_image](https://github.com/antoniosTriant/Shell-Second-Year-Assignment/blob/master/explanatory.png)

<p>The user should have the path to the directory that he would like to back up in a text file ready to be copied into the prompt.</p>
<p>Also, he should have the path of the directory he would like the backed up files to be placed.</p>
<p>The user can navigate to the directory he would like to get the path for and press &ldquo;pwd&rdquo; through the terminal. This will print the path to the screen which he can later when requested, copy and paste into the terminal.</p>
<p><em>None of the paths should have slashes in the end.</em></p>
<p>The user must also know the format of the date that he would like to initiate a backup scheduled job. More specifically, the user has two choices as in saving their directory:</p>
<ol>
<li style="text-indent: -.25in;">Set in date/time</li>
<li style="text-indent: -.25in;">Set a time interval</li>
</ol>
<p>The first option will prompt the user to input a date that he would like the backup to happen. This option is used to initiate less frequent jobs. The structure of this options is displayed below:</p>
<p>&nbsp;</p>
<p><em>Insert the month from 1 to 12</em></p>
<p><em>Insert the day of the month from 1 to 31</em></p>
<p><em>Insert the hour from 0 to 23</em></p>
<p><em>Insert the minute from 0 to 59</em></p>
<p><em>&nbsp;</em></p>
<p>It is closer to the human representation of time as if someone would say &ldquo;I will do that task in September the 4<sup>th</sup> at 10:30 in the morning!&rdquo;</p>
<p>The second option is for more frequent jobs, as it prompts the user for a time interval an not a date. For example, if a user would like a backup to happen every 5 minutes or every 2 days.</p>
<p>&nbsp;</p>
<p><em>Minutes &ndash; Can convert minutes up to 24 hours</em></p>
<p><em>Hours &ndash; Can convert hours up to 30 days</em></p>
<p><em>Days &ndash; Can convert days up to 12 months</em></p>
<p><em>&nbsp;</em></p>
<p>Every option can convert what amount of time is inserted to it to the total time. For example, if the user selects to insert 560 minutes, the program will calculate that in 9 hours and 33 minutes, or if the user inserts 76 days, the program will convert that to 2 months and 6 days.</p>
<p>After this part is concluded, the script asks the user if he would like the directory to be replaced or if a new one should be created every time the backup happens.</p>
<p>Finally, a message notifies the user about the state of the process, if it was completed successfully or not.</p>
<p><span style="font-size: 11.0pt; line-height: 107%; font-family: 'Calibri',sans-serif;">The user <strong><em>must </em></strong>press OK to this message in order for the cron job to be added. </span></p>

Web List
========
This document covers the building of a list of websites, one for each university in the uk.

Source
------
The source shall be: http://www.ucas.com/students/choosingcourses/choosinguni/instguide/a/

Method
------

 1. wget a,b,c,d,... to acquire a set of pages
 2. regexp /w: &lt;a href="url" target="_blank">/
 3. export to CSV

Result
------
A CSV file, with university names and URLs.  Length: 351 records.

Stored in data/WebList
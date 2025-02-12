# Fetch-Assignment

For the closed-ended questions, I removed `nan` barcodes and took the first occurrences of duplicate barcodes from the products table. I also filtered the **transactions** table for users present in the **users** table before proceeding with the analyses. I noted that the overlap of users between **transactions** and **users** is pretty low, and thus it poses a limitation to conclusions we can draw. At best, we use the following analysis as a directional tool to get more data for future analyses.

#### Closed-ended questions:

##### What are the top 5 brands by receipts scanned among users 21 and over?

* DOVE
* NERDS CANDY
* COCA-COLA
* HERSHEY'S
* GREAT VALUE

##### What are the top 5 brands by sales among users that have had their account for at least six months?

* CVS
* TRIDENT
* DOVE
* COORS LIGHT
* AXE

#### Open-ended questions:

##### Who are Fetch’s power users?

Approached this by using a combination of sales amount, distinct count of receipts scanned and distinct count of scanned days (a proxy for app usage). Discovered most of our power users are a combination of Millenial and Gen-X women.

___

I have added a Jupyter notebook that contains a preliminary investigation of the datasets
as well as a Pandasql implementation of 2 closed and 1 open-ended questions.

One of the reasons I used Pandasql was to utilize the ease of working with datetimes in
Python and combining that with the ease of manipulating tabular data in SQL.

As I wasn't entirely sure what Fetch is looking for, I included the SQL codes for the three
questions as well - for this I uploaded files on to S3 in my personal AWS account and queried
them using Athena (which is quite different from the SQLite supported by Pandas) to verify
my query results

As for my thought process, I've included comments in all my codes and included markdown
portions in the Jupyter notebook where I walk through my thought process. 

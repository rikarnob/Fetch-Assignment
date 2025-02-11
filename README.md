# Fetch-Assignment

Questions answered - 

#### Closed-ended questions:

##### What are the top 5 brands by receipts scanned among users 21 and over?

* DOVE
* NERDS CANDY
* COCA-COLA
* HERSHEY'S
* SOUR PATCH KIDS

##### What are the top 5 brands by sales among users that have had their account for at least six months?

* COCA-COLA
* ANNIE'S HOMEGROWN GROCERY
* DOVE
* BAREFOOT
* ORIBE

#### Open-ended questions:

##### Who are Fetch’s power users?

Approached this by using a combination of sales amount, distinct count of receipts scanned
and distinct count of scanned days (a proxy for app usage)


I have added a Jupyter notebook that contains a preliminary investigation of the datasets
as well as a Pandasql implementation of 2 closed and 1 open-ended questions.

One of the reason I used Pandasql was to utilize the ease of working with datetimes in
Python and combining that with the ease of manipulating tabular data in SQL.

As I wasn't entirely sure what Fetch is looking for, I included the SQL codes for the three
questions as well - for this I uploaded files on to S3 in my personal AWS account and queried
them using Athena (which is quite different from the SQLite supported by Pandas) to verify
my query results

As for my thought process, I've included comments in all my codes and included markdown
portions in the Jupyter notebook where I walk through my thought process. 

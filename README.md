# Fetch-Assignment
Codes for close and open-ended questions for Fetch's take home assignment

Questions answered - 

## Closed-ended questions:

### What are the top 5 brands by receipts scanned among users 21 and over?
### What are the top 5 brands by sales among users that have had their account for at least six months?

## Open-ended questions:

### Who are Fetch’s power users?


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
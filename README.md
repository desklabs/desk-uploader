This is a rails app that takes an uploaded CSV file and upload the data into a
Desk.com account.  It uses MongoDB for temporary storage and Sidekiq for
background processing.

 

The basic process is:

1.  User uploads a CSV

2.  The CSV is stored into MongoDB’s GridFS

3.  A background job parses the CSV and creates a new background job for each
    row

4.  The workers then process the jobs.

5.  For faster processing you can spin up more dynos on Heroku

 

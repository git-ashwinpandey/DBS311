/* ***********************
-- Name: Ashwin Pandey
-- ID: 156027211
-- Date: 19th November, 2023
-- Purpose: Lab 7 DBS301
 ***********************
*/
//show dbs;


//Question 1
db.Student.insertOne({
    "first_name": "Sarah",
    "last_name": "Stone",
    "email": "s_stone@email.com",
    "city": "Markham",
    "status": "full-time",
    "gpa": 3.2,
    "program": "CPA"
});

db.Student.insertOne({
    "first_name": "Ashwin",
    "last_name": "Pandey",
    "email": "apandey21@myseneca.ca",
    "city": "Toronto",
    "status": "full-time",
    "gpa": 3.9,
    "program": "CPP"
});


//Question 2
db.Student.find({"first_name": "Ashwin"});

db.Student.find().forEach(printjson);

/*
How many fields are in your document? 8
Is there any new field added to your document? Yes
If yes, what is the name of the field? _id
*/

//Question 3
db.Student.find({"first_name": "Sarah", "last_name": "Stone"});

db.Student.remove({"first_name": "Sarah", "last_name": "Stone"});

/* Output
{
  "acknowledged": true,
  "deletedCount": 1
}
*/

//Question 4
db.Student.find({"first_name": "Sarah", "last_name": "Stone"});

/* Output
[]
*/

//Question 5
var studentArray = [
    {
      "_id": 1001,
      "first_name": "Sarah",
      "last_name": "Stone",
      "email": "s_stone@email.com",
      "city": "Toronto",
      "status": "full-time",
      "gpa": 3.4,
      "program": "CPA"
    },
    {
      "_id": 1002,
      "first_name": "Jack",
      "last_name": "Adam",
      "email": "j_adam@email.com",
      "city": "North York",
      "status": "part-time",
      "gpa": 3.6,
      "program": "CPA"
    }
];

db.Student.insertMany(studentArray);

/* Output
{
  "acknowledged": true,
  "insertedIds": {
    "0": 1001,
    "1": 1002
  }
}
*/

//Question 6
db.Student.find().forEach(printjson);

/* Output
{
  _id: {},
  first_name: 'Ashwin',
  last_name: 'Pandey',
  email: 'apandey21@myseneca.ca',
  city: 'Toronto',
  status: 'full-time',
  gpa: 3.9,
  program: 'CPP'
}
{
  _id: 1001,
  first_name: 'Sarah',
  last_name: 'Stone',
  email: 's_stone@email.com',
  city: 'Toronto',
  status: 'full-time',
  gpa: 3.4,
  program: 'CPA'
}
{
  _id: 1002,
  first_name: 'Jack',
  last_name: 'Adam',
  email: 'j_adam@email.com',
  city: 'North York',
  status: 'part-time',
  gpa: 3.6,
  program: 'CPA'
}
*/

//Question 7
db.Student.deleteMany({});

/*Output
{
  "acknowledged": true,
  "deletedCount": 3
}
*/

//Question 8
db.getName();
db.dropDatabase();

/*
{
  "ok": 1,
  "dropped": "senecaLab07"
}
*/


/* steps to drop database
1. Make sure the user has the permission (Server Administration > drop Database)
    or Atlas Admin for all permission.
2. make sure you are connected to the correct database.
3. db.dropDatabase();

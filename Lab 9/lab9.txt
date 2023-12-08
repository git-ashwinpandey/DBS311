/* ***********************
-- Name: Ashwin Pandey
-- ID: 156027211
-- Date: 4th December, 2023
-- Purpose: Lab 9 DBS301
 ***********************
*/


db.students.find().forEach(printjson);


//1
db.students.updateMany(
    {},
    {
      $set: {
        program: "CPA",
        term: 1
      }
    }
  );

  
//2
db.students.updateMany(
    {},
    {
      $set: {
        program: "BTTM"
      }
    }
  );


//3
db.students.find({ "name": "Jonie Raby" });

db.students.updateOne(
    { "name": "Jonie Raby" },
    {
      $set: {
        program: "CPA"
      }
    }
  );

//How many documents are there with the value Jonie Raby for the namefield? 
//  1
// How many documents were updated? 1


// 4
db.students.find(
    { "name": "Jonie Raby" },
    { "_id": 0,"program": 1 }
  );
  

//5
db.students.updateMany(
    { "_id": { $in: [20, 22, 24] } },
    {
      $inc: {
        term: 2
      }
    }
  );


//6
db.students.updateMany(
    { "term": 3 },
    {
      $unset: {
        term: 1
      }
    }
  );
  
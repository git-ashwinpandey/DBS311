// DBS311 - Lab 09
// Clint's Solutions
// Fall 2023
// -----------------------------

// DO NOT POST this file or any part of it in any location or online media.  
// This is copyright material by the author.

use("college");

// *******************
// Q1
db.students.updateMany(
    {},
    {"$set": {
        program: "CPA", 
        term: 1 }
    }
);

/*
{ "acknowledged" : true, "matchedCount" : 27, "modifiedCount" : 27 }
*/

// *******************
// Q2 
db.students.updateMany(
    {},
    {"$set": { program: "SDDS" }} // note used to be BTTM
);
/*
{ "acknowledged" : true, "matchedCount" : 27, "modifiedCount" : 27 }
*/

// *******************
// Q3
db.students.find({ name:"Jonie Raby" });

/*
{ "_id" : 26, "name" : "Jonie Raby", "scores" : [ { "score" : 19.17861192576963, "type" : "exam" }, { "score" : 76.3890359749654, "type" : "quiz" }, { "score" : 44.39605672647002, "type" : "homework" } ], "program" : "BTTM", "term" : 1 }
*/
db.students.updateOne(
    {_id : 26},
    {"$set": { program:"CPA" }}
);

/*
{ "acknowledged" : true, "matchedCount" : 1, "modifiedCount" : 1 }

-- There is only one
-- one document was updated
*/

// *******************
// Q4
db.students.find(
    {name: "Jonie Raby"},
    {_id:0,program:1}
);
/*
{ "program" : "CPA" }
*/


// *******************
// Q5 
db.students.updateMany(
    {_id: {$in: [20, 22, 24]}}, 
    {$inc: {term: 2}}
);

/*
{ "acknowledged" : true, "matchedCount" : 3, "modifiedCount" : 3 }
*/

// *******************
// Q6 
db.students.updateMany(
    { term: 3 },
    { $unset: { term: 1 } }
);


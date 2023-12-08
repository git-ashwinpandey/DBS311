// *******************************
// DBS311 NEE - Week 11a
// Clint MacDonald
// Nov. 21, 2023
// MongoDB Searching, $ Operators
// *******************************

// Searching 
// finding all documents
db.Student.find();

// find ONE record based on a criteria
db.Student.findOne({_id: 1});
// using the unique identifier works well

db.Student.findOne({eyeColour: "Brown"});
// but there are mutliple people with Brown Eyes
db.Student.find({eyeColour: "Brown"});


// Showing specific KVPs
db.Student.find({eyeColour: "Brown"}, {fName: 1, lName: 1});
db.Student.find({eyeColour: "Brown"}, {_id: 0, fName: 1, lName: 1});

// ----------------------------
// OPERATORS
// ----------------------------
/*
key: value  - equivalency (=), assignment
$gt     >
$gte    >=
$lt     <
$lte    <=
$ne     !=
$in     in
$nin    not in
$all    all
$exists if key exists 
$size   the length of an array
$set    an atomic operator for updating data
$or     OR - must be a prefix
$and    AND - must be a prefix
$unset  removing keys (atomic)

,       AND (most of the time)
*/

// show students with a favorite number of 7
db.Student.find({favNum: 7} , {fName: 1, lName: 1, favNum: 1});

// students with favnum >7
db.Student.find({favNum: {$gt: 7}} , {fName: 1, lName: 1, favNum: 1});
db.Student.find({favNum: {$gte: 7}} , {fName: 1, lName: 1, favNum: 1});

// between
// students favnum between 10 and 50  (inclusive assertion because SQL between is inclusive)
db.Student.find(
    {
        favNum: {$gte: 10},
        favNum: {$lte: 50} // this DOES NOT WORK, the second one OVERRIDES the first one
    }, 
    {fName: 1, lName: 1, favNum: 1}
);
// the next one is how it is done
db.Student.find(
    {
        favNum: {$gte: 10, $lte: 50} 
    }, 
    {fName: 1, lName: 1, favNum: 1}
);
// in SQL 
// WHERE favNum >= 10 AND favNum <= 50
// WHERE favNum >=10 AND <= 50

// -----------
// $ne
db.Student.find(
    {favNum: {$ne: 42}},
    {fName: 1, lName: 1, favNum: 1}
);
// works, but also gives students who does not have a favNum
// need to combine this with the $exists operator
db.Student.find(
    {favNum: {$ne: 42, $exists: 1}},
    {fName: 1, lName: 1, favNum: 1}
);

// list all student whom do not have a favNum
db.Student.find(
    {favNum: {$exists: 0}},
    {fName: 1, lName: 1, favNum: 1}
);

// --------------------------
// AND and OR

// list all students whose favNum is 4 or 7
db.Student.find(
    {favNum: {$or: [4,7]}},
    {fName: 1, lName: 1, favNum: 1}
);
// DOES NOT WORK, $or must be the prefix

db.Student.find(
    {$or: [
        {favNum: 4},
        {favNum: 7},
        {favNum: 9}
    ]},
    {fName: 1, lName: 1, favNum: 1}
);

// mixing AND and OR together

// WHERE favNum is 4 or 7 and eyeColour: Brown
// sql - WHERE (favNum = 4 OR favNum = 7) AND eyeColour = 'Brown'
db.Student.find(
    {$or: [
        {favNum: 4},
        {favNum: 7},
        {favNum: 9}
    ],
    eyeColour: "Brown"
    },
    {fName: 1, lName: 1, favNum: 1, eyeColour: 1}
);

// $and  operator
db.Student.find(
    {favNum: 7, eyeColour: "Brown"}, // the "," acts as an AND
    {fName: 1, lName: 1, favNum: 1, eyeColour: 1}
);

// another way
db.Student.find(
    {$and: [
        {favNum: 7},
        {eyeColour: "Brown"}
        ]
    }, 
    {fName: 1, lName: 1, favNum: 1, eyeColour: 1}
);

// another way
var myArray = [{favNum: 7},{eyeColour: "Brown"}];
db.Student.find(
    {$and: myArray},
    {fName: 1, lName: 1, favNum: 1, eyeColour: 1}
);
// this method can interchange with OR
var myArray = [{favNum: 7},{eyeColour: "Brown"}];
db.Student.find(
    {$or: myArray},
    {fName: 1, lName: 1, favNum: 1, eyeColour: 1}
);

// ---------------------
// $in

db.Student.find(
    {favNum: {$in: [4,7,66]}},
    {fName: 1, lName: 1, favNum: 1, eyeColour: 1}
);
// $nin
db.Student.find(
    {favNum: {$nin: [4,7,66], $exists: 1}},
    {fName: 1, lName: 1, favNum: 1, eyeColour: 1}
);

// --------------------
// $all

db.Student.find(
    {favNum: {$all: [4,7]}},  // Works, but does not make any sense
    {fName: 1, lName: 1, favNum: 1, eyeColour: 1}
);


// -----------------------------
// more on $exists

// show all student who have a favorite number
db.Student.find(
    {favNum: {$exists: 1}},
    {fName: 1, lName: 1, favNum: 1, eyeColour: 1}
);
// does not have a favNum
db.Student.find(
    {favNum: {$exists: 0}},
    {fName: 1, lName: 1, favNum: 1, eyeColour: 1}
);

// extend this to arrays
db.Student.find({courses: {$exists: 1}});
db.Student.find({marks: {$exists: 1}});

// who is taking web322?
db.Student.find({courses: "web322"});  

// same for wtp100
db.Student.find({courses: "wtp100"});

// BOTH web322 and dbs311
db.Student.find({courses: {$all: ["web322", "dbs311"]}});  

db.Student.find({courses: {$all: ["web322", "wtp100"]}});  
db.Student.find({$and: [{courses: "web322"}, {courses: "wtp100"}]});  

// let us do this with an array of objects
db.Student.find( { "marks.course" : "dbs311"} );
// note: when using dot "." notation, the key has to be inside quotes

db.Student.find({"marks.course": {$all: ["dbs311", "oop345"]}});

// Who has failed a course?
db.Student.find( { "marks.grade" : {$lt: 50} } );


// ----------------------
// sizes of arrays

// show all students taking 5 courses
db.Student.find( { courses: {$size: 5} } );

// the following DOES NOT WORK
db.Student.find( { courses: {$size: {$lt: 5}} } );
// hopefully they fix this in the future 


// --------------------------------
// UPDATING DATA

db.Student.find({_id: 1});

// add an eyeColour!

// we can use updateOne or updateMany
db.Student.updateOne(
    {_id: 1},
    {eyeColour: "Brown"}
);
// in command prompt this REPLACES the document

// use the $set operator
db.Student.updateOne(
    {_id: 1},
    { $set: {eyeColour: "Brown"}}
);

// add favNum
db.Student.updateOne(
    {_id: 1},
    { $set: {favNum: 16}}
);

// another way using javascript
var myStudent = db.Student.findOne({_id: 1});
myStudent.favNum = 16;
db.Student.replaceOne({_id: 1}, myStudent);



var myStudent = db.Student.findOne({_id: 1});
myStudent.first_name = myStudent.fName;
db.Student.replaceOne({_id: 1}, myStudent);

// ----------------------------
// removing keys
// $unset operator
db.Student.updateOne({_id: 1}, {$unset: {first_name: 1}});

// ------
// $increment
db.Student.updateOne(
    {_id: 1},
    {$inc: {favNum: 4}}
    );
db.Student.find({_id: 1});


db.Student.updateOne(
    {_id: 1},
    {$inc: {favNum: -4}}
);



// -----------------------
// --- Insert an array ---
// -----------------------

var myStudent = db.Student.findOne({_id: 1});
myStudent.courses = [ "dbs311", "syd422", "web322"];
db.Student.replaceOne({_id: 1}, myStudent);


db.Student.find({_id: 1});
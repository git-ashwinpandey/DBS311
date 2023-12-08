// ----------------------------------
// DBS311-NEE Week 10
// Clint MacDonald
// Nov. 14, 2023
// Introduction to MongoDB
// ----------------------------------

/*
MongoDB is a document storage based database
Documents are stored in Collections
A database is made up of collections

Each document contains a JSON object made up of Key-Value-Pairs (KVPs)

KVPs are JSON objects (similar to JavaScript Objects)
    example:  { key1: value1, key2: value2, key3: value3 }

Arrays can be stored in JSON
    example:  { key: [ value1, value2, value3 ] }
*/

// list all databases in the current cluster!
// show dbs;  // important for SHELL

// switch the current database...
// use DBS311_NDD_F23;

// the term "db" refers to the current database...
// in VSCode this will always be the database in the connectionstring!

// COLLECTION - similar to a table in relational database!!
            // the first collection is created when you insert the first document

// DOCUMENTS - similar to rows in a table
            // - stored as JSON files, and  are JAGGED!

// let us insert our first document
// although both the collection and database do not exist

// INSERT
// syntax:   db.collectionname.insertOne( {} );

db.Student.insertOne({
    _id: 1,            // _id is the unique identifier
    fName: "Clint",
    lName: "MacDonald"
});

// NOTE: _id is by default the unique identifier for ALL collections
// _id can be manually assigned or automatically generated as a GUID object

db.Student.insertOne({
    fName: "Bob",
    lName: "MacKenzie",
    email: "bob.mackenzie@thegreatwhitenorth.com"
});

// SHOWING DOCUMENTS
// find() method

// equiv of SELECT * FROM Student;
db.Student.find();

// INSERT many documents
// syntax:  db.collectionname.insertMany( [ {},{},{} ] ); // array of documents
db.Student.insertMany([
    {_id: 2, fName: "Jim", mName:"Frank", lName:"Jones"},
    {_id: 3, fName: "Sally", lName:"Smothers", favNum: 4},
    {_id: 4, fName: "Jennifer", lName:"Smith", favNum: 7, eyeColour:"Brown"}
]);
db.Student.find();

db.Student.insertMany([
    {_id: "JJ", fName: "Jim", mName:"Frank", lName:"Jones"},
    {_id: "SS", fName: "Sally", lName:"Smothers", favNum: 4},
    {_id: "JS", fName: "Jennifer", lName:"Smith", favNum: 7, eyeColour:"Brown"}
]);

db.Student.insertMany([
    {_id: 8, fName: "Jim", mName:"Frank", lName:"Jones"},
    {_id: 7, fName: "Sally", lName:"Smothers", favNum: 4},
    {_id: 6, fName: "Jennifer", lName:"Smith", favNum: 7, eyeColour:"Brown"}
]);

// WARNING
// when inserting many, it will run successfully until it's first error and then 
// terminate, but the inserts that worked, stay, but inserts after the error are 
// not attempted...


// -- DELETE
db.Student.deleteOne({ _id: "JJ" });
db.Student.find();

db.Student.deleteOne({ fName: "Sally" });

db.Student.deleteMany({ fName: "Sally" });


// delete ALL documents
// same as DELETE FROM <table>

db.Student.deleteMany({});
db.Student.find();

// ---------------------------
// Arrays

// store multiple data for an individual key within one document
// this is accomplished by using javaScript/JSON arrays

db.Student.insertOne({
    _id: 5,
    fName: "Raj",
    lName: "Patel",
    courses: ["dbs311", "web322", "oop345", "syd366", "wtp100"],
    eyeColour: "Brown",
    favNum: 74
});
db.Student.find();

db.Student.insertOne({
    _id: 6,
    fName: "Sarah",
    mName: "Jessica",
    lName: "Bassett",
    courses: ["dbs311", "web322", "oop345", "syd366"],
    eyeColour: "Blue",
    favNum: 42,
    hairColour: "Blond"
});


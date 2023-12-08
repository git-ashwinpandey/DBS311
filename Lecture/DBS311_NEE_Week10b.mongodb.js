// ******************************
// DBS311-NDD Week 10b
// Nov 17, 2023
// MongoDB Week 10 continued
// ******************************

db.Student.find();

// adding an array of objects

db.Student.insertOne({
    _id: 7,
    fName: "Mark",
    lName: "Covert",
    marks: [
        {course: "dbs311", grade: 67, pf: "pass"},
        {course: "web322", grade: 76},
        {course: "oop345", grade: 63, comment: "Needs Improvement!"},
        {course: "wtp100", grade: 82},
        {course: "syd366", grade: 72}
    ],
    eyeColour: "Hazzle"
});

// another student
db.Student.insertOne({
    _id: 8,
    fName: "George",
    lName: "Duffer",
    marks: [
        {course: "dbs311", grade: 76, pf: "pass"},
        {course: "oop345", grade: 95, comment: "Excellent!!!"},
        {course: "syd366", grade: 63, comment: "Academic Alert!"}
    ],
    eyeColour: "Green",
    favNum: 66
});


db.Student.insertOne({
    _id: 9,
    fName: "Mr.",
    lName: "BrownEyes",
    eyeColour: "Brown"
});

db.Student.find();


// ----------------
// SEARCHING
// ----------------
// similar to SELECT statement

// get everything
db.collectionname.find();

// example of WHERE
db.Student.find({_id: 1});

db.Student.find({eyeColour: "Blue"});

db.Student.find({eyeColour: "Brown"});

db.Student.find({fName: "Jennifer", eyeColour: "Brown"});

// all searches are done through KVPs

// limits which keys are displayed in the output....
// syntax db.collectionname.find({filter criteria},{key list});

db.Student.find({eyeColour: "Brown"}, {fName: 1, lName: 1});

db.Student.find({eyeColour: "Brown"}, {_id: 0, fName: 1, lName: 1, favNum: 0});
// error, you cannot specify the default behaviour specifically...

db.Dummy.insertOne({
    fName: "Dummy",
    lName: "ForTesting"
});

db.Dummy.find();
db.Dummy.remove({});
db.Dummy.drop();



// ----------------
// JavaScript IN Mongosh
function factorial(n) {
    if (n <= 1) return 1;
    return n*factorial(n-1);
}

factorial(6);

strArray = [
    {   "fName": "Dudley",
       "lName": "Dursley"
    },
    {   "fName": "Henry",
        "lName": "Winkler"
    },
    {   "fName": "Alex",
        "lName": "Chu"
    }
];

db.Student.insertMany(strArray);
db.Student.find();

stud1 = db.Student.find({_id: 1});
stud1.favNum = 16;

db.Student.UpdateOne({_id: 1}, stud1);









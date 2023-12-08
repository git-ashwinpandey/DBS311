// *************************
// DBS311-NEE Week 12
// Clint MacDonald
// Nov. 28, 2023
// Final Week of MongoDB
// *************************

db.Student.find();

// more with arrays

// remove (delete) statements to remove data 
db.Student.remove({_id: 2});
db.Student.deleteOne({_id: 3});
db.Student.deleteOne( {_id: ObjectId('6553b7e62d3078cdae7c7197') } );
db.Student.deleteOne({_id: 4});
db.Student.deleteOne({_id: 7});
db.Student.deleteOne({_id: 8});
db.Student.deleteOne({_id: 9});
db.Student.deleteOne( {_id: ObjectId('6557f0d5a48d658eda13e9a9') } );
db.Student.deleteOne( {_id: ObjectId('6557f0d5a48d658eda13e9a8') } );
db.Student.deleteOne( {_id: ObjectId('6557f0d5a48d658eda13e9aa') } );

// use $exists filter 
db.Student.find({courses: {$exists: 1}});
db.Student.deleteMany( {courses: {$exists: 0}});

// ------------------
// Array Modifiers
// ------------------

/*
-- $push 
-- $slice
-- $each
-- $sort
*/

// add dbs501 to _id 1
db.Student.updateOne(
    {_id: 1},
    { $push: { courses: "dbs501"} }  // adds to the array - at the end
);
db.Student.find({_id: 1});

// push multiple items simultaneously.
db.Student.updateOne(
    {_id: 1},
    { $push: { courses: [ "ipc144", "web222", "web422"] } }  
);
db.Student.find({_id: 1});
// OOPS, this added a sub-array, rather than adding items

// we need to add an array to an array ONE AT A TIME!
db.Student.updateOne(
    {_id: 1},
    { $push: { courses: { $each: [ "ipc144", "web222", "web422"]} } }  
);
db.Student.find({_id: 1});

// setting the size of the array!
db.Student.updateOne(
    {_id: 1},
    { $push: { 
        courses: { 
            $each: [ "ipc144", "web222", "web422"],
            $slice: 3
            } 
        } 
    }  
);
db.Student.find({_id: 1});
// Slice truncates the array keeping the elements from the beginning

// if you want to keep the end, use a - number (negative)
db.Student.updateOne(
    {_id: 1},
    { $push: { 
        courses: { 
            $each: [ "ipc144", "web222", "web422"],
            $slice: -4
            } 
        } 
    }  
);
db.Student.find({_id: 1});

// limiting an array size without adding new records

// FAIL the following fail...
db.Student.updateOne(
    {_id: 1},
    {courses: {$slice: 3}}  // fails as no $set
);
// let us try $set

db.Student.updateOne(
    {_id: 1},
    {$set: {courses: {$slice: 3}}}  
);
db.Student.find({_id: 1});
// $slice is not recognized as a modifier...  it treats it like a key

/*
in SQL
'%'  = '%', need to use LIKE
*/
db.Student.updateOne(
    {_id: 1},
    { $push: { 
        courses: { 
            $each: [],
            $slice: -4
            } 
        } 
    }  
);

db.Student.find({_id: 1});

// ---------------------------
// Sorting
db.Student.updateOne(
    {_id: 1},
    {courses: {$sort: 1}}
); // DOES NOT WORK!  -- no $set

// This is how you're supposed to do it!
db.Student.updateOne(
    {_id: 1},
    {$push: {
        courses: {
            $each: ["web222", "dbs211"],
            $slice: -4,
            $sort: 1  // NOTE: regardless of order entered, sort goes before slice
        }
    }}
);
db.Student.find({_id: 1});

db.Student.updateOne(
    {_id: 1},
    {$push: {
        courses: {
            $each: ["web322", "dbs211", "web422", "dbs311", "syd466"]
        }
    }}
);

// sorting without adding new elements
db.Student.updateOne(
    {_id: 1},
    {$push: {
        courses: {
            $each: [],
            $sort: 1
        }
    }}
);
db.Student.find({_id: 1});


// ----------  THIS IS WHERE THE FINAL TEST ENDS  ------------------

// Aggregate Functions
// powerpoint provided in blackboard for more details

// COUNT
db.Student.count({courses: "dbs311"});
db.Student.countDocuments({courses: "dbs311"});
db.Student.countDocuments({_id: 1});
db.Student.countDocuments({_id: {$gt: 1}});

db.Student.find();






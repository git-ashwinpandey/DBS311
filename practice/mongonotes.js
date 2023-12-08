db.profile.find({"address.city": {$in: ["New York", "Chicago"]}});

db.profile.find({"contacts.type": "email"});
db.profile.find({"projects.contributors": {$in: ["Henry", "Charlie"]}});

db.profile.findOne({"contacts.type": "email"})



//find
//findOne
//updateOne  -> use $set otherwise it replaces the whole thing
//updateMany
//replaceOne
//deleteOne
//deleteMany


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

// ------------------
// Array Modifiers // don't worry about $set
// ------------------

/*
-- $push 
-- $slice
-- $each
-- $sort
*/
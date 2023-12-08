db.profile.find({"address.city": {$in: ["New York", "Chicago"]}});

db.profile.find({"contacts.type": "email"});
db.profile.find({"projects.contributors": {$in: ["Henry, Charlie"]}});



db.profile.updateOne(
    {_id: 1}, 
    {$push: {contacts: {discord: "test", active: "Yes"}}}
);


let testObj = { discord: "test", active: "Yes" };
db.profile.updateOne(
    { "_id": 2 },
    {
        $push: { "contacts": testObj }
    }
);

db.profile.find({_id: 2});


db.profile.updateOne(
    {_id: 2},
    {$set: {contacts: []}}
);

let testObj = { discord: "test", active: "Yes" };
db.profile.updateOne(
    {_id: 2},
    {$push: {contacts: {$each: [testObj, testObj], $slice : 2}}}
);

db.profile.updateOne(
    {_id: 2},
    {$push: {contacts: {$each:[], $slice: 2}}}
);


db.profile.updateOne(
    {_id: 2},
    {$push: {"projects.contributors": {$each: [], $sort: 1}}}
);

db.profile.find(
    {contacts: {$exists: 1}},
    {projects: 1, contacts: 1, _id: 0}
);
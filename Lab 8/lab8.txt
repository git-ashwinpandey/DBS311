/* ***********************
-- Name: Ashwin Pandey
-- ID: 156027211
-- Date: 27th November, 2023
-- Purpose: Lab 8 DBS301
 ***********************
*/

// 1
db.products.find({}, { name: 1, price: 1 });

// 2
db.products.find({ type: "accessory" }, { name: 1, price: 1 });

// 3
db.products.find(
    { price: {$gte: 13, $lte: 19} }, 
    { name: 1, price: 1 }
);

// 4
db.products.find({ type: { $ne: "accessory" } }, { id: 1, name: 1, price: 1, type: 1 })

// 5
db.products.find({ type: {$in: ["accessory","service"]} }, { id: 1, name: 1, price: 1, type: 1 })

//6
db.products.find({ type: {$exists: 1} }, { id: 1, name: 1, price: 1, type: 1 })

//7
db.products.find({ type: {$all: ["accessory","case"]} }, { id: 1, name: 1, price: 1, type: 1 })

//8
/**
 * In mongoDB, we use collection and documents. A collection is like a table and document is like a row.
 * a document in a collection can have different structure compared to other documents in a same collection.
 * mongodb can have non atomic values for its values in a key.
 * 
 * In my opinion, json notation of mongodb is easier to write once you're familiar with the operators.
 */
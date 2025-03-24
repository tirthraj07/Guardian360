// lib/mongodb.ts
/* eslint-disable @typescript-eslint/no-explicit-any */
import { MongoClient } from "mongodb";
if (!process.env.MONGO_URL) {
  throw new Error("Please add your MongoDB URI to .env.local");
}

const uri: string = process.env.MONGO_URL||"";
const options = {};

let client: MongoClient;
let clientPromise: Promise<MongoClient>;

if (process.env.NODE_ENV === "development") {
  // In development, use a global variable so that the value
  // is preserved across module reloads caused by HMR (Hot Module Replacement)

    client = new MongoClient(uri, options);
    clientPromise = client.connect();
  

} else {
  // In production, it's best to not use a global variable.
  client = new MongoClient(uri, options);
  clientPromise = client.connect();
}

export default clientPromise;

import { client } from "./client";
import { env } from "../config/env";

let connected = false;

export async function getDb() {
  if (!connected) {
    await client.connect();
    connected = true;
    console.log("✅ Connected to MongoDB Atlas");
  }
  return client.db(env.MONGODB_DB);
}
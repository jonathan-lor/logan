import { Elysia } from "elysia";
import { getDb } from "../db";

export const debugRoutes = new Elysia()
  .post("/db/test", async () => {
    const db = await getDb();
    const col = db.collection("test");

    const write = await col.insertOne({
      message: "hello from elysia",
      createdAt: new Date(),
    });

    const read = await col.findOne({ _id: write.insertedId });

    return { ok: true, insertedId: write.insertedId, doc: read };
  });
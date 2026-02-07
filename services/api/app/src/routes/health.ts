import { Elysia } from "elysia";
import { getDb } from "../db";

export const healthRoutes = new Elysia()
  .get("/", () => "OK")
  .get("/db/ping", async () => {
    const db = await getDb();
    return { ok: true, result: await db.command({ ping: 1 }) };
  });
import { Elysia, t } from "elysia";
import { getDb } from "../db";

export const tagsRoutes = new Elysia().get(
  "/tags",
  async ({ query }) => {
    const db = await getDb();
    const col = db.collection("questions");

    const limit = Math.min(Math.max(Number(query.limit ?? 50), 1), 200);

    const tags = await col
      .aggregate([
        { $unwind: "$tags" },
        { $group: { _id: "$tags", count: { $sum: 1 } } },
        { $sort: { count: -1 } },
        { $limit: limit },
        { $project: { _id: 0, tag: "$_id", count: 1 } },
      ])
      .toArray();

    return { ok: true, tags };
  },
  {
    query: t.Object({
      limit: t.Optional(t.String()),
    }),
  }
);
import { Elysia, t } from "elysia";
import { ObjectId } from "mongodb";
import { getDb } from "../db";

export const questionsRoutes = new Elysia()

  // List questions (cursor pagination)
  .get(
    "/questions",
    async ({ query, set }) => {
      const db = await getDb();
      const col = db.collection("questions");

      // limit: default 20, max 100
      const limit = Math.min(Math.max(Number(query.limit ?? 20), 1), 100);

      const filter: any = {};
      if (query.tag) filter.tags = query.tag;
      if (query.type) filter.type = query.type;

      // Cursor: _id > cursor (ascending order)
      if (query.cursor) {
        try {
          filter._id = { $gt: new ObjectId(query.cursor) };
        } catch {
          set.status = 400;
          return { ok: false, error: "Invalid cursor" };
        }
      }

      const items = await col
        .find(filter)
        .sort({ _id: 1 })
        .limit(limit)
        .toArray();

      const nextCursor = items.length ? items[items.length - 1]._id.toString() : null;

      return { ok: true, items, nextCursor };
    },
    {
      query: t.Object({
        limit: t.Optional(t.String()),
        cursor: t.Optional(t.String()),
        tag: t.Optional(t.String()),
        type: t.Optional(t.String()),
      }),
    }
  )

  // Get one question by id
  .get("/questions/:id", async ({ params, set }) => {
    const db = await getDb();
    const col = db.collection("questions");

    let _id: ObjectId;
    try {
      _id = new ObjectId(params.id);
    } catch {
      set.status = 400;
      return { ok: false, error: "Invalid id" };
    }

    const item = await col.findOne({ _id });
    if (!item) {
      set.status = 404;
      return { ok: false, error: "Not found" };
    }

    return { ok: true, item };
  })

  // Random question (optionally filtered)
  .get(
    "/questions/random",
    async ({ query }) => {
      const db = await getDb();
      const col = db.collection("questions");

      const match: any = {};
      if (query.tag) match.tags = query.tag;
      if (query.type) match.type = query.type;

      const pipeline: any[] = [];
      if (Object.keys(match).length) pipeline.push({ $match: match });
      pipeline.push({ $sample: { size: 1 } });

      const [item] = await col.aggregate(pipeline).toArray();

      return { ok: true, item: item ?? null };
    },
    {
      query: t.Object({
        tag: t.Optional(t.String()),
        type: t.Optional(t.String()),
      }),
    }
  );
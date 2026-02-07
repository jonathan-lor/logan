import { Elysia } from "elysia";
import { healthRoutes } from "./routes/health";
import { questionsRoutes } from "./routes/questions";
import { tagsRoutes } from "./routes/tags";

export function createApp() {
  return new Elysia()
    .use(healthRoutes)
    .use(questionsRoutes)
    .use(tagsRoutes);
}
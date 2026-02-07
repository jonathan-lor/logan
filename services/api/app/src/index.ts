import { createApp } from "./app";

const app = createApp().listen(3000);
console.log(`🦊 API running at http://localhost:${app.server?.port}`);
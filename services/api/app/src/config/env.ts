function mustGet(name: string): string {
  const v = process.env[name];
  if (!v) throw new Error(`Missing ${name} in .env`);
  return v;
}

export const env = {
  MONGODB_URI: mustGet("MONGODB_URI"),
  MONGODB_DB: mustGet("MONGODB_DB"),
};
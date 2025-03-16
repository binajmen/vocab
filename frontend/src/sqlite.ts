import { type Promiser, sqlite3Worker1Promiser } from "@sqlite.org/sqlite-wasm";

const initializeSQLite = async () => {
  try {
    console.log("Loading and initializing SQLite3 module...");

    const promiser: Promiser = await new Promise((resolve) => {
      const _promiser = sqlite3Worker1Promiser({
        onready: () => {
          resolve(_promiser);
        },
      });
    });

    const config = await promiser("config-get", {});
    if (config.type === "error") {
      throw new Error("unable to retrieve config");
    }
    console.log("Running SQLite3 version", config.result.version.libVersion);

    const open = await promiser("open", {
      filename: "file:worker-promiser.sqlite3?vfs=opfs",
    });
    if (open.type === "error") {
      throw new Error("unable to open opfs");
    }
    const { dbId } = open;
    console.log(
      "OPFS is available, created persisted database at",
      open.result.filename.replace(/^file:(.*?)\?vfs=opfs$/, "$1"),
    );

    console.log("Creating tables...");

    await promiser("exec", {
      dbId,
      sql: `CREATE TABLE IF NOT EXISTS verbs(
        infinitive TEXT PRIMARY KEY,
        present_ich TEXT,
        present_du TEXT,
        present_er_sie_es TEXT,
        present_wir TEXT,
        present_ihr TEXT,
        present_sie TEXT,
        past_ich TEXT,
        past_du TEXT,
        past_er_sie_es TEXT,
        past_wir TEXT,
        past_ihr TEXT,
        past_sie TEXT,
        perfect_ich TEXT,
        perfect_du TEXT,
        perfect_er_sie_es TEXT,
        perfect_wir TEXT,
        perfect_ihr TEXT,
        perfect_sie TEXT
      )`,
    });

    console.log("Query data with exec()");
    await promiser("exec", {
      dbId,
      sql: "SELECT * FROM verbs LIMIT 1",
      callback: (result) => {
        if (!result.row) {
          return;
        }
        console.log(result.row);
      },
    });

    return { promiser, dbId };
    // await promiser("close", { dbId });
  } catch (err) {
    if (err instanceof Error) {
      console.error(err.name, err.message);
    }
    console.error("unknown error", err);
  }
};

export const db = await initializeSQLite();

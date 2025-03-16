import type { Conjugation } from "~/core/verb/verb.type";
import { db } from "~/sqlite";
import select_random_verb_query from "./select_random_verb.sql";

export async function select_random_verb(
  fn: (conjugation: Conjugation) => void,
) {
  console.log("select_random_verb");
  const res = await db?.promiser("exec", {
    dbId: db?.dbId,
    sql: select_random_verb_query,
    callback: (result) => {
      if (result.rowNumber !== 1 || !Array.isArray(result.row)) {
        console.error("select_random_verb did not return a single row");
        return;
      }
      const [
        infinitive,
        present_ich,
        present_du,
        present_er_sie_es,
        present_wir,
        present_ihr,
        present_sie,
        past_ich,
        past_du,
        past_er_sie_es,
        past_wir,
        past_ihr,
        past_sie,
        perfect_ich,
        perfect_du,
        perfect_er_sie_es,
        perfect_wir,
        perfect_ihr,
        perfect_sie,
      ] = result.row as Array<string>;

      console.log("result", { result });
      fn({
        infinitive,
        present: {
          ich: present_ich,
          du: present_du,
          er_sie_es: present_er_sie_es,
          wir: present_wir,
          ihr: present_ihr,
          sie: present_sie,
        },
        past: {
          ich: past_ich,
          du: past_du,
          er_sie_es: past_er_sie_es,
          wir: past_wir,
          ihr: past_ihr,
          sie: past_sie,
        },
        perfect: {
          ich: perfect_ich,
          du: perfect_du,
          er_sie_es: perfect_er_sie_es,
          wir: perfect_wir,
          ihr: perfect_ihr,
          sie: perfect_sie,
        },
      });
    },
  });
  if (res?.type === "error") {
    console.error("error", { res });
    return { error: true };
  }
}

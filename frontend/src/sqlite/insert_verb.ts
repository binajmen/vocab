import { db } from "~/sqlite";
import insert_verb_query from "./insert_verb.sql";
import type { Conjugation } from "~/core/verb/verb.type";

export async function insert_verb(conjugation: Conjugation) {
  await db?.promiser("exec", {
    dbId: db?.dbId,
    sql: insert_verb_query,
    bind: [
      conjugation.infinitive,
      conjugation.present.ich,
      conjugation.present.du,
      conjugation.present.er_sie_es,
      conjugation.present.wir,
      conjugation.present.ihr,
      conjugation.present.sie,
      conjugation.past.ich,
      conjugation.past.du,
      conjugation.past.er_sie_es,
      conjugation.past.wir,
      conjugation.past.ihr,
      conjugation.past.sie,
      conjugation.perfect.ich,
      conjugation.perfect.du,
      conjugation.perfect.er_sie_es,
      conjugation.perfect.wir,
      conjugation.perfect.ihr,
      conjugation.perfect.sie,
    ],
  });
}

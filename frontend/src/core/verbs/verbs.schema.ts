import { v } from "~/utils/valibot";

export const pronouns = [
  "ich",
  "du",
  "er_sie_es",
  "wir",
  "ihr",
  "sie",
] as const;

export type Pronoun = (typeof pronouns)[number];

export function isPronoun(str: string): str is Pronoun {
  return pronouns.includes(str as Pronoun);
}

export const Conjugation = v.object(
  v.entriesFromList(pronouns, v.pipe(v.string(), v.nonEmpty())),
);

export const CreateVerbSchema = v.object({
  infinitive: v.string(),
  present: Conjugation,
  simple_past: Conjugation,
  present_perfect: Conjugation,
});

export type CreateVerb = v.InferOutput<typeof CreateVerbSchema>;

export const VerbSchema = v.object({
  id: v.pipe(v.string(), v.uuid()),
  ...CreateVerbSchema.entries,
});

export type Verb = v.InferOutput<typeof VerbSchema>;

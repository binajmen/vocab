import { v } from "~/utils/valibot";

export const nouns = ["der", "die", "das"] as const;

export type Article = (typeof nouns)[number];

export const CreateNounSchema = v.object({
  article: v.string(),
  singular: v.pipe(v.string(), v.nonEmpty()),
  plural: v.pipe(v.string(), v.nonEmpty()),
});

export type CreateNoun = v.InferOutput<typeof CreateNounSchema>;

export const NounSchema = v.object({
  id: v.pipe(v.string(), v.uuid()),
  ...CreateNounSchema.entries,
});

export type Noun = v.InferOutput<typeof NounSchema>;

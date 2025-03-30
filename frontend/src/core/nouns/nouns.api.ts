import { type MutationOptions, queryOptions } from "@tanstack/solid-query";
import { get, post } from "~/api";
import { v } from "~/utils/valibot";
import { type Noun, NounSchema, type CreateNoun } from "./nouns.schema";

const list = queryOptions({
  queryKey: ["nouns"],
  queryFn: () => get("/nouns", v.array(NounSchema)),
});

const find = (id: string) =>
  queryOptions({
    queryKey: ["nouns", id],
    queryFn: () => get(`/nouns/${id}`, NounSchema),
  });

const create = {
  mutationFn: (values: CreateNoun) => post("/nouns", values, NounSchema),
} satisfies MutationOptions<Noun, Error, CreateNoun>;

const update = {
  mutationFn: (values: Noun) => post(`/nouns/${values.id}`, values, NounSchema),
} satisfies MutationOptions<Noun, Error, Noun>;

export const nouns = {
  list,
  find,
  create,
  update,
};

import { type MutationOptions, queryOptions } from "@tanstack/solid-query";
import { get, post } from "~/api";
import { v } from "~/utils/valibot";
import { type Verb, VerbSchema, type CreateVerb } from "./verbs.schema";

const list = queryOptions({
  queryKey: ["verbs"],
  queryFn: () => get("/verbs", v.array(VerbSchema)),
});

const find = (id: string) =>
  queryOptions({
    queryKey: ["verbs", id],
    queryFn: () => get(`/verbs/${id}`, VerbSchema),
  });

const create = {
  mutationFn: (values: CreateVerb) => post("/verbs", values, VerbSchema),
} satisfies MutationOptions<Verb, Error, CreateVerb>;

const update = {
  mutationFn: (values: Verb) => post(`/verbs/${values.id}`, values, VerbSchema),
} satisfies MutationOptions<Verb, Error, Verb>;

export const verbs = {
  list,
  find,
  create,
  update,
};

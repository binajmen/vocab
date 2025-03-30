import { type MutationOptions, queryOptions } from "@tanstack/solid-query";
import { get, post } from "~/api";
import { v } from "~/utils/valibot";
import { type User, UserSchema } from "./users.schema";

const list = queryOptions({
  queryKey: ["users"],
  queryFn: () => get("/users", v.array(UserSchema)),
});

const find = (id: string) =>
  queryOptions({
    queryKey: ["users", id],
    queryFn: () => get(`/users/${id}`, UserSchema),
  });

const create = {
  mutationFn: (values) => post("/users", values, UserSchema),
} satisfies MutationOptions<User, Error, { email: string }>;

export const users = {
  list,
  find,
  create,
};

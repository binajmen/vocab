import { users } from "~/core/users/users.api";
import { v } from "./utils/valibot";
import { verbs } from "./core/verbs/verbs.api";
import { nouns } from "./core/nouns/nouns.api";

export const API_URL = "http://localhost:8010";

// biome-ignore lint/suspicious/noExplicitAny: <explanation>
export async function get<Schema extends v.BaseSchema<any, any, any>>(
  path: string,
  schema: Schema,
): Promise<v.InferOutput<Schema>> {
  const headers: HeadersInit = {};

  return fetch(`${API_URL}${path}`, { headers })
    .then((res) => res.json())
    .then((json) => v.parse(schema, json));
}

// biome-ignore lint/suspicious/noExplicitAny: <explanation>
export async function post<Schema extends v.BaseSchema<any, any, any>>(
  path: string,
  values: unknown,
  schema: Schema,
): Promise<v.InferOutput<Schema>> {
  const headers: HeadersInit = { "content-type": "application/json" };

  return fetch(`${API_URL}${path}`, {
    method: "post",
    headers,
    body: JSON.stringify(values),
  })
    .then((res) => res.json())
    .then((json) => v.parse(schema, json));
}

export const api = {
  users,
  verbs,
  nouns,
};

export type Api = typeof api;

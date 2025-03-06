import { v } from "~/utils/valibot";

export const UserSchema = v.object({
  id: v.string(),
  email: v.pipe(v.string(), v.email()),
});

export type User = v.InferOutput<typeof UserSchema>;

export const CreateUserSchema = v.object({
  email: v.pipe(v.string(), v.email()),
});

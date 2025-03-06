import { createForm } from "@tanstack/solid-form";
import { createFileRoute, useNavigate } from "@tanstack/solid-router";
import { CreateUserSchema } from "~/core/users/users.schema";
import { api } from "~/api";
import { createMutation } from "@tanstack/solid-query";

export const Route = createFileRoute("/console/users/create")({
  component: RouteComponent,
});

function RouteComponent() {
  const navigate = useNavigate();
  const create = createMutation(() => ({
    ...api.users.create,
    onSuccess: (data) =>
      navigate({ to: "/console/users/$user_id", params: { user_id: data.id } }),
  }));
  const form = createForm(() => ({
    defaultValues: {
      email: "",
    },
    validators: { onBlur: CreateUserSchema },
    onSubmit: ({ value }) => {
      create.mutate(value);
    },
  }));

  return (
    <div>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          e.stopPropagation();
          form.handleSubmit();
        }}
      >
        <form.Field
          name="email"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onBlur={field().handleBlur}
                onInput={(e) => field().handleChange(e.target.value)}
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Subscribe
          // selector={(state) => ({ canSubmit: state.canSubmit,  })}
          children={(state) => (
            <button
              type="submit"
              disabled={!state().canSubmit || state().isPristine}
            >
              Submit
            </button>
          )}
        />
      </form>
    </div>
  );
}

import { createForm } from "@tanstack/solid-form";
import { createMutation, useQueryClient } from "@tanstack/solid-query";
import { createFileRoute, useNavigate } from "@tanstack/solid-router";
import { api } from "~/api";
import { VerbSchema } from "~/core/verbs/verbs.schema";

export const Route = createFileRoute("/verbs/$id")({
  component: RouteComponent,
  loader: ({ context: { api, query }, params }) =>
    query.ensureQueryData(api.verbs.find(params.id)),
});

function RouteComponent() {
  const navigate = useNavigate();
  const verb = Route.useLoaderData();

  const update = createMutation(() => ({
    ...api.verbs.update,
    onSuccess: () => navigate({ to: "/verbs" }),
  }));

  const form = createForm(() => ({
    defaultValues: verb(),
    validators: { onSubmit: VerbSchema },
    onSubmit: ({ value }) => {
      console.log(value);
      update.mutate(value);
    },
  }));

  return (
    <div class="p-8">
      <h1>Edit Verb</h1>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          e.stopPropagation();
          form.handleSubmit();
        }}
      >
        <form.Field
          name="infinitive"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Subscribe
          children={(state) => <button type="submit">Update</button>}
        />
        <h2>Present</h2>
        <form.Field
          name="present.ich"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="ich"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="present.du"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="du"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="present.er_sie_es"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="er/sie/es"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="present.wir"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="wir"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="present.ihr"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="ihr"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="present.sie"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="sie/Sie"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />

        <h2>Simple Past</h2>
        <form.Field
          name="simple_past.ich"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="ich"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="simple_past.du"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="du"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="simple_past.er_sie_es"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="er/sie/es"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="simple_past.wir"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="wir"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="simple_past.ihr"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="ihr"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="simple_past.sie"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="sie/Sie"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />

        <h2>Present Perfect</h2>
        <form.Field
          name="present_perfect.ich"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="ich"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="present_perfect.du"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="du"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="present_perfect.er_sie_es"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="er/sie/es"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="present_perfect.wir"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="wir"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="present_perfect.ihr"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="ihr"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="present_perfect.sie"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="sie/Sie"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
      </form>
    </div>
  );
}

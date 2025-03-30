import { createForm } from "@tanstack/solid-form";
import { createMutation } from "@tanstack/solid-query";
import { createFileRoute, useNavigate } from "@tanstack/solid-router";
import { api } from "~/api";
import { NounSchema } from "~/core/nouns/nouns.schema";
import { scrapNoun } from "~/core/nouns/nouns.scraper";

export const Route = createFileRoute("/nouns/$id")({
  component: RouteComponent,
  loader: ({ context: { api, query }, params }) =>
    query.ensureQueryData(api.nouns.find(params.id)),
});

function RouteComponent() {
  const navigate = useNavigate();
  const noun = Route.useLoaderData();

  const update = createMutation(() => ({
    ...api.nouns.update,
    onSuccess: () => navigate({ to: "/nouns" }),
  }));

  const form = createForm(() => ({
    defaultValues: noun(),
    validators: { onSubmit: NounSchema },
    onSubmit: ({ value }) => {
      update.mutate(value);
    },
  }));

  async function searchNoun() {
    const singular =
      form.state.values.singular.charAt(0).toUpperCase() +
      form.state.values.singular.slice(1);

    form.setFieldValue("singular", singular);
    const noun = await scrapNoun(form.state.values.singular);
    if (!noun) return;
    form.setFieldValue("article", noun.article);
    form.setFieldValue("plural", noun.plural);
    form.validateAllFields("submit");
  }

  return (
    <div class="p-8">
      <h1>Edit Noun</h1>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          e.stopPropagation();
          form.handleSubmit();
        }}
      >
        <form.Field
          name="article"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="Article (der/die/das)"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="singular"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="Singular form"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Field
          name="plural"
          children={(field) => (
            <>
              <input
                name={field().name}
                value={field().state.value}
                onInput={(e) => field().handleChange(e.target.value)}
                placeholder="Plural form"
              />
              <p>{field().state.meta.errors.map((e) => e?.message)}</p>
            </>
          )}
        />
        <form.Subscribe
          children={(state) => <button type="submit">Update</button>}
        />
      </form>
    </div>
  );
}

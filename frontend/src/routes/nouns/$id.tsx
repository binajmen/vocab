import { createForm } from "@tanstack/solid-form";
import { createMutation } from "@tanstack/solid-query";
import { createFileRoute, useNavigate } from "@tanstack/solid-router";
import { api } from "~/api";
import { ButtonGroup } from "~/components/button";
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

  async function searchTranslations() {
    const noun = await scrapNoun(form.state.values.singular);
    console.log(noun);
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
        <ButtonGroup>
          <form.Subscribe
            children={(state) => <button type="submit">Update</button>}
          />
          <button type="button" onClick={searchTranslations}>
            Translations
          </button>
          <button type="button">Delete</button>
        </ButtonGroup>
      </form>
    </div>
  );
}

import { createForm } from "@tanstack/solid-form";
import { createMutation } from "@tanstack/solid-query";
import { createFileRoute, useNavigate } from "@tanstack/solid-router";
import { api } from "~/api";
import { ButtonGroup } from "~/components/button";
import { CreateNounSchema } from "~/core/nouns/nouns.schema";
import { scrapNoun } from "~/core/nouns/nouns.scraper";

export const Route = createFileRoute("/nouns/create")({
  component: RouteComponent,
});

function RouteComponent() {
  const navigate = useNavigate();
  const create = createMutation(() => ({
    ...api.nouns.create,
    onSuccess: (data) =>
      navigate({ to: "/nouns/$id", params: { id: data.id } }),
  }));

  const form = createForm(() => ({
    defaultValues: {
      article: "",
      singular: "",
      plural: "",
    },
    validators: { onSubmit: CreateNounSchema },
    onSubmit: ({ value }) => {
      create.mutate(value);
    },
  }));

  async function searchNoun() {
    const singular =
      form.state.values.singular.charAt(0).toUpperCase() +
      form.state.values.singular.slice(1);
    form.reset();
    form.setFieldValue("singular", singular);
    const noun = await scrapNoun(form.state.values.singular);
    console.log(noun);
    if (!noun) return;
    form.setFieldValue("article", noun.article);
    form.setFieldValue("plural", noun.plural);
    form.validateAllFields("submit");
  }

  return (
    <div class="p-8">
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
          <button type="button" onClick={searchNoun}>
            Search
          </button>
          <form.Subscribe
            // selector={(state) => ({
            //   canSubmit: state.canSubmit,
            //   isPristine: state.isPristine,
            // })}
            children={(state) => (
              <button
                type="submit"
                // TODO: report issue where canSubmit is set to false even with valid data
                // disabled={!state().canSubmit || state().isPristine}
              >
                Submit
              </button>
            )}
          />
        </ButtonGroup>
      </form>
    </div>
  );
}

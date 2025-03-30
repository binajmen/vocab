import { createForm } from "@tanstack/solid-form";
import { createMutation } from "@tanstack/solid-query";
import { createFileRoute, useNavigate } from "@tanstack/solid-router";
import { api } from "~/api";
import { CreateVerbSchema } from "~/core/verbs/verbs.schema";
import { scrapVerb } from "~/core/verbs/verbs.scraper";

export const Route = createFileRoute("/verbs/create")({
  component: RouteComponent,
});

function RouteComponent() {
  const navigate = useNavigate();
  const create = createMutation(() => ({
    ...api.verbs.create,
    onSuccess: (data) => navigate({ to: "/verbs" }),
  }));

  const form = createForm(() => ({
    defaultValues: {
      infinitive: "sein",
      present: { ich: "", du: "", er_sie_es: "", wir: "", ihr: "", sie: "" },
      simple_past: {
        ich: "",
        du: "",
        er_sie_es: "",
        wir: "",
        ihr: "",
        sie: "",
      },
      present_perfect: {
        ich: "",
        du: "",
        er_sie_es: "",
        wir: "",
        ihr: "",
        sie: "",
      },
    },
    validators: { onSubmit: CreateVerbSchema },
    onSubmit: ({ value }) => {
      console.log(value);
      create.mutate(value);
    },
  }));

  async function searchVerb() {
    const verb = await scrapVerb(form.state.values.infinitive);
    form.setFieldValue("infinitive", verb.infinitive);
    form.setFieldValue("present", verb.present);
    form.setFieldValue("simple_past", verb.simple_past);
    form.setFieldValue("present_perfect", verb.present_perfect);
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
        <div class="inline-grid grid-flow-col auto-cols-fr gap-8">
          <button type="button" onClick={searchVerb}>
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
        </div>
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

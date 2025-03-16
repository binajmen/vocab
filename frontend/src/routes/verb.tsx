import { createFileRoute } from "@tanstack/solid-router";
import { Match, Switch, createSignal } from "solid-js";
import type { Conjugation } from "~/core/verb/verb.type";
import { scrapVerb } from "~/lib/scraper";
import { insert_verb } from "~/sqlite/insert_verb";
import { select_random_verb } from "~/sqlite/select_random_verb";

export const Route = createFileRoute("/verb")({
  component: Verb,
});

function Verb() {
  const [verb, setVerb] = createSignal("");
  const [conjugation, setConjugation] = createSignal<Conjugation | null>(null);
  const [face, setFace] = createSignal<"recto" | "verso" | null>(null);
  let rawRef: HTMLDetailsElement;

  async function scrap() {
    rawRef!.open = false;
    const conjugation = await scrapVerb(verb());
    setConjugation(conjugation);
    setVerb("");
    await insert_verb(conjugation);
  }

  async function random() {
    rawRef!.open = false;
    setFace("recto");
    await select_random_verb(setConjugation);
  }

  return (
    <div>
      <input
        type="text"
        name="verb"
        value={verb()}
        onInput={(e) => setVerb(e.currentTarget.value)}
      />
      <button type="button" onClick={scrap}>
        add verb
      </button>
      <div>
        <Switch
          fallback={
            <button type="button" onClick={random}>
              random
            </button>
          }
        >
          <Match when={face() === "recto"}>
            <h1>{conjugation()?.infinitive}</h1>
            <button type="button" onClick={() => setFace("verso")}>
              answer
            </button>
          </Match>
          <Match when={face() === "verso"}>
            <h1>{conjugation()?.perfect.ich}</h1>
            <button type="button" onClick={random}>
              random
            </button>
          </Match>
        </Switch>
      </div>
      <details ref={rawRef!}>
        <summary>Raw</summary>
        <pre>{JSON.stringify(conjugation(), null, 2)}</pre>
      </details>
    </div>
  );
}

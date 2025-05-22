import { createSignal, Match, onMount, Show, Switch, type JSX } from "solid-js";
import {
  createFileRoute,
  Link,
  useLoaderData,
  useLoaderDeps,
} from "@tanstack/solid-router";
import Papa from "papaparse";

type Noun = {
  type: "noun";
  Französisch: string;
  Artikel: string;
  Singular: string;
  Plural: string | null;
};

type Verb = {
  type: "verb";
  Französisch: string;
  Infinitiv: string;
  Präsens: string;
  Präteritum: string;
  Perfekt: string;
};

type Misc = {
  type: "misc";
  Französisch: string;
  Deutsch: string;
};

type Term = Noun | Verb | Misc;

export const Route = createFileRoute("/learn")({
  component: Learn,
  loader: async () => {
    const [nounsCsv, verbsCsv, miscCsv] = await Promise.all([
      fetch("/nouns.csv").then((res) => res.text()),
      fetch("/verbs.csv").then((res) => res.text()),
      fetch("/misc.csv").then((res) => res.text()),
    ]);

    const nouns = Papa.parse<Noun>(nounsCsv, {
      header: true,
      skipEmptyLines: true,
    }).data;
    const verbs = Papa.parse<Verb>(verbsCsv, {
      header: true,
      skipEmptyLines: true,
    }).data;
    const misc = Papa.parse<Misc>(miscCsv, {
      header: true,
      skipEmptyLines: true,
    }).data;

    return [nouns, verbs, misc];
  },
});

export default function Learn(): JSX.Element {
  const vocabulary = Route.useLoaderData();

  const [current, setCurrent] = createSignal<Term | null>(null);
  const [type, setType] = createSignal<"noun" | "verb" | "misc" | null>(null);

  function random() {
    const types = ["noun", "verb", "misc"];
    const typeIndex = Math.floor(Math.random() * types.length);
    const itemIndex = Math.floor(
      Math.random() * vocabulary()[typeIndex].length,
    );
    setCurrent(vocabulary()[typeIndex][itemIndex]);
    setType(types[typeIndex] as "noun" | "verb" | "misc");
  }

  random();

  return (
    <Switch fallback={"you should not see this.."}>
      <Match when={type() === "noun"}>
        <Noun noun={current() as Noun} random={random} />
      </Match>
      <Match when={type() === "verb"}>
        <Verb verb={current() as Verb} random={random} />
      </Match>
      <Match when={type() === "misc"}>
        <Misc misc={current() as Misc} random={random} />
      </Match>
    </Switch>
  );
}

function Noun(props: { noun: Noun; random: () => void }) {
  const [step, setStep] = createSignal(0);

  function next() {
    if (step() < 2) setStep((step) => step + 1);
    else {
      setStep(0);
      props.random();
    }
  }

  return (
    <button
      type="button"
      class="min-h-screen w-full flex items-center justify-center text-2xl"
      onClick={next}
    >
      <div class="flex flex-col gap-2">
        <Show when={step() >= 0}>
          <strong>{props.noun.Französisch}</strong>
        </Show>
        <Show when={step() === 1}>
          <span>___ {props.noun.Singular}</span>
        </Show>
        <Show when={step() >= 2}>
          <span>
            {props.noun.Artikel} {props.noun.Singular}
          </span>
          <span>{props.noun.Plural || "--"}</span>
        </Show>
      </div>
    </button>
  );
}

function Verb(props: { verb: Verb; random: () => void }) {
  const [step, setStep] = createSignal(0);

  function next() {
    if (step() < 2) setStep((step) => step + 1);
    else {
      setStep(0);
      props.random();
    }
  }

  return (
    <button
      type="button"
      class="min-h-screen w-full flex items-center justify-center text-2xl"
      onClick={next}
    >
      <div class="flex flex-col gap-2">
        <Show when={step() >= 0}>
          <strong>{props.verb.Französisch}</strong>
        </Show>
        <Show when={step() >= 1}>
          <span>{props.verb.Infinitiv}</span>
        </Show>
        <Show when={step() >= 2}>
          <span class="pt-2 border-t border-dashed">{props.verb.Präsens}</span>
          <span>{props.verb.Präteritum}</span>
          <span>{props.verb.Perfekt}</span>
        </Show>
      </div>
    </button>
  );
}

function Misc(props: { misc: Misc; random: () => void }) {
  const [step, setStep] = createSignal(0);

  function next() {
    if (step() < 1) setStep((step) => step + 1);
    else {
      setStep(0);
      props.random();
    }
  }

  return (
    <button
      type="button"
      class="min-h-screen w-full flex items-center justify-center text-2xl"
      onClick={next}
    >
      <div class="flex flex-col gap-2">
        <Show when={step() >= 0}>
          <strong>{props.misc.Französisch}</strong>
        </Show>
        <Show when={step() >= 1}>
          <span>{props.misc.Deutsch}</span>
        </Show>
      </div>
    </button>
  );
}

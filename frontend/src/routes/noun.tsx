import { createFileRoute } from "@tanstack/solid-router";
import { For, Match, Switch, createSignal } from "solid-js";
import { scrapNoun } from "~/core/noun/noun.scraper";
import type { Noun } from "~/core/noun/noun.type";
import { logs } from "~/logger";

export const Route = createFileRoute("/noun")({
  component: NounRoute,
});

function NounRoute() {
  const [input, setInput] = createSignal("");
  const [noun, setNoun] = createSignal<Noun | null>(null);
  const [face, setFace] = createSignal<"recto" | "verso" | null>(null);
  let rawRef: HTMLDetailsElement;

  async function scrap() {
    rawRef!.open = false;
    const noun = await scrapNoun(input());
    setNoun(noun);
    setInput("");
    // await insert_noun(conjugation);
  }

  async function random() {
    rawRef!.open = false;
    setFace("recto");
    // await select_random_noun(setConjugation);
  }

  return (
    <div
      style={{
        height: "100vh",
        display: "flex",
        "flex-direction": "column",
        "justify-content": "center",
        "align-items": "center",
        padding: "1rem",
      }}
    >
      <div
        style={{
          display: "flex",
          gap: "0.5rem",
          "margin-bottom": "2rem",
        }}
      >
        <input
          type="text"
          name="noun"
          value={input()}
          onInput={(e) => setInput(e.currentTarget.value)}
          style={{
            padding: "0.5rem",
            border: "1px solid #ccc",
            "border-radius": "4px",
          }}
        />
        <button
          type="button"
          onClick={scrap}
          style={{
            padding: "0.5rem 1rem",
            "background-color": "#4a90e2",
            color: "white",
            border: "none",
            "border-radius": "4px",
            cursor: "pointer",
          }}
        >
          add noun
        </button>
      </div>

      <main
        style={{
          display: "flex",
          "flex-direction": "column",
          "align-items": "center",
          "justify-content": "center",
          "min-height": "200px",
          width: "100%",
          "max-width": "500px",
          "margin-bottom": "2rem",
        }}
      >
        <Switch
          fallback={
            <button
              type="button"
              onClick={random}
              style={{
                padding: "0.75rem 1.5rem",
                "background-color": "#4a90e2",
                color: "white",
                border: "none",
                "border-radius": "4px",
                cursor: "pointer",
                "font-size": "1.1rem",
              }}
            >
              random
            </button>
          }
        >
          <Match when={face() === "recto"}>
            <h1
              style={{
                "font-size": "2rem",
                "margin-bottom": "1.5rem",
              }}
            >
              {noun()?.singular.replace(noun()!.article, "___")}
            </h1>
            <button
              type="button"
              onClick={() => setFace("verso")}
              style={{
                padding: "0.75rem 1.5rem",
                "background-color": "#4a90e2",
                color: "white",
                border: "none",
                "border-radius": "4px",
                cursor: "pointer",
              }}
            >
              answer
            </button>
          </Match>
          <Match when={face() === "verso"}>
            <h1
              style={{
                "font-size": "2rem",
                "margin-bottom": "1.5rem",
              }}
            >
              {noun()?.singular}
              {noun()?.plural}
            </h1>
            <button
              type="button"
              onClick={random}
              style={{
                padding: "0.75rem 1.5rem",
                "background-color": "#4a90e2",
                color: "white",
                border: "none",
                "border-radius": "4px",
                cursor: "pointer",
              }}
            >
              random
            </button>
          </Match>
        </Switch>
      </main>

      <div
        style={{
          width: "100%",
          "max-width": "500px",
        }}
      >
        <details
          ref={rawRef!}
          style={{
            "margin-bottom": "1rem",
            border: "1px solid #eee",
            padding: "0.5rem",
            "border-radius": "4px",
          }}
        >
          <summary style={{ cursor: "pointer" }}>Raw</summary>
          <pre
            style={{
              "background-color": "#f5f5f5",
              padding: "0.75rem",
              overflow: "auto",
              "border-radius": "4px",
              "margin-top": "0.5rem",
            }}
          >
            {JSON.stringify(noun(), null, 2)}
          </pre>
        </details>

        <details
          style={{
            border: "1px solid #eee",
            padding: "0.5rem",
            "border-radius": "4px",
          }}
        >
          <summary style={{ cursor: "pointer" }}>Logs</summary>
          <div
            style={{
              "max-height": "200px",
              "overflow-y": "auto",
              "background-color": "#f5f5f5",
              "border-radius": "4px",
              "margin-top": "0.5rem",
            }}
          >
            <For each={logs()}>
              {(log) => (
                <div style={{ padding: "0.25rem 0.75rem" }}>
                  <pre>{log}</pre>
                </div>
              )}
            </For>
          </div>
        </details>
      </div>
    </div>
  );
}

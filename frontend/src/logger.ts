import { createSignal } from "solid-js";

export const [logs, setLogs] = createSignal<string[]>([]);

export function log(...messages: string[]) {
  setLogs((logs) => [...logs, messages.join(" ")]);
}

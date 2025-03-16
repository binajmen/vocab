export const __pronouns = [
  "ich",
  "du",
  "er_sie_es",
  "wir",
  "ihr",
  "sie",
] as const;

export type Pronoun = (typeof __pronouns)[number];

export function isPronoun(value: string): value is Pronoun {
  return (
    value === "ich" ||
    value === "du" ||
    value === "er_sie_es" ||
    value === "wir" ||
    value === "ihr" ||
    value === "sie"
  );
}

export type Conjugation = {
  infinitive: string;
  present: Record<Pronoun, string>;
  past: Record<Pronoun, string>;
  perfect: Record<Pronoun, string>;
};

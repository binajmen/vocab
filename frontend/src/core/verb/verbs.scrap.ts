export async function fetchVerb(verb: string) {
  const res = await fetch(
    `https://en.pons.com/verb-tables/german/${verb}`,
  ).then((res) => res.text());
  return res;
}

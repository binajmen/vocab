import * as cheerio from "cheerio";
import type { Article } from "./noun.type";

export async function scrapNoun(noun: string) {
  const html = fetchNoun(noun);
  const $ = cheerio.load(html);

  // Find the inflection table
  const table = $(".inflection-table");

  // Extract singular and plural forms from the Nominativ row
  const nominativRow = table.find("tr").eq(1); // Second row (index 1) contains Nominativ forms
  const singularCell = nominativRow.find("td").eq(0);
  const pluralCell = nominativRow.find("td").eq(1);

  const singular = singularCell.text().trim();
  const plural = pluralCell.text().trim();

  // Determine gender from the singular form article
  let article: Article;
  if (singular.startsWith("das")) {
    article = "das";
  } else if (singular.startsWith("der")) {
    article = "der";
  } else if (singular.startsWith("die")) {
    article = "die";
  } else {
    throw new Error("Could not determine gender from singular form");
  }

  console.log({ article, singular, plural });

  return { article, singular, plural };
}

export async function fetchNoun(noun: string) {
  const res = await fetch(`https://de.wiktionary.org/wiki/${noun}`).then(
    (res) => res.text(),
  );
  return res;
}

import * as cheerio from "cheerio";
import type { Article } from "./nouns.schema";

export async function scrapNoun(noun: string) {
  const html = await fetchNoun(noun);
  const parsed = parseWikitextContent(html);
  console.log(parsed);

  return parsed;
}

/**
 * Parse Wiktionary XML content to extract word metadata
 *
 * This function extracts specific word data from German Wiktionary XML:
 * - gender (Genus)
 * - singular form (Nominativ Singular)
 * - plural form (Nominativ Plural)
 * - French translation (fr) with gender
 *
 * @param xmlContent - The XML content from Wiktionary
 * @returns An object with extracted word information
 */
export function parseWikitextContent(xmlContent: string) {
  // Extract the text content from XML
  const textContentMatch = /<text[^>]*>([\s\S]*?)<\/text>/i.exec(xmlContent);
  if (!textContentMatch || !textContentMatch[1]) {
    throw new Error("Could not find text content in XML");
  }

  const wikitext = textContentMatch[1];

  // Extract the gender (Genus)
  const genusMatch = /\|Genus=(\w+)/i.exec(wikitext);
  const gender = genusMatch?.[1];
  if (!gender) return null;
  console.log(gender);

  // Get the appropriate article based on gender
  let article: "der" | "die" | "das" | null = null;
  if (gender === "m") article = "der";
  if (gender === "f") article = "die";
  if (gender === "n") article = "das";
  if (!article) return null;
  console.log(article);

  // Extract singular form
  const singularMatch = /\|Nominativ Singular=([^\|\n]+)/i.exec(wikitext);
  const singular = singularMatch ? singularMatch[1].trim() : null;
  if (!singular) return null;
  console.log(singular);

  // Extract plural form
  const pluralMatch = /\|Nominativ Plural(?:\s*\d*)?=([^\|\n]+)/i.exec(
    wikitext,
  );
  const plural = pluralMatch ? pluralMatch[1].trim() : null;
  if (!plural) return null;
  console.log(plural);

  // Extract French translation with gender information
  const frenchRegex = /\*\{\{fr\}\}: \{\{Ü\|fr\|([^}]+)\}\}/;
  const french = wikitext.match(frenchRegex);
  // const fr = frMatch ? frMatch[1] : null;
  // const frTranslations = findFrenchTranslations(wikitext);
  // // Use the first translation if multiple are found (common case for different meanings)
  // const frData =
  //   frTranslations && frTranslations.length > 0 ? frTranslations[0] : null;
  //
  return {
    article,
    singular,
    plural,
    french: french ? french[1] : null,
    // fr: frData ? frData.word : null,
    // frGender: frData ? frData.gender : null,
  };
}

/**
 * Extract all French translations from Wiktionary text
 *
 * @param text - The Wiktionary text content
 * @returns Array of French translations with their gender
 */
function findFrenchTranslations(
  text: string,
): Array<{ word: string; gender: string | null }> | null {
  // Look for patterns like *{{fr}}: {{Ü|fr|livre}} {{m}} in any translation table
  const pattern =
    /\*\{\{fr\}\}:\s*\{\{Ü\|fr\|([^}]+)\}\}(?:\s*\{\{([mfn])\}\})?/g;
  const matches = [];

  let match: Array<any> = [];
  while ((match = pattern.exec(text)) !== null) {
    matches.push({
      word: match[1],
      gender: match[2] || null,
    });
  }

  return matches.length > 0 ? matches : null;
}

// Example usage with fetch:
/**
 * Fetches and parses a German Wiktionary entry
 *
 * @param word - The German word to look up
 * @returns Promise with the parsed word data
 */
export async function fetchAndParseWiktionaryEntry(word: string) {
  try {
    const response = await fetch(
      `https://de.wiktionary.org/w/api.php?action=query&titles=${encodeURIComponent(word)}&export=1&format=json`,
    );
    const data = await response.text();
    return parseWikitextContent(data);
  } catch (error) {
    console.error("Error fetching or parsing Wiktionary data:", error);
    return null;
  }
}

// Usage example:
// import { fetchAndParseWiktionaryEntry } from './wiktionary-parser';
//
// async function getWordInfo() {
//   const wordData = await fetchAndParseWiktionaryEntry('Buch');
//   console.log(wordData);
//   // { gender: 'n', article: 'das', singular: 'Buch', plural: 'Bücher', fr: 'livre', frGender: 'm' }
// }

export async function fetchNoun(noun: string) {
  const res = await fetch(
    `https://de.wiktionary.org/w/api.php?format=json&action=query&origin=*&export&exportnowrap&titles=${noun}`,
  ).then((res) => res.text());
  // const res = await fetch(`https://de.wiktionary.org/wiki/${noun}`, {
  //   // mode: "no-cors",
  // }).then((res) => res.text());
  return res;
}

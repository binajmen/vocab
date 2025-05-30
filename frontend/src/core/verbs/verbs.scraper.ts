import * as cheerio from "cheerio";
import {
  type CreateVerb,
  type Pronoun,
  isPronoun,
} from "~/core/verbs/verbs.schema";

export async function scrapVerb(verb: string, query?: string) {
  // If query is provided, use it to construct the complete URL parameter
  const verbParam = query ? `${verb}?${query}` : verb;

  const html = await fetchVerb(verbParam);
  const $ = cheerio.load(html);

  // Check if we have a conjugation type selection page
  const variantLinks = $(".ft-variant-links");
  if (variantLinks.length > 0 && !query) {
    // Only check for variants if not already using a query
    // Look for the intransitive verb variant
    const intransitiveLink = variantLinks
      .find(".verbclass acronym[title='intransitive verb']")
      .closest("h3")
      .find("a")
      .attr("href");

    if (intransitiveLink) {
      // Extract the id parameter from the link
      const idMatch = intransitiveLink.match(/[?&]i=(\d+)/);
      if (idMatch?.[1]) {
        console.log(
          `Found intransitive variant, redirecting with i=${idMatch[1]}`,
        );
        return scrapVerb(verb, `i=${idMatch[1]}`);
      }
    }

    // If no intransitive, try to get the first available variant as fallback
    const firstLink = variantLinks
      .find(".flection-table-instances li:first-child a")
      .attr("href");

    if (firstLink) {
      const idMatch = firstLink.match(/[?&]i=(\d+)/);
      if (idMatch?.[1]) {
        console.log(
          `No intransitive variant found, using first variant with i=${idMatch[1]}`,
        );
        return scrapVerb(verb, `i=${idMatch[1]}`);
      }
    }
  }

  // Function to extract text from HTML with spans
  // biome-ignore lint/suspicious/noExplicitAny: AnyNode not re-exported
  function cleanText(element: cheerio.BasicAcceptedElems<any>) {
    // Replace all spans with their text content
    const text = $(element)
      .clone()
      .find("span.flected_form")
      .each(function () {
        $(this).replaceWith($(this).text());
      })
      .end()
      .text()
      .trim();

    return text;
  }

  // Function to extract conjugation from a table
  // biome-ignore lint/suspicious/noExplicitAny: AnyNode not re-exported
  function extractConjugationTable(table: cheerio.BasicAcceptedElems<any>) {
    const conjugations: Record<Pronoun, string> = {
      ich: "",
      du: "",
      er_sie_es: "",
      wir: "",
      ihr: "",
      sie: "",
    };

    $(table)
      .find("tr")
      .each(function () {
        const cols = $(this).find("td");
        if (cols.length < 2) return;

        const pronoun = cleanText(cols[0]).replaceAll("/", "_");
        if (!isPronoun(pronoun)) {
          console.error(pronoun, "is not a valid pronoun");
          return;
        }

        // Handle different table formats
        let verb = "";
        if (cols.length === 2) {
          verb = cleanText(cols[1]);
        } else if (cols.length >= 3) {
          // For tables with auxiliary verbs (like perfect tenses)
          const parts = [];
          for (let i = 1; i < cols.length; i++) {
            parts.push(cleanText(cols[i]));
          }
          verb = parts.join(" ");
        }

        conjugations[pronoun] = verb;
      });

    return conjugations;
  }

  // Extract all conjugation tables
  const conjugationData: Record<
    string,
    Record<string, Record<Pronoun, string>>
  > = {};

  // Process each conjugation group (mood)
  $(".ft-group").each(function () {
    const groupTitleEl = $(this).find("h2 .ft-current-header");
    if (!groupTitleEl.length) return;

    const groupTitle = groupTitleEl.text().trim();
    conjugationData[groupTitle] = {};

    // Process tables within this group (tenses)
    $(this)
      .find(".ft-single-table")
      .each(function () {
        const titleEl = $(this).find("h3");
        let tableTitle = "";

        if (titleEl.length) {
          tableTitle = titleEl.text().trim();
        } else if (groupTitle === "Imperativ") {
          tableTitle = "Imperativ Forms";
        } else {
          // Look for tables without titles in Unpersönliche Formen
          const prevTitle = $(this).prev().find("h3").text().trim();
          tableTitle = prevTitle || "Other Forms";
        }

        if (tableTitle) {
          const table = $(this).find("table");
          if (table.length) {
            conjugationData[groupTitle][tableTitle] =
              extractConjugationTable(table);
          }
        }
      });
  });

  const conjugation = {
    infinitive: verb,
    present: conjugationData.Indikativ.Präsens,
    simple_past: conjugationData.Indikativ.Präteritum,
    present_perfect: conjugationData.Indikativ.Perfekt,
  } satisfies CreateVerb;

  return conjugation;
}

export async function fetchVerb(verb: string) {
  const res = await fetch(
    `https://en.pons.com/verb-tables/german/${verb}`,
  ).then((res) => res.text());
  return res;
}

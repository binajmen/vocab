const articles = ["der", "die", "das"] as const;
export type Article = (typeof articles)[number];

export type Noun = {
  article: Article;
  singular: string;
  plural: string;
};

import {Card} from "./interfaces";

const cardSuits = [
  0, // spade
  1, // club
  2, // diamond
  3, // heart
];

// cards from 3 (1) to Ace (13)
const cardValues = Array.from({length: 13}, (k, v) => v + 1);

export const cards: Card[] = cardSuits.flatMap((suit) => {
  return cardValues.map((value) => ({value, suit}));
});

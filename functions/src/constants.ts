import {Card} from "./interfaces";

const cardSuits = [
  0, // spade
  1, // club
  2, // diamond
  3, // heart
];

const cardValues = [
  {label: "3", value: 1},
  {label: "4", value: 2},
  {label: "5", value: 3},
  {label: "6", value: 4},
  {label: "7", value: 5},
  {label: "8", value: 6},
  {label: "9", value: 7},
  {label: "10", value: 8},
  {label: "J", value: 9},
  {label: "Q", value: 10},
  {label: "K", value: 11},
  {label: "A", value: 12},
  {label: "2", value: 13},
];

export const cards: Card[] = cardSuits.flatMap((suit) => {
  return cardValues.map((card) => ({...card, suit}));
});

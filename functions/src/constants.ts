import { Card } from './interfaces';
import * as helpers from './helpers';

const cardSuits = [
  0, // spade
  1, // club
  2, // diamond
  3, // heart
];

// cards from 3 (1) to Ace (13)
const cardValues = Array.from({ length: 13 }, (k, v) => v + 1);

export const cards: Card[] = cardSuits.flatMap((suit) => {
  return cardValues.map((value) => ({ value, suit }));
});

export const moveErrors = {
  wrongAmount: (length: number): string =>
    `Wrong amount of cards (expected ${length})`,
  notRun: 'Your cards must be in a run',
  sameValueNotBetter: (length: number): string =>
    helpers.getSameValueType(length),
  notSameValue: 'Your cards must be same value',
  runNotBetter: 'Your run is not better',
  notRunNotSame: 'Your cards are neither same value nor in sequence',
};

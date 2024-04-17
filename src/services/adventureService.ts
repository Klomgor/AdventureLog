import type { Adventure } from "$lib/utils/types";

let adventures: Adventure[] = [];

import { visitCount } from "$lib/utils/stores/visitCountStore";

// Check if localStorage is available (browser environment)
const isBrowser = typeof window !== "undefined";

// 

export function getNextId() {
  let nextId = Math.max(0, ...adventures.map((adventure) => adventure.id)) + 1;
  return nextId;
}

export function setAdventures(importArray: Adventure[]) {
  adventures = importArray;
}

export function addAdventure(adventure: Adventure) {
  adventures = [...adventures, adventure];
  if (isBrowser) {
    localStorage.setItem("adventures", JSON.stringify(adventures));
    visitCount.update((n) => n + 1);
  }
  console.log(adventures);
}

export function getAdventures(): Adventure[] {
  return adventures;
}

export function clearAdventures() {
  adventures = [];
  if (isBrowser) {
    localStorage.setItem("adventures", JSON.stringify(adventures));
    visitCount.set(0);
  }
}
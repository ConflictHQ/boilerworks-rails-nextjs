import { InMemoryCache } from "@apollo/client-integration-nextjs";

const cacheConfig = {};

export const makeCache = (): InMemoryCache => new InMemoryCache(cacheConfig);

let _clientCache: InMemoryCache | null = null;
export const getClientCache = (): InMemoryCache =>
  (_clientCache ??= new InMemoryCache(cacheConfig));

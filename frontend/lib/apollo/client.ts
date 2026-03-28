import { HttpLink } from "@apollo/client";
import { registerApolloClient, ApolloClient } from "@apollo/client-integration-nextjs";
import { makeCache } from "./cache";

const API_URL = `${process.env.NEXT_PUBLIC_API_ROOT ?? "http://localhost:3001"}/graphql`;

export const { getClient, query, PreloadQuery } = registerApolloClient(async () => {
  // For SSR, we forward cookies to the Rails backend
  const httpLink = new HttpLink({
    uri: API_URL,
    credentials: "include",
    fetchOptions: {
      cache: "no-store",
    },
  });

  return new ApolloClient({
    cache: makeCache(),
    link: httpLink,
  });
});

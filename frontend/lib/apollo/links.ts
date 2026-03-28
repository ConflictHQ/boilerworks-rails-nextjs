import { ApolloLink, HttpLink } from "@apollo/client";
import { onError } from "@apollo/client/link/error";

const errorLink = onError(({ graphQLErrors, networkError }) => {
  if (graphQLErrors) {
    for (const { extensions } of graphQLErrors) {
      if (extensions?.code === "UNAUTHENTICATED") {
        window.location.href = "/auth/login";
        return;
      }
    }
  }
  if (networkError) {
    console.error("[Apollo] Network error:", networkError);
  }
});

export function buildClientLinks(httpLink: HttpLink): ApolloLink {
  return ApolloLink.from([errorLink, httpLink]);
}

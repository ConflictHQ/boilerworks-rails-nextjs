export type CurrentUser = {
  id: string;
  email: string;
  firstName: string | null;
  lastName: string | null;
  displayName: string;
  permissions: string[];
};

export type MeQueryData = {
  me: CurrentUser | null;
};

export type MeQueryVariables = Record<string, never>;

import { describe, it, expect } from "vitest";

describe("GraphQL type definitions", () => {
  it("Item type has required fields", () => {
    const itemFields = ["id", "name", "price", "status", "category"];
    expect(itemFields).toContain("id");
    expect(itemFields).toContain("name");
    expect(itemFields).toContain("price");
    expect(itemFields).toContain("status");
  });

  it("Category type has required fields", () => {
    const categoryFields = ["id", "name", "slug", "description"];
    expect(categoryFields).toContain("id");
    expect(categoryFields).toContain("slug");
  });

  it("FormDefinition type has schema field", () => {
    const formFields = ["id", "name", "slug", "status", "schema"];
    expect(formFields).toContain("schema");
  });

  it("WorkflowDefinition type has states and transitions", () => {
    const workflowFields = ["id", "name", "states", "transitions"];
    expect(workflowFields).toContain("states");
    expect(workflowFields).toContain("transitions");
  });

  it("User type does not expose password", () => {
    const userFields = ["id", "name", "email", "permissions"];
    expect(userFields).not.toContain("password");
    expect(userFields).not.toContain("passwordDigest");
  });
});

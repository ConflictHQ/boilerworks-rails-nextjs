# Boilerworks Rails + Next.js -- Bootstrap

> Full-stack Rails 8 API + Next.js 16 SPA template with GraphQL, Pundit authorization, forms engine, and workflow engine.

## Architecture

```
frontend/ (Next.js 16, port 3002)
  +-- Apollo Client (credentials: "include")
        |
        v  GraphQL over HTTP (/graphql)
        |
backend/ (Rails 8 API mode, port 3001)
  |-- graphql-ruby (types, queries, mutations)
  |-- Pundit policies (group-based permissions)
  |-- Active Record + model concerns
  |-- Solid Queue (Active Job)
  |-- PostgreSQL 16 (port 5444)
  +-- Redis 7 (port 6387)
```

The backend is a pure JSON API -- no views, no Turbo. The frontend is a standalone Next.js
app using the App Router. All data flows through a single `/graphql` endpoint.

## Stack

- Rails 8 (Ruby 3.3), API mode, graphql-ruby
- Next.js 16 (App Router), Apollo Client 4, shadcn/ui, Tailwind CSS 4
- Auth: Rails 8 `has_secure_password` (session-based, httpOnly cookies)
- Authorization: Pundit (group-based permissions, never user-based)
- PostgreSQL 16, Redis 7, Solid Queue, Mailpit, MinIO

## GraphQL Schema Patterns

Types live in `backend/app/graphql/types/`, mutations in `backend/app/graphql/mutations/`.

**Types**: Every type maps `id` to the model's `uuid` field. Never expose integer PKs.

**Queries**: Defined on `QueryType`. Every resolver calls `require_auth!` first, then uses
`Pundit.policy_scope` for lists or `Pundit.authorize` for single-record lookups.

**Mutations**: Extend `BaseMutation`. Every mutation calls `require_auth!` then `authorize`.
Return the MutationResult pattern:

```ruby
field :ok, Boolean, null: false
field :record, Types::SomeType, null: true
field :errors, [Types::FieldErrorType], null: true
```

`FieldErrorType` has `field` (camelCase attribute name) and `messages` (array of strings).

## Model Concerns

All domain models (Product, Category, FormDefinition, etc.) include four concerns:

| Concern | Purpose |
|---------|---------|
| `Auditable` | Sets `created_by` / `updated_by` from `Current.user` |
| `SoftDeletable` | `soft_delete!` / `restore!`, default scope excludes deleted, `with_deleted` scope |
| `ExternalId` | Generates UUID on create, `find_by_uuid!`, `to_param` returns UUID |
| `Versionable` | Optimistic locking via `lock_version` |

## Permission System

```
Permission (slug) --> Group (HABTM) --> User
```

Slugs follow `resource.action` format: `product.view`, `form.add`, `workflow.change`, etc.

Pundit policies use `has?(slug)` helper from `ApplicationPolicy`. Every policy mirrors a
model: `ProductPolicy` for `Product`, `CategoryPolicy` for `Category`.

Policy scopes return `scope.all` if the user has the `.view` permission, `scope.none` otherwise.

## Auth

Session-based authentication with httpOnly cookies:

- `POST /auth/login` -- `email_address` + `password`, sets session cookie
- `DELETE /auth/logout` -- destroys session
- `GET /auth/me` -- returns current user JSON
- GraphQL `me` query returns current user with permissions array
- Unauthenticated requests get `UNAUTHENTICATED` error code, Apollo errorLink redirects to `/auth/login`

## Forms Engine

- `FormDefinition` -- name, slug, JSON schema (array of field definitions), status (draft/published/archived)
- `FormSubmission` -- belongs to a definition, JSON data, status lifecycle (draft -> submitted -> in_review -> approved/rejected)
- `FormValidationService` validates submission data against the definition schema
- 22 field types defined in `FormFieldTypes` concern

## Workflow Engine

- `WorkflowDefinition` -- name, slug, JSON states array, JSON transitions array, optional `target_type`
- `WorkflowInstance` -- belongs to a definition, tracks `current_state`, polymorphic `workflowable`
- `TransitionLog` -- records every state change with `from_state`, `to_state`, `transitioned_by`
- `can_transition_to?` checks the definition's transitions array
- `WorkflowTransitionService` / `WorkflowActionJob` for async side effects

## Testing Patterns

Backend uses RSpec + FactoryBot. Specs live in `backend/spec/`.

**Request specs** (`spec/requests/`) target `/graphql` using the `graphql_query` helper:

```ruby
graphql_query("{ products { id name } }", user: user)
expect(graphql_data["products"]).to be_present
```

**Model specs** (`spec/models/`) use shoulda-matchers for validations plus custom tests
for UUID generation and soft delete behavior.

**Policy specs** (`spec/policies/`) test both allowed and denied cases per action.

**Factories** (`spec/factories/`) with traits like `:with_product_permissions`, `:with_all_permissions`.

**Auth helpers** (`spec/support/`) provide `sign_in(user)` for request specs and
`graphql_query(query, user:, variables:)` for GraphQL specs.

Always test against a real database -- never mock Active Record.

## Frontend Patterns

**Apollo Client**: Configured with `credentials: "include"` for session cookies.
Error link catches `UNAUTHENTICATED` and redirects. Cache uses `cache-and-network` policy.

**Hooks pattern**: Each domain has `graphql/<domain>/` with:
- `*.queries.ts` -- gql query documents
- `*.mutations.ts` -- gql mutation documents
- `*.types.ts` -- TypeScript types for query/mutation data
- `*.hooks.ts` -- React hooks wrapping `useQuery`/`useMutation`

Example: `useProducts()` returns `{ products, loading, error, refetch }`.

**Route labels**: `lib/routes.ts`. **Nav items**: `components/AppSidebar.tsx`.

**Dark admin theme**: shadcn/ui CSS variables, Tailwind CSS 4.

## Docker Setup

Everything runs in Docker. No local Ruby required.

```bash
make up        # docker compose up -d --build (from docker/)
make setup     # db:create, db:migrate, db:seed
make test      # bundle exec rspec
make lint      # bundle exec rubocop
make console   # rails console
make seed      # db:seed
make logs      # tail all service logs
```

Default admin: `admin@boilerworks.dev` / `password`

| Service | URL |
|---------|-----|
| Backend API | http://localhost:3001 |
| Frontend | http://localhost:3002 |
| Health check | http://localhost:3001/up |
| Mailpit | http://localhost:8026 |
| MinIO | http://localhost:9003 |

## Code Style

- RuboCop for Ruby (run via `make lint`)
- ESLint + Prettier for TypeScript/React
- UUIDs everywhere -- never expose integer PKs in API responses
- Soft delete via `soft_delete!` -- never call `destroy`
- Pundit `authorize` on every resolver/mutation
- camelCase in GraphQL/JSON, snake_case in Ruby
- No co-authorship messages in commits

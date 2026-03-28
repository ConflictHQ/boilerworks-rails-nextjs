# Claude -- Boilerworks Rails + Next.js

Primary conventions doc: [`bootstrap.md`](bootstrap.md)

Read it before writing any code.

## Stack

- **Backend**: Rails 8 (API mode) with GraphQL Ruby
- **Frontend**: Next.js 16 (App Router) with Apollo Client
- **API**: GraphQL (`/graphql` endpoint)
- **ORM**: Active Record with Auditable, SoftDeletable, ExternalId, Versionable concerns
- **Auth**: Session-based (httpOnly cookies via Rails `has_secure_password`)
- **Permissions**: Pundit (group-based, never user-based)
- **Jobs**: Solid Queue (Active Job)
- **Database**: PostgreSQL 16
- **Cache**: Redis 7

## Architecture

```
frontend/ (Next.js 16, port 3002)
  +-- Apollo Client -> GraphQL API
        |
        v
backend/ (Rails 8 API, port 3001)
  |-- graphql-ruby (types, queries, mutations)
  |-- Pundit policies
  |-- Active Record + concerns
  |-- Solid Queue
  |-- PostgreSQL 16 (port 5444)
  +-- Redis 7 (port 6387)
```

## Running

Everything runs in Docker. No local Ruby required.

```bash
make up      # Start all services
make setup   # Create DB, run migrations, seed
make test    # Run RSpec
make lint    # Run RuboCop
make console # Rails console
```

## GraphQL

- Schema: `backend/app/graphql/boilerworks_schema.rb`
- Types: `backend/app/graphql/types/`
- Mutations: `backend/app/graphql/mutations/`
- Auth check at the top of every resolver via `require_auth!`
- MutationResult pattern: `{ ok, errors { field messages } }`
- Never expose integer PKs -- use `uuid` via ExternalId concern

## Auth

- POST `/auth/login` with `email_address` + `password` -- sets httpOnly session cookie
- DELETE `/auth/logout` -- destroys session
- GET `/auth/me` -- returns current user
- GraphQL `me` query returns current user with permissions
- UNAUTHENTICATED errors redirect to `/auth/login` via Apollo errorLink

## Models

All business models include:
- `Auditable` -- `created_by`, `updated_by` auto-set from `Current.user`
- `SoftDeletable` -- `soft_delete!` / `restore!`, default scope excludes deleted
- `ExternalId` -- UUID generated on create, exposed as `id` in GraphQL
- `Versionable` -- optimistic locking via `lock_version`

## Permissions

Group-based via Pundit. Permission slugs: `resource.action` (e.g., `product.view`, `form.add`).
Every GraphQL resolver calls `require_auth!` then `authorize(record, :action?)`.

## Frontend

- Apollo Client with session cookies (`credentials: "include"`)
- GraphQL operations: `frontend/graphql/<domain>/`
- Dark admin theme (shadcn/ui CSS variables)
- Hooks pattern: `useProducts()`, `useMe()`, etc.
- Route labels in `lib/routes.ts`
- Nav items in `components/AppSidebar.tsx`

## Testing

- RSpec request specs targeting `/graphql`
- FactoryBot factories in `spec/factories/`
- Auth helpers in `spec/support/`
- Real database -- never mock the database
- Test both allowed and denied permission cases

## Seeds

Default admin: `admin@boilerworks.dev` / `password`

# Calliope — Boilerworks Rails + Next.js
<!-- Agent shim for https://github.com/calliopeai/calliope-cli -->

Primary conventions doc: [`bootstrap.md`](bootstrap.md)

Read it before writing any code.

---

## Project-specific notes

- Stack: Rails 8 API + graphql-ruby backend, Next.js 16 App Router + Apollo Client frontend; PostgreSQL 16, Redis 7, Solid Queue.
- GraphQL at `/graphql`; every resolver calls `require_auth!` then `authorize(record, :action?)`; MutationResult pattern `{ ok, errors { field messages } }`.
- Models include Auditable, SoftDeletable, ExternalId (UUID exposed as `id`, never integer PKs), and Versionable (optimistic lock).
- Group-based Pundit permissions with `resource.action` slugs; session auth via httpOnly cookies (`/auth/login|logout|me`).
- Everything runs in Docker (`make up`/`make setup`/`make test`); RSpec request specs hit `/graphql` against a real DB — never mock the database.
- Frontend: Apollo with `credentials: "include"`, GraphQL ops in `frontend/graphql/<domain>/`, dark shadcn/ui theme.

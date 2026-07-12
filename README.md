# Boilerworks Rails + Next.js

> Rails 8 API backend with Next.js 16 frontend for rich, interactive applications.

**Status:** Ready

Rails 8 as a JSON API backend paired with Next.js 16 for teams that want Rails' convention-over-configuration and mature ecosystem on the backend with a modern React frontend. Choose this over Rails + Hotwire when you need a richer client-side experience, complex state management, or a separate frontend team.

## Quick start

Everything runs in Docker — no local Ruby or Node required:

```bash
make up      # build and start all services (from docker/)
make setup   # create DB, run migrations, seed
```

Frontend at http://localhost:3000, backend API at http://localhost:8000. Default admin: `admin@boilerworks.dev` / `password`.

See [`bootstrap.md`](bootstrap.md) for the full architecture, conventions, and testing patterns.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and the [stack primer](../primers/rails/PRIMER.md) for architecture and conventions.

---

Boilerworks is a [CONFLICT](https://weareconflict.com) brand. CONFLICT is a registered trademark of CONFLICT LLC.

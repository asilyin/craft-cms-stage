# craft-cms-stage

Craft CMS 5 staging project. Everything (project config, plugins, content schema) is already wired up in the repo — local setup is just about pointing it at a Postgres instance with the bundled DB dump applied.

## Requirements

- PHP **8.4** (per `craft-cloud.yaml`)
- Composer 2.x
- PostgreSQL (the dump in `db/craft.v2` was produced with `pg_dump` 18.1; any reasonably recent Postgres works)

## Setup

### 1. Spin up Postgres

Run a Postgres instance any way you like (Docker, local install, managed service). Create an empty database and a user with privileges on it. Example with Docker:

```bash
docker run -d --name craft-pg \
  -e POSTGRES_DB=craftcms \
  -e POSTGRES_USER=craftcms \
  -e POSTGRES_PASSWORD=craftcms \
  -p 5432:5432 \
  postgres:18
```

### 2. Apply the DB dump

`db/craft.v2` is a `pg_dump` SQL file. Load it into the database created above:

```bash
psql -h localhost -p 5432 -U craftcms -d craftcms -f db/craft.v2
```

### 3. Configure `.env`

> **Note:** the `.env.example.*` files in the repo are out of date — don't copy them blindly. Create `.env` in the project root with the keys below.

| Key | What to put |
|---|---|
| `CRAFT_APP_ID` | Any unique string, e.g. `CraftCMS--<uuid>` |
| `CRAFT_ENVIRONMENT` | `dev` for local |
| `CRAFT_SECURITY_KEY` | 32-char random string. Generate with `php craft setup/security-key` after `composer install`, or `openssl rand -base64 32` |
| `CRAFT_DB_DRIVER` | `pgsql` |
| `CRAFT_DB_SERVER` | Postgres host (e.g. `localhost`) |
| `CRAFT_DB_PORT` | `5432` |
| `CRAFT_DB_DATABASE` | DB name (e.g. `craftcms`) |
| `CRAFT_DB_USER` | DB user |
| `CRAFT_DB_PASSWORD` | DB password |
| `CRAFT_DB_SCHEMA` | `public` |
| `CRAFT_DB_TABLE_PREFIX` | leave empty |
| `CRAFT_DEV_MODE` | `true` |
| `CRAFT_ALLOW_ADMIN_CHANGES` | `true` |
| `CRAFT_DISALLOW_ROBOTS` | `true` |
| `PRIMARY_SITE_URL` | Local URL Craft should serve at, e.g. `http://localhost:8080/` |

### 4. Install PHP dependencies

```bash
composer install
```

### 5. Verify project config matches the DB

The repo's project config (`config/project/`) should already match what's in the dump. Confirm there's no drift:

```bash
php craft project-config/diff
```

Expected output: no differences. If something does come back, stop and investigate before continuing — applying a stale config would mutate the DB.

### 6. Run the dev server

```bash
php craft serve
```

The site will be available at the URL you set in `PRIMARY_SITE_URL` (default `http://localhost:8080/`). The control panel is at `/admin`.

# dbt-dojo

dbt project for transforming packed JSON data in MySQL, deployed via Fivetran Transformations.

Source tables contain a single `data` column (JSON type) with all fields packed inside. The staging layer unpacks these into typed, named columns. Intermediate and mart layers apply business logic and produce analytics-ready tables.

## Project structure

```
models/
├── staging/        One model per source table. Unpacks JSON, casts types, filters deletes.
├── intermediate/   Joins and business logic across staging models.
└── marts/          Denormalized, analytics-ready tables for dashboards.
macros/             Reusable SQL helpers (e.g. unpack_json_field).
tests/              Custom data tests.
seeds/              Reference/lookup CSV data.
snapshots/          SCD Type-2 tracking.
analyses/           Ad-hoc analytical queries.
```

## Setup

Requires [uv](https://docs.astral.sh/uv/) and Python 3.13.

```bash
# Create your local profiles file and edit with your credentials
cp profiles.example.yml profiles.yml

# Install dependencies
uv sync

# Install dbt packages
uv run dbt deps

# Verify connection (set DBT_MYSQL_USER / DBT_MYSQL_PASSWORD env vars first)
uv run dbt debug

# Run all models
uv run dbt run

# Run tests
uv run dbt test
```

## Adding a new entity

1. Add the source table to `models/staging/_sources.yml`.
2. Create `models/staging/stg_<entity>.sql` using the `unpack_json_field` macro.
3. Add column definitions and tests to `models/staging/_stg_models.yml`.
4. Optionally create intermediate and mart models that reference the new staging model.

## JSON unpacking

All JSON extraction uses the `unpack_json_field` macro:

```sql
select
    {{ unpack_json_field('data', 'id', 'entity_id') }},
    {{ unpack_json_field('data', 'amount', 'amount', 'decimal(18, 2)') }},
    {{ unpack_json_field('data', 'created_at', 'created_at', 'datetime') }}
from {{ source('raw', 'entity') }}
```

To change the database adapter, update only the macro in `macros/unpack_json_field.sql`.

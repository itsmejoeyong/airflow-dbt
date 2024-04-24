# Steps

1. define your shared sources directory in the root directory and `cd` into it.
2. add your dbt_project.yml file:
```
name: 'shared_src'
version: '1.0.0'
config-version: 2

# the profile you've setup during dbt init
profile: 'jaffle_shop'
```
3. create models/src.yml:
```
version: 2

sources:
  - name: stripe
    database: dbt-tutorial
    schema: stripe
    tables:
      - name: payment

  - name: jaffle_shop
    description: A clone of a Postgres application database.
    database: dbt-tutorial
    schema: jaffle_shop
    tables:
      - name: customers
        description: Raw customers data.
        columns:
          - name: id
            description: Primary key for customers.
            tests:
              - unique
              - not_null
      - name: orders
        description: Raw orders data.
        columns:
          - name: id
            description: Primary key for orders.
            tests:
              - unique
              - not_null
        loaded_at_field: _etl_loaded_at
        freshness:
          warn_after: { count: 12, period: hour }
          error_after: { count: 24, period: hour }
```
4. head to your other projects & add packages.yml with the following lines:
```
packages:
  - local: ../<your shared sources directory name>
```
5. create a duplicate profile so that each project writes to a different dataset:
```
monorepo_1:
  outputs:
    dev:
      dataset: dbt_us_monorepo_1
      job_execution_timeout_seconds: 300
      job_retries: 1
      keyfile: <redacted>
      location: US
      method: service-account
      priority: interactive
      project: <redacted>
      threads: 1
      type: bigquery
  target: dev

monorepo_2:
  outputs:
    dev:
      dataset: dbt_us_monorepo_2
      job_execution_timeout_seconds: 300
      job_retries: 1
      keyfile: <redacted>
      location: US
      method: service-account
      priority: interactive
      project: <redacted>
      threads: 1
      type: bigquery
  target: dev


```
6. modify your existing projects dbt_project.yml profile to write to a specific schema (update the directory as well):
```
# example, in jaffle_shop
...
profile: 'monorepo_1'
...
models:
  jaffle_shop:
    marts:
      core:
        +materialized: table
    staging:
      +materialized: view

# example, in jaffle_shop_2
...
profile: 'monorepo_2'
...
models:
  jaffle_shop_2:
    marts:
      core:
        +materialized: table
    staging:
      +materialized: view
```
7. run `dbt deps` on both of your dbt projects that rely on your shared sources directory
8. run `dbt run` on your other projects and it will create them in their respective schemas
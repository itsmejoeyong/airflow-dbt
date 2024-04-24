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
5. modify your existing projects dbt_project.yml to write to a specific schema (update the directory as well):
```
# example, in jaffle_shop
models:
  jaffle_shop:
    marts:
      core:
        +materialized: table
        +schema: monorepo_1
    staging:
      +materialized: view
      +schema: monorepo_1

# example, in jaffle_shop_2

models:
  jaffle_shop_2:
    marts:
      core:
        +materialized: table
        +schema: monorepo_2
    staging:
      +materialized: view
      +schema: monorepo_2
```
6. run `dbt deps` on both of your dbt projects that rely on your shared sources directory
7. run `dbt run` on your other projects and it will create them in their respective schemas
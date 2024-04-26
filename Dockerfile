FROM quay.io/astronomer/astro-runtime:10.0.0

# install dbt into a virtual environment
# added astronomer-cosmos to render method parameters
RUN python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-bigquery astronomer-cosmos && deactivate
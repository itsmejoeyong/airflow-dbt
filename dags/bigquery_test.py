from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryGetDataOperator
from airflow.utils.dates import days_ago

# These args will get passed on to each operator
# You can override them on a per-task basis during operator initialization
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "start_date": days_ago(1),
    "email": ["airflow@example.com"],
    "email_on_failure": False,
    "email_on_retry": False,
}

dag = DAG(
    "bigquery_test_query",
    default_args=default_args,
    description="A simple BigQuery test DAG",
    schedule_interval=None,  # This DAG does not have a schedule and will only be run manually
    catchup=False,  # Prevents the DAG from running for missing past dates
)

# Define the BigQuery task
test_query = BigQueryGetDataOperator(
    task_id="test_query",
    table_project_id="silicon-alchemy-420606",
    dataset_id="dbt_us",
    table_id="customers",
    gcp_conn_id="bigquery",  # The Airflow connection ID for BigQuery
    dag=dag,
)

test_query

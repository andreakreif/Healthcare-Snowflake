# Healthcare-Quality-Analysis-Snowflake

_powered by the dbt Fusion engine_

Welcome! This is a portfolio project prototyping model creation using SnowFlake.  The data is from Synthea (https://synthetichealth.github.io/synthea/)


Preconditions:
  Install Python 3.12
  Install snowflake CLI and setup config.toml with your connection(usually in $APPDATALOCAL/Snowflake). This is used by the raw data setup steps that utilize CLI. 

1. Set up your snowflake database connection in environment variables SNOWFLAKE_USER, SNOWFLAKE_ACCOUNT and SNOWFLAKE_PASSWORD. 
    These environment variables are referenced by profiles.yml which is how dbt gets a connection to build models.
   
    This syntax does it permanently but you need to restart VSCode for it to take effect
    `[System.Environment]::SetEnvironmentVariable("SNOWFLAKE_ACCOUNT","your-account",  "User")`
    This syntax does it for the current terminal session
    `$env:SNOWFLAKE_ACCOUNT="your-account"`
    Note that for some regions the account name is two parts, like xyz123-abc789, both found in the URL rather than the single part that snowflake shows as an account. 

     If you use SSO or some other authentication setup then modify profiles.yml directly to handle that.

  2. Build raw data (raw csv files in synthea_raw_csv/csv)
    a. run ./load_scripts/create_synthea_raw_tables using web interface or CLI to create database, schemas and raw data tables
    b. edit ./load_scripts/call_load_files.bat for 3 following lines to match your setup,  CONNECTION should match what is in config.toml:
        `SET DATA_DIR=C:/Users/oakwo/Documents/Portfolio_Project/Healthcare-Snowflake/synthea_raw_csv/csv`
        `SET CLI_DIR=C:/Program Files/Snowflake CLI`
        `SET CONNECTION="snowflake_trial" `
    c. run the following from powershell terminal to populate the tables in HEALTH_ANALYTICS.DBT_RAW
         `& ./call_load_files.bat`                                                                     
  
  3. Set up Python virtual environment
        Creates environment `py -3.12 -m venv .venv`
        Activates environment `.venv\Scripts\Activate.ps1`
        Installs dbt and dbt snowflake adapter `pip install dbt-core dbt-snowflake`
        Installs packages listed in dbt_packages file included in repo `dbt deps`


  dbt build --profiles-dir .

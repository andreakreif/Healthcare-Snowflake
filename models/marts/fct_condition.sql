SELECT condition_id,
    patient_id,
    encounter_id,
    code_key AS condition_code_key,
    TO_CHAR(start_dt, 'YYYYMMDD')::INT AS start_date_key,
    COALESCE(TO_CHAR(stop_dt, 'YYYYMMDD')::INT, 99991231)  AS end_date_key
FROM {{ ref('stg_conditions') }} c
LEFT JOIN {{ ref('dim_code') }} dc
    ON c.condition_code = dc.code
    AND dc.code_system = 'SNOMED'
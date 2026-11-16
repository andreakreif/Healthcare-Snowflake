SELECT observation_id, 
    patient_id, 
    encounter_id, 
    CASE WHEN observation_type = 'numeric' THEN observation_value
         ELSE NULL END AS observation_value_numeric,
    CASE WHEN observation_type = 'text' THEN observation_value
         ELSE NULL END AS observation_value_text,
    observation_units,
    observation_type,
    TO_CHAR(observation_date, 'YYYYMMDD')::INT AS observation_date_key,
    TO_CHAR(observation_date, 'YYYY')::INT AS observation_year,
    dc.code_key AS observation_code_key
FROM {{ref('stg_observations')}} obs
LEFT JOIN {{ref('dim_code')}} dc
    ON observation_code = dc.code
    AND dc.code_system = 'LOINC'
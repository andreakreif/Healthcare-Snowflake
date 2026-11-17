SELECT encounter_id, 
    TO_CHAR(start_ts, 'YYYYMMDD')::INT  AS encounter_date_key, 
    TO_CHAR(start_ts, 'YYYY')::INT  AS encounter_year,
    encounter_type_key,     
    stg_encounters.patient_id, 
    provider_id, 
    organization_id,
    payer_id,
    base_encounter_cost,
    total_claim_cost,
    payer_coverage AS payer_coverage_amount,
    reason_code,
    reason_description,
    datediff('year',dim_patient.patient_birthdate,dim_date.full_date)
        --take into account whether birth day has happened before encounter date
        - CASE WHEN DATEADD(YEAR, 
                DATEDIFF(YEAR, dim_patient.patient_birthdate, dim_date.full_date), 
                    dim_patient.patient_birthdate
                    ) > dim_date.full_date
                THEN 1
                ELSE 0 
                END AS age_at_encounter,
    datediff('year',dim_patient.patient_birthdate,dim_date.year_end_date) 
            AS age_at_year_end
FROM {{ ref('stg_encounters') }}
LEFT JOIN {{ ref('dim_patient')}} 
    ON stg_encounters.patient_id = dim_patient.patient_id
LEFT JOIN {{ ref('dim_date') }}
    ON stg_encounters.start_ts::DATE = dim_date.full_date
LEFT JOIN {{ ref('dim_encounter_type') }} 
    ON stg_encounters.encounter_class = dim_encounter_type.encounter_class
    AND stg_encounters.encounter_code = dim_encounter_type.encounter_code   
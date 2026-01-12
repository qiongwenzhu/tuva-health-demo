with cancer_patients as (
    select distinct person_id
    from {{ ref('stg_cancer_cohort') }}
)

select
    mc.claim_id,
    mc.claim_line_number,
    mc.person_id,
    mc.claim_type,
    mc.claim_start_date,
    mc.claim_end_date,
    mc.paid_amount,
    mc.allowed_amount,
    mc.charge_amount,
    mc.total_cost_amount,
    mc.service_category_1 as care_setting,
    mc.service_category_2 as care_setting_detail,
    mc.place_of_service_description,
    mc.hcpcs_code,
    mc.drg_code,
    mc.encounter_type
from cancer_patients cp
inner join {{ ref('core__medical_claim') }} mc
    on cp.person_id = mc.person_id

with cancer_cohort as (
    select
        person_id,
        cancer_type,
        recorded_date,
        row_number() over (partition by person_id order by recorded_date) as rn
    from {{ ref('stg_cancer_cohort') }}
),

primary_cancer as (
    select
        person_id,
        cancer_type,
        recorded_date as first_cancer_diagnosis_date
    from cancer_cohort
    where rn = 1
),

patient_claims as (
    select
        person_id,
        count(distinct claim_id) as total_claims,
        sum(paid_amount) as total_paid_amount,
        sum(allowed_amount) as total_allowed_amount,
        sum(total_cost_amount) as total_cost,
        min(claim_start_date) as first_claim_date,
        max(claim_end_date) as last_claim_date
    from {{ ref('int_cancer_patients_claims') }}
    group by person_id
),

spend_percentiles as (
    select
        percentile_cont(0.33) within group (order by total_paid_amount) as p33,
        percentile_cont(0.67) within group (order by total_paid_amount) as p67
    from patient_claims
)

select
    pc.person_id,
    pc.cancer_type,
    pc.first_cancer_diagnosis_date,
    coalesce(pcl.total_claims, 0) as total_claims,
    coalesce(pcl.total_paid_amount, 0) as total_paid_amount,
    coalesce(pcl.total_allowed_amount, 0) as total_allowed_amount,
    coalesce(pcl.total_cost, 0) as total_cost,
    pcl.first_claim_date,
    pcl.last_claim_date,
    case
        when pcl.total_paid_amount is null or pcl.total_paid_amount <= sp.p33 then 'Low Spend'
        when pcl.total_paid_amount <= sp.p67 then 'Medium Spend'
        else 'High Spend'
    end as spend_bucket
from primary_cancer pc
left join patient_claims pcl
    on pc.person_id = pcl.person_id
cross join spend_percentiles sp

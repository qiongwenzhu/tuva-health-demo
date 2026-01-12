with claims_by_setting as (
    select
        care_setting,
        care_setting_detail,
        count(distinct person_id) as patient_count,
        count(distinct claim_id) as claim_count,
        sum(paid_amount) as total_paid_amount,
        sum(allowed_amount) as total_allowed_amount,
        sum(total_cost_amount) as total_cost,
        avg(paid_amount) as avg_paid_per_claim
    from {{ ref('int_cancer_patients_claims') }}
    group by care_setting, care_setting_detail
),

total_spend as (
    select sum(paid_amount) as grand_total_paid
    from {{ ref('int_cancer_patients_claims') }}
)

select
    cbs.care_setting,
    cbs.care_setting_detail,
    cbs.patient_count,
    cbs.claim_count,
    cbs.total_paid_amount,
    cbs.total_allowed_amount,
    cbs.total_cost,
    cbs.avg_paid_per_claim,
    round(cbs.total_paid_amount / nullif(ts.grand_total_paid, 0) * 100, 2) as pct_of_total_spend
from claims_by_setting cbs
cross join total_spend ts
order by cbs.total_paid_amount desc

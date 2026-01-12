select
    person_id,
    condition_id,
    normalized_code as icd_code,
    normalized_description as cancer_description,
    recorded_date,
    left(normalized_code, 3) as cancer_type_code,
    {{ get_cancer_type('normalized_code') }} as cancer_type
from {{ ref('core__condition') }}
where normalized_code like 'C%'  

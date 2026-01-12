{% macro get_cancer_type(icd_code_column) %}
    case
        when left({{ icd_code_column }}, 3) between 'C00' and 'C14' then 'Head and Neck'
        when left({{ icd_code_column }}, 3) between 'C15' and 'C26' then 'Digestive/GI'
        when left({{ icd_code_column }}, 3) between 'C30' and 'C39' then 'Respiratory/Lung'
        when left({{ icd_code_column }}, 3) between 'C40' and 'C41' then 'Bone'
        when left({{ icd_code_column }}, 3) between 'C43' and 'C44' then 'Skin'
        when left({{ icd_code_column }}, 3) = 'C50' then 'Breast'
        when left({{ icd_code_column }}, 3) between 'C51' and 'C58' then 'Female Reproductive'
        when left({{ icd_code_column }}, 3) between 'C60' and 'C63' then 'Male Reproductive'
        when left({{ icd_code_column }}, 3) between 'C64' and 'C68' then 'Urinary'
        when left({{ icd_code_column }}, 3) between 'C69' and 'C72' then 'Eye/Brain/CNS'
        when left({{ icd_code_column }}, 3) = 'C73' then 'Thyroid'
        when left({{ icd_code_column }}, 3) between 'C74' and 'C75' then 'Endocrine'
        when left({{ icd_code_column }}, 3) between 'C76' and 'C79' then 'Secondary/Metastatic'
        when left({{ icd_code_column }}, 3) between 'C81' and 'C86' then 'Lymphoma'
        when left({{ icd_code_column }}, 3) between 'C88' and 'C96' then 'Leukemia/Blood'
        else 'Other'
    end
{% endmacro %}

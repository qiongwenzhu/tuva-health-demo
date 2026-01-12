[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=1.5.x&color=orange)

# The Tuva Project Demo

---

# Cancer Population Analysis

## Methodology

### Defining "Cancer"
Cancer patients were identified using ICD-10 diagnosis codes starting with "C" (C00-C96), which represent malignant neoplasms. This approach uses the standardized ICD-10 classification system where:
- C00-C14: Head and Neck cancers
- C15-C26: Digestive/GI cancers
- C30-C39: Respiratory/Lung cancers
- C40-C41: Bone cancers
- C43-C44: Skin cancers
- C50: Breast cancer
- C51-C58: Female Reproductive cancers
- C60-C63: Male Reproductive cancers
- C64-C68: Urinary cancers
- C69-C72: Eye/Brain/CNS cancers
- C73: Thyroid cancer
- C74-C75: Endocrine cancers
- C76-C79: Secondary/Metastatic cancers
- C81-C86: Lymphoma
- C88-C96: Leukemia/Blood cancers

### Data Ambiguities Handled
- **Multiple Cancer Types per Patient**: A patient may have multiple cancer diagnoses. For patient-level analysis, the "primary" cancer type is determined by the earliest recorded diagnosis date.
- **Care Setting Classification**: Used the Tuva Project's `service_category_1` field which standardizes care settings into: inpatient, outpatient, ancillary, office-based, and other.

### Architecture
```
Staging:      stg_cancer_cohort           (identifies cancer patients from conditions)
                     |
Intermediate: int_cancer_patients_claims  (joins patients with all their medical claims)
                     |
Marts:        mart_cancer_cost_by_setting (cost breakdown by care setting)
              mart_cancer_summary         (patient-level summary with segmentation)
```

## Key Findings

### Cancer Prevalence
- **396 out of 1,000 patients** (39.6%) have at least one cancer diagnosis
- Total paid amount for cancer patients: **$7.76M**

### Top Cancer Types by Patient Count
| Cancer Type | Patients |
|-------------|----------|
| Skin | 197 |
| Male Reproductive | 131 |
| Breast | 73 |
| Urinary | 54 |
| Digestive/GI | 31 |

### Cost Drivers by Care Setting
| Care Setting | % of Total Spend |
|--------------|------------------|
| Inpatient (acute) | 30.5% |
| Lab (ancillary) | 9.1% |
| Office-based visits | 8.7% |
| Pharmacy (outpatient) | 8.6% |
| Office-based other | 8.2% |

**Key Insight**: Acute inpatient care accounts for nearly one-third of all cancer-related spending, representing the largest cost driver.

### Patient Spend Segmentation
| Spend Bucket | Patients | Avg Spend |
|--------------|----------|-----------|
| High Spend | 131 | $39,679 |
| Medium Spend | 134 | $14,154 |
| Low Spend | 131 | $5,093 |

## AI Usage Log

### Environment Setup
- AI assisted with setting up the local dbt + DuckDB environment, including creating the `~/.dbt/profiles.yml` configuration file and troubleshooting package installation.

### Initial Data Exploration & Design
- AI assisted with initial data exploration (inspecting seed files and sample rows) and helped decide the proper schemas and tables to use in the analysis.

### Code Generation
- **Macro Creation**: I asked the AI to create a reusable dbt macro (`macros/cancer_type.sql`) to centralize the CASE WHEN logic for mapping ICD-10 codes to cancer type categories. This avoids duplicating the bucketing logic across multiple models.
- **Test Files**: I requested AI to create test YAML files (`staging.yml`, `intermediate.yml`) with appropriate data quality tests (not_null, unique, accepted_values).


### Architecture Decisions (My Input)
- **Intermediate Table Design**: I decided to keep the intermediate model (`int_cancer_patients_claims`) simple by not including the cancer_type column directly. Instead, the cancer_type information is joined from the staging model in the mart layer. This approach:
  - Keeps the intermediate model focused on claims data
  - Avoids claim duplication for patients with multiple cancer types
  - Allows flexibility in how segmentation is applied at the mart level





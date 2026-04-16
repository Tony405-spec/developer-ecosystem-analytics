# Schema Diagram (Logical)

```
technologies (technology_id PK) 
  ├─ technology_name
  ├─ category
  ├─ released_year
  └─ lifecycle_stage

stack_overflow_questions (question_id PK)
  ├─ technology_id FK → technologies
  ├─ created_at (timestamptz)
  ├─ score, answer_count, view_count, favorite_count
  ├─ is_answered (bool)
  └─ closed_reason (text, nullable)

stack_overflow_question_tags
  ├─ question_id FK → stack_overflow_questions
  ├─ tag (text)
  └─ is_primary (bool)

developer_sentiment
  ├─ technology_id FK → technologies
  ├─ survey_year (int)
  ├─ satisfaction_score (0-1)
  ├─ adoption_score (0-1)
  └─ learning_curve (0-1, higher = harder)

companies (company_id PK)
  ├─ company_name
  ├─ parent_company_id FK → companies (nullable)
  ├─ fortune_rank (int, nullable)
  ├─ industry
  ├─ headcount
  └─ hq_country

company_tech_adoption
  ├─ company_id FK → companies
  ├─ technology_id FK → technologies
  ├─ adoption_level (trial | adopted | strategic)
  ├─ adoption_score (0-1)
  └─ first_adopted (date, nullable)

company_question_mentions
  ├─ company_id FK → companies
  └─ question_id FK → stack_overflow_questions
```

## Notes

- All percentage-style scores are expected to be normalized between 0 and 1.
- `learning_curve` treats higher values as harder-to-learn technologies.
- `company_question_mentions` captures attribution (by profile, domain, or tagging) that links questions to companies for downstream analysis.
- Queries assume PostgreSQL 14+ for `percentile_cont` and window functions. Adjust as needed for older versions.

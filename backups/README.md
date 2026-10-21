# Database Backup

Emergency backup created during Railway security incident on Oct 21, 2026.

## Backup Details

- **Date**: Oct 21, 2026
- **Reason**: Railway security incident - builds paused, credentials potentially exposed
- **Format**: JSON export of all PostgreSQL tables

## Tables Included

| Table | Rows |
|-------|------|
| users | 17 |
| purchases | 294 |
| consumption_logs | 370 |
| survey_responses | 193 |
| food_items | 155 |
| survey_questions | 24 |
| survey_question_options | 101 |
| categories | 24 |
| quantity_types | 12 |
| frequently_added_foods | 49 |
| daily_tasks | 40 |
| user_streaks | 13 |
| terms_acceptances | 2 |
| off_product_cache | 1 |
| off_search_cache | 73 |
| opennutrition_search_cache | 0 |

## Restore Instructions

This is a JSON export, not a pg_dump. To restore:

1. Parse the JSON file
2. Insert rows into each table in dependency order:
   - First: categories, quantity_types, survey_questions
   - Then: users, food_items, survey_question_options
   - Finally: purchases, survey_responses, consumption_logs, etc.

Or use the data as a reference to manually recreate if needed.

#  Developer Ecosystem Analytics Platform

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-12+-316192?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

##  Project Overview

A comprehensive analytics platform that extracts actionable insights from StackOverflow developer activity, corporate technology ownership, and financial data. This project answers critical questions like:

- **Which technologies are growing or dying?**
- **What makes a technology ecosystem healthy?**
- **How do corporate structures affect developer engagement?**
- **Which companies have the strongest developer communities?**

## Dataset Description

The analysis uses six interconnected PostgreSQL tables:

| Table | Description | Key Fields |
|-------|-------------|------------|
| `company` | Corporate entities | id, name, ticker, parent_id |
| `stackoverflow` | Daily developer questions | tag, date, question_count, unanswered_pct |
| `tag_company` | Tech-to-company mapping | tag, company_id |
| `tag_type` | Technology categorization | tag, type (language/framework/database) |
| `fortune500` | Financial metrics | rank, name, revenues, profits, employees |
| `ev311` | Municipal service data | category, date_created, street, zip |

##  Database Schema 
<p align="center">
  <img src="https://readme-typing-svg.herokuapp.com?font=Orbitron&size=22&color=FF073A&center=true&vCenter=true&width=1200&lines=┌─────────────────────────────────────────────────────────────────────────────┐;│+++++++++++DEVELOPER+ECOSYSTEM+DATABASE++++++++++++│;└─────────────────────────────────────────────────────────────────────────────┘;┌─────────────┐+++++┌──────────────┐+++++┌─────────────────┐;│+++company+++│────<│+tag_company++│>────│++stackoverflow++│;├─────────────┤+++++├──────────────┤+++++├─────────────────┤;│+id+(PK)+++++│+++++│+tag+(PK)+++++│+++++│+id+(PK)+++++++++│;│+exchange++++│+++++│+company_id+++│+++++│+tag+(FK)++++++++│;│+ticker+(UK)+│+++++└──────────────┘+++++│+date++++++++++++│;│+name++++++++│++++++++++++│++++++++++++│+question_count++│;│+parent_id+++│++++++++++++│++++++++++++│+question_pct++++│;└─────────────┘++++++++++++│++++++++++++│+unanswered_count│;+++++++++│++++++++++++++++│++++++++++++│+unanswered_pct++│;+++++++++│+(self-ref)++++│++++++++++++└─────────────────┘;+++++++++↓++++++++++++++++│++++++++++++++++++++│;++++parent-child++++++++│++++++++++++┌────────┴────────┐;++++relationship++++++++│++++++++++++│++++tag_type++++│;++++++++++++++++++++++++│++++++++++++├─────────────────┤;++++++++++++++++++++++++└───────────>│+id+(PK)+++++++++│;++++++++++++++++++++++++++++++++++++│+tag+(FK)++++++++│;++++++++++++++++++++++++++++++++++++│+type++++++++++++│;++++++++++++++++++++++++++++++++++++└─────────────────┘;┌─────────────┐+++++┌──────────────┐;│++fortune500+│+++++│++++ev311+++++│;├─────────────┤+++++├──────────────┤;│+rank+(PK)+++│+++++│+id+++++++++++│;│+title+(PK)++│+++++│+priority+++++│;│+name+(UK)+++│+++++│+source+++++++│;│+ticker++++++│+++++│+category+++++│;│+url+++++++++│+++++│+date_created+│;│+hq++++++++++│+++++│+date_completed│;│+sector++++++│+++++│+street+++++++│;│+industry++++│+++++│+house_num++++│;│+employees+++│+++++│+zip++++++++++│;│+revenues++++│+++++│+description++│;│+profits+++++│+++++└──────────────┘;│+assets++++++│;│+equity++++++│;└─────────────┘" alt="Database Schema" />
</p>

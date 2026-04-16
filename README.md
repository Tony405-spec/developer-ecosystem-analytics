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
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 900" style="background-color: #0a0a0a; font-family: 'Courier New', monospace;">
  <defs>
    <filter id="neon" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur in="SourceGraphic" stdDeviation="2" result="blur1"/>
      <feGaussianBlur in="SourceGraphic" stdDeviation="5" result="blur2"/>
      <feGaussianBlur in="SourceGraphic" stdDeviation="10" result="blur3"/>
      <feMerge>
        <feMergeNode in="blur3"/>
        <feMergeNode in="blur2"/>
        <feMergeNode in="blur1"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
    
    <filter id="glow" x="-50%" y="-50%" width="200%" height="200%">
      <feGaussianBlur in="SourceGraphic" stdDeviation="3" result="b1"/>
      <feGaussianBlur in="SourceGraphic" stdDeviation="8" result="b2"/>
      <feGaussianBlur in="SourceGraphic" stdDeviation="15" result="b3"/>
      <feMerge>
        <feMergeNode in="b3"/>
        <feMergeNode in="b2"/>
        <feMergeNode in="b1"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
  </defs>
  
  <!-- Header -->
  <rect x="150" y="20" width="900" height="45" rx="5" fill="none" stroke="#ff0040" stroke-width="2" filter="url(#glow)"/>
  <text x="600" y="50" text-anchor="middle" fill="#ff0040" font-size="20" font-weight="bold" filter="url(#neon)">⚡ DEVELOPER ECOSYSTEM DATABASE ⚡</text>
  
  <!-- COMPANY Table -->
  <rect x="40" y="90" width="250" height="220" rx="5" fill="rgba(255,0,64,0.05)" stroke="#ff0040" stroke-width="2" filter="url(#glow)"/>
  <text x="165" y="115" text-anchor="middle" fill="#ff0040" font-size="14" font-weight="bold" filter="url(#neon)">📁 company</text>
  <line x1="55" y1="125" x2="275" y2="125" stroke="#ff0040" stroke-width="1" opacity="0.6"/>
  <text x="55" y="145" fill="#ff0040" font-size="11" filter="url(#neon)">id (PK)      │ integer</text>
  <text x="55" y="165" fill="#ff0040" font-size="11" filter="url(#neon)">exchange     │ varchar</text>
  <text x="55" y="185" fill="#ff0040" font-size="11" filter="url(#neon)">ticker (UK)  │ char(5)</text>
  <text x="55" y="205" fill="#ff0040" font-size="11" filter="url(#neon)">name         │ text</text>
  <text x="55" y="225" fill="#ff0040" font-size="11" filter="url(#neon)">parent_id    │ integer</text>
  <text x="55" y="250" fill="#ff0040" font-size="10" opacity="0.8" filter="url(#neon)">└─ self-ref to id</text>
  <text x="55" y="265" fill="#ff0040" font-size="10" opacity="0.8" filter="url(#neon)">   └─ parent-child rel</text>
  
  <!-- TAG_COMPANY Table -->
  <rect x="360" y="90" width="250" height="140" rx="5" fill="rgba(255,0,64,0.05)" stroke="#ff0040" stroke-width="2" filter="url(#glow)"/>
  <text x="485" y="115" text-anchor="middle" fill="#ff0040" font-size="14" font-weight="bold" filter="url(#neon)">🔗 tag_company</text>
  <line x1="375" y1="125" x2="595" y2="125" stroke="#ff0040" stroke-width="1" opacity="0.6"/>
  <text x="375" y="148" fill="#ff0040" font-size="11" filter="url(#neon)">tag (PK)     │ varchar(30)</text>
  <text x="375" y="172" fill="#ff0040" font-size="11" filter="url(#neon)">company_id   │ integer</text>
  <text x="375" y="200" fill="#ff0040" font-size="10" opacity="0.8" filter="url(#neon)">└─ FK → company.id</text>
  
  <!-- STACKOVERFLOW Table -->
  <rect x="680" y="90" width="300" height="260" rx="5" fill="rgba(255,0,64,0.05)" stroke="#ff0040" stroke-width="2" filter="url(#glow)"/>
  <text x="830" y="115" text-anchor="middle" fill="#ff0040" font-size="14" font-weight="bold" filter="url(#neon)">📊 stackoverflow</text>
  <line x1="695" y1="125" x2="965" y2="125" stroke="#ff0040" stroke-width="1" opacity="0.6"/>
  <text x="695" y="148" fill="#ff0040" font-size="11" filter="url(#neon)">id (PK)          │ serial</text>
  <text x="695" y="168" fill="#ff0040" font-size="11" filter="url(#neon)">tag (FK)         │ varchar(30)</text>
  <text x="695" y="188" fill="#ff0040" font-size="11" filter="url(#neon)">date             │ date</text>
  <text x="695" y="208" fill="#ff0040" font-size="11" filter="url(#neon)">question_count   │ integer</text>
  <text x="695" y="228" fill="#ff0040" font-size="11" filter="url(#neon)">question_pct     │ float</text>
  <text x="695" y="248" fill="#ff0040" font-size="11" filter="url(#neon)">unanswered_count │ integer</text>
  <text x="695" y="268" fill="#ff0040" font-size="11" filter="url(#neon)">unanswered_pct   │ float</text>
  <text x="695" y="295" fill="#ff0040" font-size="10" opacity="0.8" filter="url(#neon)">└─ FK → tag_company.tag</text>
  
  <!-- TAG_TYPE Table -->
  <rect x="680" y="400" width="300" height="130" rx="5" fill="rgba(255,0,64,0.05)" stroke="#ff0040" stroke-width="2" filter="url(#glow)"/>
  <text x="830" y="425" text-anchor="middle" fill="#ff0040" font-size="14" font-weight="bold" filter="url(#neon)">🏷️ tag_type</text>
  <line x1="695" y1="435" x2="965" y2="435" stroke="#ff0040" stroke-width="1" opacity="0.6"/>
  <text x="695" y="458" fill="#ff0040" font-size="11" filter="url(#neon)">id (PK)     │ serial</text>
  <text x="695" y="478" fill="#ff0040" font-size="11" filter="url(#neon)">tag (FK)    │ varchar(30)</text>
  <text x="695" y="498" fill="#ff0040" font-size="11" filter="url(#neon)">type        │ varchar(30)</text>
  <text x="695" y="518" fill="#ff0040" font-size="10" opacity="0.8" filter="url(#neon)">└─ FK → tag_company.tag</text>
  
  <!-- FORTUNE500 Table -->
  <rect x="40" y="580" width="320" height="270" rx="5" fill="rgba(255,0,64,0.05)" stroke="#ff0040" stroke-width="2" filter="url(#glow)"/>
  <text x="200" y="605" text-anchor="middle" fill="#ff0040" font-size="14" font-weight="bold" filter="url(#neon)">💰 fortune500</text>
  <line x1="55" y1="615" x2="345" y2="615" stroke="#ff0040" stroke-width="1" opacity="0.6"/>
  <text x="55" y="638" fill="#ff0040" font-size="11" filter="url(#neon)">rank (PK)      │ integer</text>
  <text x="55" y="656" fill="#ff0040" font-size="11" filter="url(#neon)">title (PK)     │ varchar</text>
  <text x="55" y="674" fill="#ff0040" font-size="11" filter="url(#neon)">name (UK)      │ varchar</text>
  <text x="55" y="692" fill="#ff0040" font-size="11" filter="url(#neon)">ticker         │ char(5)</text>
  <text x="55" y="710" fill="#ff0040" font-size="11" filter="url(#neon)">url            │ varchar</text>
  <text x="55" y="728" fill="#ff0040" font-size="11" filter="url(#neon)">hq             │ varchar</text>
  <text x="55" y="746" fill="#ff0040" font-size="11" filter="url(#neon)">sector         │ varchar</text>
  <text x="55" y="764" fill="#ff0040" font-size="11" filter="url(#neon)">industry       │ varchar</text>
  <text x="55" y="782" fill="#ff0040" font-size="11" filter="url(#neon)">employees      │ integer</text>
  <text x="55" y="800" fill="#ff0040" font-size="11" filter="url(#neon)">revenues       │ integer</text>
  <text x="55" y="818" fill="#ff0040" font-size="11" filter="url(#neon)">profits        │ numeric</text>
  <text x="55" y="836" fill="#ff0040" font-size="11" filter="url(#neon)">assets         │ numeric</text>
  
  <!-- EV311 Table -->
  <rect x="420" y="580" width="300" height="270" rx="5" fill="rgba(255,0,64,0.05)" stroke="#ff0040" stroke-width="2" filter="url(#glow)"/>
  <text x="570" y="605" text-anchor="middle" fill="#ff0040" font-size="14" font-weight="bold" filter="url(#neon)">🏙️ ev311</text>
  <line x1="435" y1="615" x2="705" y2="615" stroke="#ff0040" stroke-width="1" opacity="0.6"/>
  <text x="435" y="638" fill="#ff0040" font-size="11" filter="url(#neon)">id            │ integer</text>
  <text x="435" y="658" fill="#ff0040" font-size="11" filter="url(#neon)">priority      │ text</text>
  <text x="435" y="678" fill="#ff0040" font-size="11" filter="url(#neon)">source        │ text</text>
  <text x="435" y="698" fill="#ff0040" font-size="11" filter="url(#neon)">category      │ text</text>
  <text x="435" y="718" fill="#ff0040" font-size="11" filter="url(#neon)">date_created  │ timestamp</text>
  <text x="435" y="738" fill="#ff0040" font-size="11" filter="url(#neon)">date_completed│ timestamp</text>
  <text x="435" y="758" fill="#ff0040" font-size="11" filter="url(#neon)">street        │ text</text>
  <text x="435" y="778" fill="#ff0040" font-size="11" filter="url(#neon)">house_num     │ text</text>
  <text x="435" y="798" fill="#ff0040" font-size="11" filter="url(#neon)">zip           │ text</text>
  <text x="435" y="818" fill="#ff0040" font-size="11" filter="url(#neon)">description   │ text</text>
  
  <!-- CONNECTION ARROWS -->
  <!-- Company → Tag_company -->
  <line x1="290" y1="170" x2="355" y2="160" stroke="#ff0040" stroke-width="2" filter="url(#glow)"/>
  <polygon points="350,155 362,159 350,165" fill="#ff0040" filter="url(#glow)"/>
  <text x="305" y="155" fill="#ff0040" font-size="12" filter="url(#neon)">1</text>
  
  <!-- Tag_company → Stackoverflow -->
  <line x1="610" y1="160" x2="675" y2="190" stroke="#ff0040" stroke-width="2" filter="url(#glow)"/>
  <polygon points="670,185 682,192 670,199" fill="#ff0040" filter="url(#glow)"/>
  <text x="630" y="165" fill="#ff0040" font-size="12" filter="url(#neon)">1</text>
  
  <!-- Tag_company ↓ to Tag_type -->
  <line x1="485" y1="230" x2="485" y2="395" stroke="#ff0040" stroke-width="2" stroke-dasharray="6,4" filter="url(#glow)"/>
  <polygon points="480,390 485,402 490,390" fill="#ff0040" filter="url(#glow)"/>
  
  <!-- Self-reference arrow on company -->
  <path d="M 165 310 L 165 340 Q 165 355 180 355 L 240 355" stroke="#ff0040" stroke-width="2" fill="none" filter="url(#glow)"/>
  <polygon points="235,350 245,355 235,360" fill="#ff0040" filter="url(#glow)"/>
  <text x="248" y="352" fill="#ff0040" font-size="10" filter="url(#neon)">parent_id</text>
  
  <!-- Legend -->
  <rect x="40" y="860" width="920" height="30" rx="3" fill="none" stroke="#ff0040" stroke-width="1" opacity="0.5"/>
  <text x="55" y="880" fill="#ff0040" font-size="11" filter="url(#neon)">PK = Primary Key | FK = Foreign Key | UK = Unique Key | 1 = One-to-Many Relationship</text>
  
  <!-- Animated corner dots -->
  <circle cx="15" cy="15" r="3" fill="#ff0040" filter="url(#glow)">
    <animate attributeName="opacity" values="1;0.2;1" dur="1.5s" repeatCount="indefinite"/>
  </circle>
  <circle cx="1185" cy="15" r="3" fill="#ff0040" filter="url(#glow)">
    <animate attributeName="opacity" values="1;0.2;1" dur="1.5s" repeatCount="indefinite"/>
  </circle>
  <circle cx="15" cy="885" r="3" fill="#ff0040" filter="url(#glow)">
    <animate attributeName="opacity" values="1;0.2;1" dur="1.5s" repeatCount="indefinite"/>
  </circle>
  <circle cx="1185" cy="885" r="3" fill="#ff0040" filter="url(#glow)">
    <animate attributeName="opacity" values="1;0.2;1" dur="1.5s" repeatCount="indefinite"/>
  </circle>
</svg>

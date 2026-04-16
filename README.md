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
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 900" font-family="'Courier New', 'Fira Code', monospace">
  <defs>
    <!-- Neon glow filters -->
    <filter id="neonGlow" x="-50%" y="-50%" width="200%" height="200%">
      <feGaussianBlur in="SourceGraphic" stdDeviation="3" result="blur1"/>
      <feGaussianBlur in="SourceGraphic" stdDeviation="8" result="blur2"/>
      <feGaussianBlur in="SourceGraphic" stdDeviation="15" result="blur3"/>
      <feMerge>
        <feMergeNode in="blur3"/>
        <feMergeNode in="blur2"/>
        <feMergeNode in="blur1"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>

    <filter id="intenseGlow" x="-50%" y="-50%" width="200%" height="200%">
      <feGaussianBlur in="SourceGraphic" stdDeviation="2" result="blur1"/>
      <feGaussianBlur in="SourceGraphic" stdDeviation="6" result="blur2"/>
      <feGaussianBlur in="SourceGraphic" stdDeviation="12" result="blur3"/>
      <feGaussianBlur in="SourceGraphic" stdDeviation="20" result="blur4"/>
      <feMerge>
        <feMergeNode in="blur4"/>
        <feMergeNode in="blur3"/>
        <feMergeNode in="blur2"/>
        <feMergeNode in="blur1"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>

    <!-- Scanline effect -->
    <pattern id="scanlines" width="4" height="4" patternUnits="userSpaceOnUse">
      <line x1="0" y1="0" x2="4" y2="0" stroke="rgba(255,0,60,0.05)" stroke-width="1"/>
    </pattern>

    <!-- Gradient for boxes -->
    <linearGradient id="boxGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#FF073A;stop-opacity:0.15"/>
      <stop offset="100%" style="stop-color:#FF073A;stop-opacity:0.05"/>
    </linearGradient>

    <linearGradient id="lineGradient" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:#FF073A;stop-opacity:0"/>
      <stop offset="50%" style="stop-color:#FF073A;stop-opacity:1"/>
      <stop offset="100%" style="stop-color:#FF073A;stop-opacity:0"/>
    </linearGradient>
  </defs>

  <!-- Background -->
  <rect width="1200" height="900" fill="#0a0a0a"/>
  <rect width="1200" height="900" fill="url(#scanlines)"/>

  <!-- Title Bar -->
  <rect x="50" y="20" width="1100" height="50" rx="5" fill="none" stroke="#FF073A" stroke-width="2" filter="url(#neonGlow)"/>
  <rect x="50" y="20" width="1100" height="50" rx="5" fill="url(#boxGradient)"/>
  <text x="600" y="52" text-anchor="middle" fill="#FF073A" font-size="22" font-weight="bold" filter="url(#intenseGlow)" font-family="'Orbitron', 'Courier New', monospace">⚡ DEVELOPER ECOSYSTEM DATABASE ⚡</text>

  <!-- ============ COMPANY BOX ============ -->
  <rect x="50" y="100" width="220" height="200" rx="5" fill="none" stroke="#FF073A" stroke-width="2" filter="url(#neonGlow)"/>
  <rect x="50" y="100" width="220" height="200" rx="5" fill="url(#boxGradient)"/>
  <text x="160" y="125" text-anchor="middle" fill="#FF073A" font-size="16" font-weight="bold" filter="url(#neonGlow)">📁 company</text>
  <line x1="60" y1="135" x2="260" y2="135" stroke="#FF073A" stroke-width="1" opacity="0.5"/>
  <text x="60" y="155" fill="#FF073A" font-size="12" filter="url(#neonGlow)">id (PK)     │ integer</text>
  <text x="60" y="175" fill="#FF073A" font-size="12" filter="url(#neonGlow)">exchange    │ varchar</text>
  <text x="60" y="195" fill="#FF073A" font-size="12" filter="url(#neonGlow)">ticker (UK) │ char(5)</text>
  <text x="60" y="215" fill="#FF073A" font-size="12" filter="url(#neonGlow)">name        │ text</text>
  <text x="60" y="235" fill="#FF073A" font-size="12" filter="url(#neonGlow)">parent_id   │ integer</text>
  <text x="60" y="255" fill="#FF073A" font-size="11" opacity="0.8" filter="url(#neonGlow)">└─ self-ref to id</text>
  <text x="60" y="275" fill="#FF073A" font-size="11" opacity="0.8" filter="url(#neonGlow)│  └─ parent-child</text>
  <text x="60" y="290" fill="#FF073A" font-size="11" opacity="0.8" filter="url(#neonGlow">   └─ relationship</text>

  <!-- ============ TAG_COMPANY BOX ============ -->
  <rect x="380" y="100" width="220" height="120" rx="5" fill="none" stroke="#FF073A" stroke-width="2" filter="url(#neonGlow)"/>
  <rect x="380" y="100" width="220" height="120" rx="5" fill="url(#boxGradient)"/>
  <text x="490" y="125" text-anchor="middle" fill="#FF073A" font-size="15" font-weight="bold" filter="url(#neonGlow)">🔗 tag_company</text>
  <line x1="390" y1="135" x2="590" y2="135" stroke="#FF073A" stroke-width="1" opacity="0.5"/>
  <text x="390" y="155" fill="#FF073A" font-size="12" filter="url(#neonGlow)">tag (PK)     │ varchar(30)</text>
  <text x="390" y="180" fill="#FF073A" font-size="12" filter="url(#neonGlow)">company_id   │ integer</text>
  <text x="390" y="205" fill="#FF073A" font-size="11" opacity="0.8" filter="url(#neonGlow)│  └─ FK → company.id</text>

  <!-- ============ STACKOVERFLOW BOX ============ -->
  <rect x="710" y="100" width="280" height="230" rx="5" fill="none" stroke="#FF073A" stroke-width="2" filter="url(#neonGlow)"/>
  <rect x="710" y="100" width="280" height="230" rx="5" fill="url(#boxGradient)"/>
  <text x="850" y="125" text-anchor="middle" fill="#FF073A" font-size="15" font-weight="bold" filter="url(#neonGlow)">📊 stackoverflow</text>
  <line x1="720" y1="135" x2="980" y2="135" stroke="#FF073A" stroke-width="1" opacity="0.5"/>
  <text x="720" y="155" fill="#FF073A" font-size="12" filter="url(#neonGlow)">id (PK)       │ serial</text>
  <text x="720" y="175" fill="#FF073A" font-size="12" filter="url(#neonGlow)">tag (FK)      │ varchar(30)</text>
  <text x="720" y="195" fill="#FF073A" font-size="12" filter="url(#neonGlow)">date          │ date</text>
  <text x="720" y="215" fill="#FF073A" font-size="12" filter="url(#neonGlow)">question_count│ integer</text>
  <text x="720" y="235" fill="#FF073A" font-size="12" filter="url(#neonGlow)">question_pct  │ float</text>
  <text x="720" y="255" fill="#FF073A" font-size="12" filter="url(#neonGlow)">unanswered_cnt│ integer</text>
  <text x="720" y="275" fill="#FF073A" font-size="12" filter="url(#neonGlow)">unanswered_pct│ float</text>
  <text x="720" y="300" fill="#FF073A" font-size="11" opacity="0.8" filter="url(#neonGlow)│  └─ FK → tag_company.tag</text>

  <!-- ============ TAG_TYPE BOX ============ -->
  <rect x="710" y="380" width="280" height="120" rx="5" fill="none" stroke="#FF073A" stroke-width="2" filter="url(#neonGlow)"/>
  <rect x="710" y="380" width="280" height="120" rx="5" fill="url(#boxGradient)"/>
  <text x="850" y="405" text-anchor="middle" fill="#FF073A" font-size="15" font-weight="bold" filter="url(#neonGlow)">🏷️ tag_type</text>
  <line x1="720" y1="415" x2="980" y2="415" stroke="#FF073A" stroke-width="1" opacity="0.5"/>
  <text x="720" y="435" fill="#FF073A" font-size="12" filter="url(#neonGlow)">id (PK)       │ serial</text>
  <text x="720" y="455" fill="#FF073A" font-size="12" filter="url(#neonGlow)">tag (FK)      │ varchar(30)</text>
  <text x="720" y="475" fill="#FF073A" font-size="12" filter="url(#neonGlow)">type          │ varchar(30)</text>
  <text x="720" y="490" fill="#FF073A" font-size="11" opacity="0.8" filter="url(#neonGlow)│  └─ FK → tag_company.tag</text>

  <!-- ============ FORTUNE500 BOX ============ -->
  <rect x="50" y="560" width="280" height="280" rx="5" fill="none" stroke="#FF073A" stroke-width="2" filter="url(#neonGlow)"/>
  <rect x="50" y="560" width="280" height="280" rx="5" fill="url(#boxGradient)"/>
  <text x="190" y="585" text-anchor="middle" fill="#FF073A" font-size="15" font-weight="bold" filter="url(#neonGlow)">💰 fortune500</text>
  <line x1="60" y1="595" x2="320" y2="595" stroke="#FF073A" stroke-width="1" opacity="0.5"/>
  <text x="60" y="615" fill="#FF073A" font-size="11" filter="url(#neonGlow)">rank (PK)     │ integer</text>
  <text x="60" y="633" fill="#FF073A" font-size="11" filter="url(#neonGlow)">title (PK)    │ varchar</text>
  <text x="60" y="651" fill="#FF073A" font-size="11" filter="url(#neonGlow)">name (UK)     │ varchar</text>
  <text x="60" y="669" fill="#FF073A" font-size="11" filter="url(#neonGlow)">ticker        │ char(5)</text>
  <text x="60" y="687" fill="#FF073A" font-size="11" filter="url(#neonGlow)">url           │ varchar</text>
  <text x="60" y="705" fill="#FF073A" font-size="11" filter="url(#neonGlow)">hq            │ varchar</text>
  <text x="60" y="723" fill="#FF073A" font-size="11" filter="url(#neonGlow)">sector        │ varchar</text>
  <text x="60" y="741" fill="#FF073A" font-size="11" filter="url(#neonGlow)">industry      │ varchar</text>
  <text x="60" y="759" fill="#FF073A" font-size="11" filter="url(#neonGlow)">employees     │ integer</text>
  <text x="60" y="777" fill="#FF073A" font-size="11" filter="url(#neonGlow)">revenues      │ integer</text>
  <text x="60" y="795" fill="#FF073A" font-size="11" filter="url(#neonGlow)">profits       │ numeric</text>
  <text x="60" y="813" fill="#FF073A" font-size="11" filter="url(#neonGlow)">assets        │ numeric</text>
  <text x="60" y="828" fill="#FF073A" font-size="11" opacity="0.8" filter="url(#neonGlow)│  └─ independent table</text>

  <!-- ============ EV311 BOX ============ -->
  <rect x="380" y="560" width="280" height="280" rx="5" fill="none" stroke="#FF073A" stroke-width="2" filter="url(#neonGlow)"/>
  <rect x="380" y="560" width="280" height="280" rx="5" fill="url(#boxGradient)"/>
  <text x="520" y="585" text-anchor="middle" fill="#FF073A" font-size="15" font-weight="bold" filter="url(#neonGlow)">🏙️ ev311</text>
  <line x1="390" y1="595" x2="650" y2="595" stroke="#FF073A" stroke-width="1" opacity="0.5"/>
  <text x="390" y="615" fill="#FF073A" font-size="11" filter="url(#neonGlow)">id            │ integer</text>
  <text x="390" y="633" fill="#FF073A" font-size="11" filter="url(#neonGlow)">priority      │ text</text>
  <text x="390" y="651" fill="#FF073A" font-size="11" filter="url(#neonGlow)">source        │ text</text>
  <text x="390" y="669" fill="#FF073A" font-size="11" filter="url(#neonGlow)">category      │ text</text>
  <text x="390" y="687" fill="#FF073A" font-size="11" filter="url(#neonGlow)">date_created  │ timestamp</text>
  <text x="390" y="705" fill="#FF073A" font-size="11" filter="url(#neonGlow)">date_completed│ timestamp</text>
  <text x="390" y="723" fill="#FF073A" font-size="11" filter="url(#neonGlow)">street        │ text</text>
  <text x="390" y="741" fill="#FF073A" font-size="11" filter="url(#neonGlow)">house_num     │ text</text>
  <text x="390" y="759" fill="#FF073A" font-size="11" filter="url(#neonGlow)">zip           │ text</text>
  <text x="390" y="777" fill="#FF073A" font-size="11" filter="url(#neonGlow)">description   │ text</text>
  <text x="390" y="800" fill="#FF073A" font-size="11" opacity="0.8" filter="url(#neonGlow)│  └─ independent table</text>

  <!-- ============ CONNECTION LINES ============ -->
  
  <!-- Company to Tag_company (one-to-many) -->
  <line x1="270" y1="170" x2="380" y2="155" stroke="#FF073A" stroke-width="3" filter="url(#neonGlow)"/>
  <polygon points="375,150 385,155 375,160" fill="#FF073A" filter="url(#neonGlow)"/>
  <text x="310" y="150" fill="#FF073A" font-size="11" filter="url(#neonGlow)">1</text>
  <text x="340" y="140" fill="#FF073A" font-size="11" filter="url(#neonGlow)">────<</text>

  <!-- Tag_company to Stackoverflow (one-to-many) -->
  <line x1="600" y1="170" x2="710" y2="200" stroke="#FF073A" stroke-width="3" filter="url(#neonGlow)"/>
  <polygon points="705,195 710,205 715,195" fill="#FF073A" filter="url(#neonGlow)"/>
  <text x="640" y="175" fill="#FF073A" font-size="11" filter="url(#neonGlow)">1</text>
  <text x="660" y="190" fill="#FF073A" font-size="11" filter="url(#neonGlow)">>────</text>

  <!-- Tag_company vertical line down -->
  <line x1="490" y1="220" x2="490" y2="380" stroke="#FF073A" stroke-width="2" filter="url(#neonGlow)" stroke-dasharray="8,4"/>
  
  <!-- Tag_company to Tag_type -->
  <line x1="490" y1="380" x2="710" y2="440" stroke="#FF073A" stroke-width="3" filter="url(#neonGlow)"/>
  <polygon points="705,435 710,445 715,435" fill="#FF073A" filter="url(#neonGlow)"/>
  <text x="580" y="420" fill="#FF073A" font-size="11" filter="url(#neonGlow)">────></text>

  <!-- Parent-child self-reference arrow on company -->
  <path d="M 160 300 L 160 330 Q 160 350 180 350 L 220 350" stroke="#FF073A" stroke-width="2" fill="none" filter="url(#neonGlow)"/>
  <polygon points="215,345 225,350 215,355" fill="#FF073A" filter="url(#neonGlow)"/>
  <text x="230" y="345" fill="#FF073A" font-size="10" filter="url(#neonGlow)">parent_id</text>

  <!-- ============ LEGEND ============ -->
  <rect x="50" y="850" width="900" height="40" rx="3" fill="none" stroke="#FF073A" stroke-width="1" opacity="0.5"/>
  <text x="70" y="875" fill="#FF073A" font-size="11" filter="url(#neonGlow)">PK = Primary Key | FK = Foreign Key | UK = Unique Key | * = Self-Reference | ⚡ = Red Neon Theme</text>

  <!-- Decorative corner brackets -->
  <path d="M 10 10 L 35 10 M 10 10 L 10 35" stroke="#FF073A" stroke-width="2" fill="none" filter="url(#neonGlow)"/>
  <path d="M 1190 10 L 1165 10 M 1190 10 L 1190 35" stroke="#FF073A" stroke-width="2" fill="none" filter="url(#neonGlow)"/>
  <path d="M 10 890 L 35 890 M 10 890 L 10 865" stroke="#FF073A" stroke-width="2" fill="none" filter="url(#neonGlow)"/>
  <path d="M 1190 890 L 1165 890 M 1190 890 L 1190 865" stroke="#FF073A" stroke-width="2" fill="none" filter="url(#neonGlow)"/>

  <!-- Pulsing dot animation -->
  <circle cx="600" cy="50" r="4" fill="#FF073A" filter="url(#intenseGlow)">
    <animate attributeName="opacity" values="1;0.2;1" dur="1.5s" repeatCount="indefinite"/>
  </circle>
</svg>
│ equity      │
└─────────────┘

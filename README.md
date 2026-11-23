# Barangay Lupi Community Health Information Management System (CHIMS)

A web app for the health center of Barangay Lupi, Tinambac, Camarines Sur. Health workers use it to keep resident records, consultations, and medicine stock. Residents can see the health center's information, announcements, programs, and which medicines are in stock.

**Course:** Web Systems and Technologies (WS1), BSIT, College of Engineering and Computational Sciences, Partido State University
**Members:**  Cada, Ruth Angella and Pendon, Ma Maya

---

## Project status

| Part | Status |
|------|--------|
| Database (12 tables, sample data) | Done |
| Week 14 design package (brief, CRUD map, sitemap, wireframes, style guide) | In `docs/` |
| Week 14 static pages (`prototype/`) | Done |
| PHP + MySQL app, phase 1 (login, dashboard, residents, public home page) | Planned | 
| Phases 2 and 3 (senior citizens, consultations, medicines, batches, distribution, inventory, announcements, programs, health center info, users) | Planned |

---

## Features

**Public page (no login)**
- Health center name, address, contact number, opening hours, and services
- Current announcements and upcoming programs
- Medicines in stock (Available, Low stock, or Out of stock), with no resident data

**Staff area (login required)**
- Dashboard with counts for residents, seniors, consultations, low-stock medicines, and programs
- Residents: search, filter by purok and status, add, edit, deactivate and reactivate
- Two roles: **admin** and **staff** (admins will also manage users)

Residents are never deleted. They are set to inactive, because consultations and medicine records refer to them.

---

## Tech stack

- HTML and CSS 
- Laragon for local development (MySQL)

---

## Database

Database name: `barangay_lupi_chims`

| Table | Purpose |
|-------|---------|
| `app_user` | Staff accounts (with `role`: admin or staff) |
| `resident` | Residents of the barangay |
| `senior_citizen` | Senior citizen record for a resident |
| `health_consultation` | Consultations recorded for a resident |
| `health_program` | Health programs and events |
| `announcement` | Public announcements |
| `health_center_info` | Health center details |
| `medicine` | Medicine catalog |
| `medicine_batch` | Stock batches with expiry and quantity |
| `medicine_distribution` | Medicine given to a resident |
| `prescription_verification` | Prescription check for a distribution |
| `inventory_transaction` | Stock in and stock out history |

**Schema change:** added `app_user.role` (`ENUM('admin','staff')`, default `staff`) so admins and staff can have different access.

---

## Folder structure


chims/
├── README.md
├── database/
│   ├── schema.sql          CREATE TABLE statements
│   └── seed.sql            sample data (fictional)
├── docs/
│   ├── 01-brief.md
│   ├── 02-crud-map.md
│   ├── 03-sitemap.png      plus user-flow.png
│   ├── 04-wireframes/
│   └── 05-style-guide.md
├── prototype/              static HTML and CSS pages (Week 14)
│   ├── css/style.css
│   ├── list.html
│   └── form.html

---

### Viewing the static prototype

Open the `prototype/` folder in VS Code and run `list.html` with the Live Server extension. No PHP or database is needed.

---

## Design

- Friendly, rounded look with a left sidebar menu
- Colors: ocean blue `#0b6e99`, sunshine yellow `#ffc94a`, background `#eef6fb`, text `#17324a`
- Fonts: Fredoka (headings) and Nunito (body)
- Resident list shows cards that stack into one column on a phone

---

## Roadmap

1. **Phase 2:** senior citizens, consultations, resident detail page, medicines, batches, distribution with prescription check and automatic stock-out entries, inventory history
2. **Phase 3:** announcements, programs, health center info, user management (admin only)
3. **Later:** testing, bug fixes, and a security review

---

## AI assistance

Claude (Anthropic) helped draft the wireframes, static pages. Both members reviewed, tested, and changed the output. 
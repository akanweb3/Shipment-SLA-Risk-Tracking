# Shipment SLA Risk Tracking System

An automated end-to-end logistics monitoring pipeline that detects 
delivery SLA breaches before they happen.

## Problem
Logistics companies, e-commerce brands, manufacturers and retailers 
move thousands of shipments daily with no automated system watching 
for delivery failures in real time. Problems are discovered only after 
customers complain or SLA penalties land.

## Solution
An automated early warning system that:
- Monitors every active shipment every 6 hours
- Calculates a risk score per shipment based on days in transit 
  and proximity to delivery deadline
- Sends proactive email alerts for High Risk and Breached shipments
- Logs every alert to prevent duplicate notifications
- Surfaces live insights on an interactive Tableau dashboard

## Tech Stack
| Tool | Role |
|------|------|
| PostgreSQL (Supabase) | Data storage — 4 tables |
| n8n | Workflow automation — 8 nodes |
| Gmail | Email alerting |
| Tableau Public | Live dashboard |

## System Architecture 
Scheduler → Fetch Shipments → Calculate Risk Scores
→ Write to Database
→ Filter High Risk & Breached
→ Check Duplicate Alert
→ Send Email Alert
→ Log Alert

## Risk Scoring Logic
| Condition | Score | Level |
|-----------|-------|-------|
| Past promised delivery date | 100 | Breached |
| 1 day until deadline | 90 | High |
| In transit longer than standard days | 75 | High |
| 2–3 days until deadline | 50 | Medium |
| All other active shipments | 20 | Low |

## Dashboard
Live Tableau dashboard:
https://public.tableau.com/app/profile/jacob.oliver6699/viz/ShipmentSLARiskDashboard/ShipmentSLARiskDashboard

## Key Results
- 15 of 20 active shipments flagged on first run (75% at-risk rate)
- 5 already breached, 10 approaching deadline
- DHL Nigeria identified as highest-risk carrier
- Lagos → Abuja identified as highest-risk route
- 15 automated email alerts dispatched within seconds

## Medium Article
Full project writeup:
[How I Built an Automated Logistics Early Warning System]
[(your Medium article link here)](https://medium.com/@info.jacoboliver/how-i-built-an-automated-logistics-early-warning-system-that-monitors-shipment-risk-in-real-time-458c1c89ae65?postPublishedType=repub)

## Files
- `database_setup.sql` — All table creation, seed data, and view queries


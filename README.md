# Data_Pipeline_Neostats

# Virtual Server Monitoring & Performance Optimization – NeoStats Case Study

An end-to-end data engineering & visualization solution to ingest, process, secure, and monitor virtual server performance logs.

## Project Overview

**Objective**  
Build a data pipeline that ingests server performance logs from a CSV file, applies transformations and business logic, handles sensitive PII securely, and delivers interactive visualizations in Power BI to help identify resource bottlenecks, performance issues, and ensure high availability.

**Key Features**
- Efficient CSV ingestion with schema enforcement
- Data quality checks (NULL detection)
- Strong PII protection (SHA-256 hashing + masking)
- Business enrichment: Performance Status categorization (Healthy / Warning / Critical)
- Multi-page interactive Power BI dashboard with KPIs, trends, and drill-down filters

## Solution Architecture
Raw CSV
↓
Ingestion → Local MySQL (staging table + timestamp parsing)
↓
Processing → Aggregations & business logic
↓
Security Layer → GOLD View (hashed/masked fields)
↓
Visualization → Power BI Desktop (MySQL connector)

**Note on Cloud**  
Due to lack of Azure account, the pipeline uses a local MySQL server.  
In production, this would migrate to:  
- Azure SQL Database (managed relational storage)  
- or Azure Data Lake Gen2 + Azure Data Factory/Synapse for orchestration  
The SQL logic and Power BI visuals are fully portable.

## Dataset

- **File**: `Sample_Data_Ingestion.csv`  
- **Rows**: 200  
- **Columns**: 16 (Server_ID, Hostname, IP_Address, OS_Type, Server_Location, CPU_Utilization, Memory_Usage, Disk_IO, Network_Traffic_In/Out, Uptime_Hours, Downtime_Hours, Admin_Name/Email/Phone, Log_Timestamp)  
- **Time format**: DD-MM-YYYY HH:MM (converted to DATETIME during load)

Detailed column descriptions → see `NEOSTATS_DOCUMENTATION.docx`

## Technical Stack

- **Database**: MySQL (local server)  
- **Data Processing**: SQL (DDL, DML, Views, Aggregations)  
- **Visualization**: Power BI Desktop  
- **Connector**: MySQL Connector for Power BI

## How to Reproduce

1. **Prerequisites**
   - MySQL Server (local installation)
   - Power BI Desktop
   - Sample_Data_Ingestion.csv in your working directory

2. **Database Setup**
   ```sql
   CREATE DATABASE server_monitoring;
   USE server_monitoring;

   Create & Load Table
Run the CREATE TABLE server_monitoring_1 and LOAD DATA LOCAL INFILE statements from NEOSTATS_DOCUMENTATION.docx
(Adjust file path as needed)
Run Processing & Security View
Execute the remaining SQL queries (processed table, aggregations, v_secure_server_metrics view)
Power BI
Open Power BI Desktop
Get Data → MySQL database → localhost / server_monitoring
Use view v_secure_server_metrics as primary source
Build visuals as described in documentation


Dashboard Pages

Executive Summary
KPIs: Avg CPU, Avg Memory, Total Servers
Donut: Performance Distribution (Healthy/Warning/Critical)
Bar: CPU by Region

Reliability & Traffic
Stacked Bar: Uptime vs Downtime per Server
Dual Line: Network In/Out trends

Deep Dive
Horizontal Bar: Top Disk I/O servers
Scatter: CPU vs Memory correlation
Slicers: OS_Type, Server_Location, Performance_Status


Security & Privacy

Hostname & IP_Address → SHA-256 hashed (irreversible pseudonymization)
Admin_Name → Initial + Last name
Admin_Email → First letter + **** + domain
Admin_Phone → XXXXXX + last 4 digits
All sensitive transformations happen in a read-only VIEW — raw data remains untouched.

Challenges & Decisions

No Azure access → Used local MySQL + documented migration path
Small sample dataset → Focused on per-server & per-location aggregations
Privacy priority → Implemented hashing + masking beyond basic requirements

Documentation
Full details (SQL code, preprocessing steps, column descriptions, dashboard layout):
→ NEOSTATS_DOCUMENTATION.docx
Presentation
Brief PowerPoint overview available (approach, architecture, dashboard screenshots, challenges).

License
Personal / educational use only (NeoStats case study submission).
Created by Rohith | March 2025–2026

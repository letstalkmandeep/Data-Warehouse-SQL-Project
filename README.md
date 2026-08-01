<h1 align="center">🏗️ End-to-End Data Warehouse using PostgreSQL</h1>

<p align="center">
A modern Data Warehouse solution built with PostgreSQL that integrates CRM and ERP data into a layered architecture (Bronze, Silver, and Gold) using ETL pipelines, data quality validation, and dimensional modeling to deliver clean, analytics-ready data.
</p>

<p align="center">

<img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white"/>

<img src="https://img.shields.io/badge/SQL-Structured%20Query%20Language-blue?style=for-the-badge"/>

<img src="https://img.shields.io/badge/Data%20Warehouse-Bronze%20%7C%20Silver%20%7C%20Gold-orange?style=for-the-badge"/>

<img src="https://img.shields.io/badge/ETL-Stored%20Procedures-success?style=for-the-badge"/>

<img src="https://img.shields.io/badge/Data%20Model-Star%20Schema-yellow?style=for-the-badge"/>

<img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge"/>

</p>

---

# 📖 Project Overview

In modern organizations, there is always a challenge when trying to analyze data from various sources since the data may have inconsistency in formatting, duplicates, and poor data quality.

In this project, we create a Data Warehouse with PostgreSQL as a database technology, based on the industry standard Medallion Architecture (Bronze → Silver → Gold).

For this project, we combine data from two sources in one Data Warehouse with the help of ETL process implemented via Stored Procedures. We load raw data into the Bronze layer, transform and clean up data in the Silver layer, and model it into business-friendly data views in the Gold layer in the form of Star Schema including Fact and Dimension tables.

This project focuses on creating clear architecture, data validation, reusing SQL development efforts, and designing an effective Data Warehouse.

---

<p align="center">
    <img src="docs/data_architecture.png" width="950">
</p>

## 🎯 Project Objectives

- Build a modern Data Warehouse using PostgreSQL.
- Integrate CRM and ERP datasets into a unified repository.
- Implement a layered Medallion Architecture (Bronze, Silver, Gold).
- Develop automated ETL pipelines using Stored Procedures.
- Perform data cleansing, validation, and standardization.
- Design a Star Schema with Fact and Dimension tables.
- Deliver business-ready datasets optimized for analytical workloads.

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| PostgreSQL | Database Management System |
| SQL | Data Definition & Query Language |
| Stored Procedures | ETL Automation |
| Data Warehousing | Layered Warehouse Architecture |
| Star Schema | Dimensional Data Modeling |
| Git & GitHub | Version Control |

---

---

# 🏛️ Data Warehouse Architecture

The project follows a **Modern Medallion Architecture** that transforms raw CRM and ERP datasets into trusted, analytics-ready data through three distinct layers: **Bronze**, **Silver**, and **Gold**.

Each layer has a specific responsibility to ensure data quality, scalability, and maintainability.

<p align="center">
    <img src="docs/data-architecture.png" alt="Data Warehouse Architecture" width="950"/>
</p>

### Architecture Layers

| Layer | Purpose |
|-------|---------|
| 🥉 Bronze | Stores raw data ingested directly from CRM and ERP source systems without modification. |
| 🥈 Silver | Cleanses, standardizes, validates, and transforms raw data into consistent datasets. |
| 🥇 Gold | Creates business-ready dimensional models using Fact and Dimension tables for analytical workloads. |

### Key Design Principles

- Layered Medallion Architecture
- Separation of Raw and Business Data
- Automated ETL using Stored Procedures
- Data Quality Validation
- Star Schema Data Modeling
- Modular and Scalable Design

---

# 🔄 Data Flow

The ETL pipeline integrates multiple operational systems into a centralized Data Warehouse following a structured transformation process.

<p align="center">
    <img src="docs/data-flow.png" alt="Data Flow" width="900"/>
</p>

### ETL Workflow

```text
CRM & ERP Source Data
          │
          ▼
   Stored Procedure ETL
          │
          ▼
   Bronze Layer (Raw Data)
          │
          ▼
Silver Layer (Clean & Standardized)
          │
          ▼
Gold Layer (Star Schema)
          │
          ▼
Business Ready Data
```

### Data Processing Pipeline

- Extract data from CRM and ERP source systems.
- Load raw data into the Bronze layer.
- Perform data cleansing, validation, and transformation in the Silver layer.
- Build Fact and Dimension tables in the Gold layer.
- Deliver trusted datasets for Business Intelligence and Data Analytics.

---

# 📂 Repository Structure

```text
Data-Warehouse-SQL-Project/
│
├── datasets/
│   ├── source_crm/
│   └── source_erp/
│
├── docs/
│   ├── data-architecture.png
│   ├── data-flow.png
│   └── *.drawio
│
├── scripts/
│   │
│   ├── bronze/
│   │   ├── ddl_bronze.sql
│   │   ├── proc_load_bronze.sql
│   │   └── bronze_quality_checks.sql
│   │
│   ├── silver/
│   │   ├── ddl_silver.sql
│   │   ├── proc_load_silver.sql
│   │   └── silver_quality_checks.sql
│   │
│   ├── gold/
│   │   ├── ddl_gold.sql
│   │   ├── dim_customers.sql
│   │   ├── dim_products.sql
│   │   ├── fact_sales.sql
│   │   └── create_views.sql
│   │
│   └── init_database.sql
│
├── LICENSE
└── README.md
```

### Repository Overview

| Folder | Description |
|---------|-------------|
| **datasets/** | Contains CRM and ERP source datasets used for building the warehouse. |
| **docs/** | Project documentation, architecture diagrams, and data flow illustrations. |
| **scripts/bronze/** | SQL scripts for creating Bronze tables and loading raw source data. |
| **scripts/silver/** | SQL scripts for cleansing, validating, and transforming Bronze data. |
| **scripts/gold/** | SQL scripts for creating Fact tables, Dimension tables, and analytical views. |
| **init_database.sql** | Initializes the database, schemas, and project setup. |
| **README.md** | Complete project documentation. |

---

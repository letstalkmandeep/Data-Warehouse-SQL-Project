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

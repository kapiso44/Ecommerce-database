# DomSprzedazyWysylkowej — SQL Server E-commerce Database

Relational SQL Server project for a mail-order/e-commerce domain (`DomSprzedazyWysylkowej`).
The repository contains complete database setup scripts, demo scripts for cascade behavior, and example operationalqueries.

## Repository structure

```text
.
├── assets/
│   └── erd/
│       └── dom_sprzedazy_wysylkowej_erd.png
├── docs/
│   └── legacy/
│       ├── Kacper_L_project_notes.docx
│       └── Kacper_project_notes.pdf
├── sql/
│   ├── demos/
│   │   ├── 03_cascade_update_status_pk_demo.sql
│   │   └── 04_cascade_delete_client_demo.sql
│   ├── queries/
│   │   ├── monthly_sales_for_product.sql
│   │   ├── order_status_by_order_id.sql
│   │   ├── orders_without_payment.sql
│   │   ├── out_of_stock_products_in_open_orders.sql
│   │   ├── payment_details_by_payment_id.sql
│   │   └── update_producer_website_by_id.sql
│   └── setup/
│       ├── 00_create_database.sql
│       ├── 01_create_tables.sql
│       ├── 02_insert_data.sql
│       └── 99_drop_all.sql
└── README.md
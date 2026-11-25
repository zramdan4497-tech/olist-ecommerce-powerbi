# Data Model - Olist E-Commerce Analytics

Star schema: one central fact table (order items) surrounded by dimension tables,
plus two satellite fact tables at the order grain (payments, reviews).

## Tables

| Table | Grain | Rows | Role |
|---|---|---|---|
| fct_order_items | order_id + order_item_id | 112,650 | Fact (sales) |
| fct_orders | order_id | 99,441 | Fact (order header) |
| fct_payments | order_id | 99,437 | Fact (payments) |
| fct_reviews | order_id | 98,140 | Fact (reviews) |
| dim_customers | customer_id | 99,441 | Dimension |
| dim_sellers | seller_id | 3,095 | Dimension |
| dim_products | product_id | 32,951 | Dimension |
| dim_date | date | 852 | Dimension (calendar) |

## Relationships (Model view)

| From (many side) | To (one side) | Key | Cardinality | Cross-filter |
|---|---|---|---|---|
| fct_order_items | fct_orders | order_id | Many-to-one | Single |
| fct_order_items | dim_products | product_id | Many-to-one | Single |
| fct_order_items | dim_sellers | seller_id | Many-to-one | Single |
| fct_orders | dim_customers | customer_id | Many-to-one | Single |
| fct_orders | dim_date | order_purchase_date -> date | Many-to-one | Single |
| fct_payments | fct_orders | order_id | One-to-one | Single |
| fct_reviews | fct_orders | order_id | One-to-one | Single |

fct_orders has a second date relationship to dim_date on order_delivered_date:
create it and leave it INACTIVE; activate it inside measures with USERELATIONSHIP
(see Delivery Days Delivered in measures.dax).

## Notes
- Mark dim_date as a Date table (Modeling > Mark as date table) so time-intelligence
  functions (DATEADD, PREVIOUSMONTH) work.
- Hide raw key columns (all *_id fields) from Report view.
- Sort dim_date[month_name] by dim_date[month]; sort day_of_week by day number if added.
- 4 orders have no payment rows and 1,301 orders have no review: inner-join visuals
  just exclude them; that is real data, not an error.

```
dim_customers        dim_date          dim_products
      |                   |                   |
      | 1:*               | 1:*               | 1:*
      v                   v                   v
fct_orders <------* fct_order_items *------> dim_sellers
      ^ 1:1                (grain: order line)
      |
fct_payments, fct_reviews
```

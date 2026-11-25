# Dashboard Spec - Olist E-Commerce Analytics (5 pages)

Theme: dark header band, white canvas. Suggested accent: #118DFF (Power BI blue),
secondary #E66C37 (orange) for warnings/late metrics, green #2CA02C for on-time.
Use the same KPI card style on every page: big number, small label, MoM delta under it.

## Page 1 - Overview
Purpose: the 30-second summary of the business.
- KPI cards (top row): Total Revenue (R$ 13.6M), Total Orders (99.4K), Avg Order Value (R$ 136.7), Avg Review Score (4.09), On-Time Delivery % (91.9%)
- Line chart: Total Revenue by dim_date[year_month] (X) - shows the 2017-11 peak (R$ 1.01M, Black Friday)
- Column chart: Total Orders by year_month
- Bar chart: Total Revenue by dim_products[product_category_english], top 10
- Map (filled map): Total Revenue by dim_customers[customer_state]
- Donut: Total Paid by fct_payments[payment_type_main]
- Slicers: Year, Quarter, customer_state

## Page 2 - Sales & Products
Purpose: what sells, and what makes money.
- Matrix: product_category_english rows; Total Revenue, Items Sold, Avg Item Price, Revenue MoM %
- Bar chart: top 10 categories by Total Revenue (health_beauty R$ 1.26M, watches_gifts R$ 1.21M, bed_bath_table R$ 1.04M, sports_leisure R$ 0.99M, computers_accessories R$ 0.91M)
- Scatter: Avg Item Price (X) vs Items Sold (Y), bubble = Total Revenue, detail = category - shows high-price/low-volume niches
- Line + column combo: Total Revenue (columns) and Orders MoM % (line) by year_month
- Treemap: Total Revenue by customer_state then category
- Slicers: Year, category

## Page 3 - Customers & Geography
Purpose: who buys and where they live.
- Filled map: Total Revenue by customer_state (SP R$ 5.2M, RJ R$ 1.8M, MG R$ 1.6M lead)
- KPI cards: Total Customers (96,096), Repeat Customer Rate (3.1%), Revenue per Customer, Orders per Customer
- Bar: Total Customers by customer_state, top 15
- Line: distinct customers by year_month (new demand trend)
- Table: top 20 cities by revenue (city, state, customers, revenue, AOV)
- Callout text: repeat rate is low (3.1%) - Olist is mostly one-time purchases; use it as an insight

## Page 4 - Delivery Performance
Purpose: logistics quality and where it breaks.
- KPI cards: Avg Delivery Days (12.1), Avg Estimated Days (23.4), On-Time Delivery % (91.9%), Late Deliveries
- Line: Avg Delivery Days by year_month - is delivery getting faster?
- Bar: On-Time Delivery % by customer_state - find the states hurting the average
- Scatter: Avg Delivery Days (X) vs Avg Review Score (Y), detail = customer_state - proves slow delivery drags reviews
- Histogram (column): delivery_days distribution (bin by 5 days)
- Slicers: Year, customer_state

## Page 5 - Reviews & Satisfaction
Purpose: the voice of the customer.
- KPI cards: Avg Review Score (4.09), 5-Star Share (57.8%), Negative Review Share (14.6%), Reviews (98,140)
- Column: review count by review_score (1-5)
- Bar: Avg Review Score by product_category_english, bottom 10 - worst-rated categories
- Line: Avg Review Score by year_month
- Scatter: Avg Delivery Days (X) vs Avg Review Score (Y), detail = category
- Card: avg score for late deliveries vs on-time (use a measure pair) - the money shot: on-time 4.3 vs late 2.6

## Interactions & polish
- Turn on cross-filtering between map and charts on every page.
- Add a report-level filter: order_status <> "unavailable" only if the instructor prefers revenue over cancellations - default: keep all statuses.
- Tooltips: add AOV, On-Time %, Avg Review Score to chart tooltips.
- Format currency as R$ #,##0 and percentages with 1 decimal.

# Build Guide - from zero to finished .pbix (about 1 hour)

## 0. What you need
- Power BI Desktop (free): download from https://powerbi.microsoft.com/desktop
- The 8 raw CSV files (in the `data-raw` folder shared with you, or from Kaggle:
  https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## 1. Folder setup (5 min)
1. Create `olist-final-project` on your Desktop.
2. Inside it, create `data` and copy the 8 raw CSVs into it.

## 2. Power Query: load and clean (20 min)
For EACH of the 9 files in the `powerquery` folder of this package:
1. Open Power BI Desktop > Get Data > Blank query > Advanced Editor.
2. First create the parameter: Home > Manage Parameters > New > Name: `DataFolder`,
   Type: Text, Current Value: your data folder path (from step 1, ending with `\`).
3. For each `.pq` file: paste its content into a new Blank Query's Advanced Editor,
   name the query exactly like the file (dim_customers, dim_sellers, dim_products,
   dim_date, fct_orders, fct_order_items, fct_payments, fct_reviews).
4. Right-click each query > make sure "Enable load" is checked for all 8 tables.
5. Home > Close & Apply. Expected row counts after load (check in Data view):
   - dim_customers 99,441 | dim_sellers 3,095 | dim_products 32,951 | dim_date 852
   - fct_orders 99,441 | fct_order_items 112,650 | fct_payments 99,437 | fct_reviews 98,140

If a row count is off, the most common cause is a wrong DataFolder path or a
half-downloaded CSV. Re-download that file and refresh.

## 3. Data model (10 min)
1. Open Model view. Power BI may auto-detect some relationships; verify against
   `data-model/MODEL.md` and create the 7 relationships listed there.
2. Create the second, INACTIVE relationship fct_orders[order_delivered_date] -> dim_date[date].
3. Select dim_date > Modeling > Mark as date table > choose the `date` column.
4. Right-click every *_id column > Hide in report view.
5. In dim_date: select month_name > Sort by column > month.

## 4. DAX measures (10 min)
1. Home > Enter Data > Create > name the table `_Measures`.
2. Open `dax/measures.dax`, create each measure (right-click _Measures > New Measure),
   paste the formula. The comments hold the expected value of each measure -
   check a few in a card visual as you go (Total Revenue R$ 13.59M, Orders 99,441,
   On-Time 91.9%). Matching numbers = your model is correct.

## 5. Build the 5 pages (15-20 min)
Follow `dashboard/DASHBOARD_SPEC.md` page by page. Name the pages:
Overview, Sales & Products, Customers & Geography, Delivery, Reviews.

## 6. Polish and save
1. View > Themes > pick a clean one (or keep default with the spec's accent colors).
2. File > Save As > `Olist_Ecommerce_Analytics.pbix`.
3. Take screenshots: one full screenshot per page (Win+Shift+S), plus one of the Model view.
   These go into the GitHub repo (images/ folder) and the LinkedIn post.

## 7. GitHub repo (10 min)
1. New public repo: `olist-ecommerce-powerbi` with a README.
2. Upload: README.md (from this package), powerquery/, dax/, data-model/,
   dashboard/, docs/, images/ (your screenshots).
3. Do NOT upload the raw CSVs or the .pbix if it is over 25 MB - the README
   explains where the data comes from (Kaggle) and how to rebuild.

## Troubleshooting
- "We couldn't authenticate with the credentials provided" on CSV load:
  Data source settings > clear permissions > set Anonymous.
- Slow refresh: the two biggest files are orders (17 MB) and items (15 MB); normal.
- Map not showing states: make sure customer_state is categorized as State or Province
  (Data view > column > Data category).

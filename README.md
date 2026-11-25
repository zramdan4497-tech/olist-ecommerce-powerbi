# Olist Brazilian E-Commerce - Power BI Analytics

Final project - Data Analysis Diploma (SIS).
An end-to-end Power BI analysis of 100,000+ real marketplace orders from Olist,
Brazil's largest department-store marketplace (2016-2018).

## Dataset

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)

- 9 related CSV tables: orders, order items, customers, sellers, products,
  payments, reviews, geolocation, category translation
- 112,650 order lines across 99,441 orders (96,478 delivered)
- 713K+ downloads on Kaggle
- Real, anonymized commercial data

## Dashboard (5 pages)

1. **Overview** - revenue, orders, AOV, review score, on-time delivery, trends,
   top categories, revenue map, payment mix
2. **Sales & Products** - category performance, price/volume niches, MoM growth
3. **Customers & Geography** - customer distribution, repeat-purchase rate,
   revenue by state and city
4. **Delivery Performance** - delivery days, on-time % by state, late-delivery impact
5. **Reviews & Satisfaction** - score distribution, worst-rated categories,
   delivery-time effect on ratings

## Key findings

- R$ 13.59M product revenue (R$ 15.84M GMV incl. freight) across 99,441 orders
- 91.9% of deliveries arrive before the estimated date (avg 12.1 days vs 23.4 promised)
- Late deliveries cut the average review score from 4.3 to 2.6
- Top categories by revenue: health & beauty, watches & gifts, bed & bath
- Sao Paulo state alone generates ~38% of revenue
- Credit card is the dominant payment method (74,975 of 99,437 paid orders)
- Only 3.1% of customers ever bought again - a one-time-purchase marketplace

## Tech stack

- Power BI Desktop (data model, DAX, report)
- Power Query (all cleaning and transformation - see `powerquery/`)
- DAX (24 measures - see `dax/measures.dax`, expected values in comments)

## Repo structure

```
data-model/      star schema documentation (MODEL.md)
powerquery/      one .pq script per table (paste into Advanced Editor)
dax/             measures.dax - all measures with expected values
dashboard/       DASHBOARD_SPEC.md - page-by-page build spec
docs/            BUILD_GUIDE.md - step-by-step rebuild instructions
images/          dashboard screenshots
```

## Reproduce

1. Download the dataset from Kaggle (link above) into a `data/` folder.
2. Follow `docs/BUILD_GUIDE.md` - about one hour from zero to finished .pbix.

## Author

Ziad Alaa - [LinkedIn](https://www.linkedin.com/in/ziad-alaa-20a319362/) -
[GitHub](https://github.com/zramdan4497-tech)

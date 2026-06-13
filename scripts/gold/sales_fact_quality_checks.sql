/*
    - We try to check whether the fact and dimension tables can successfully join
*/

SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers dc
ON f.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL


SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_products dp
ON f.product_key = dp.product_key
WHERE dp.product_key IS NULL

SELECT *FROM gold.dim_customers
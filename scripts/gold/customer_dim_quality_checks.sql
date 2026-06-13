/*
    - Checking if there are duplicate values in the overall customer
      dimensions table. 
    - NOTE that we do this before performing data integration on gender columns,
      renaming the column names and generating the surrogate keys for the customer
      dimension table.
*/
SELECT cst_id, COUNT(*) FROM
(SELECT
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gender,
ca.bdate,
ca.gen,
la.cntry
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid)t
GROUP BY cst_id
HAVING COUNT(*) > 1


-- Checking for invalid genders
SELECT DISTINCT(gender)
FROM gold.dim_customers
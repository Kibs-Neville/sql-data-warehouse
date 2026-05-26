/*
    ============================================
        Silver Data Quality Check Script
    ============================================
    
    Script purpose:
        - The following is a data quality check script for the silver tables

        - It helps us ensure that the transformations we made to the data from
          the bronze tables have taken effect and the quality is clean
          
        - Incase of any discrepancy, the transformations are reviewed and updated
          until we obtain clean silver tables
*/

USE DataWarehouse;

/*
    ================================
    Table Name: silver.crm_cust_info
    ================================
*/

-- Checking for Nulls or duplicates in primary key
-- Expectation: No Result
SELECT cst_id, COUNT(*) AS Count FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- Check for unwanted spaces
-- Expectation: No Result
SELECT cst_firstname 
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname 
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT cst_marital_status 
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

SELECT cst_gender 
FROM silver.crm_cust_info
WHERE cst_gender != TRIM(cst_gender);

-- Data Standardization & Consistency
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

SELECT DISTINCT cst_gender
FROM silver.crm_cust_info;


/* 
    ================================
    Table Name: silver.crm_prd_info
    ================================
*/

-- Checking for Nulls or duplicates in primary key
-- Expectation: No Result
SELECT prd_id, COUNT(*) AS Count FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Result
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for Nulls or Negative Numbers
-- Expectation: No Result
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for invalid date orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt


/* 
    =====================================
    Table Name: silver.crm_sales_details
    =====================================
*/

-- Checking for Unwanted Spaces
SELECT *FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

-- Checking for invalid prd_key
SELECT *FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT DISTINCT prd_key FROM silver.crm_prd_info)

-- Checking for invalid cust_id
SELECT *FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT DISTINCT cst_id FROM silver.crm_cust_info)

-- Checking for invalid dates
SELECT * FROM silver.crm_sales_details
WHERE sls_due_dt < sls_ship_dt
OR sls_ship_dt < sls_order_dt

-- Checking for invalid sales
SELECT sls_sales, sls_quantity, sls_price 
FROM silver.crm_sales_details
WHERE sls_sales <= 0
OR sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL 
OR sls_quantity <= 0
OR sls_quantity IS NULL
OR sls_price <= 0
OR sls_price IS NULL



/*
    =================================
    ERP DATA

    Table Name: silver.erp_cust_az12
    =================================
*/

-- Check for invalid Customer ID
SELECT * FROM silver.erp_cust_az12 
WHERE cid NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

-- Check out of range dates
SELECT DISTINCT bdate FROM silver.erp_cust_az12
WHERE bdate > GETDATE()

-- Data Standardization & Consistency
SELECT DISTINCT gen 
FROM silver.erp_cust_az12



/* 
    =================================
    Table Name: silver.erp_loc_a101
    =================================
*/

-- Checking for invalid Customer ID
SELECT * FROM silver.erp_loc_a101
WHERE cid NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

-- Data Standardization and Consistency
SELECT DISTINCT cntry
FROM silver.erp_loc_a101


/*
    ===================================
    Table Name: silver.erp_px_cat_g1v2
    ===================================
*/
-- Checking for invalid IDs
SELECT * FROM silver.erp_px_cat_g1v2 
WHERE id NOT IN (SELECT DISTINCT cat_id FROM silver.crm_prd_info)

-- Data Normalization, Standardization & Consistency | Checking for unwanted spaces
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2
ORDER BY cat

SELECT * FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)

SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2
ORDER BY subcat

SELECT * FROM silver.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat)

-- Data Standardization & Consistency
SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2

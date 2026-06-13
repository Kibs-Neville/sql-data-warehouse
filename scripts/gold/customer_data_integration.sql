/*
    - Performing data integration for the gender since we have
      2 gender columns (cst_gender & gen)
*/
SELECT DISTINCT
    ci.cst_gender,
    ca.gen,
    CASE WHEN ci.cst_gender != 'n/a' THEN ci.cst_gender -- CRM is the Master for gender information
         ELSE COALESCE(ca.gen, 'n/a')
    END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON        ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON        ci.cst_key = la.cid
ORDER BY 1,2
/*
    - Checking if there are duplicate values in the overall product
      dimensions table. 
*/
SELECT prd_key, COUNT(*) FROM
(SELECT 
pn.prd_id,
pn.cat_id,
pn.prd_key,
pn.prd_nm,
pn.prd_cost,
pn.prd_line,
pn.prd_start_dt,
pc.cat,
pc.subcat,
pc.maintenance 
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL)t  -- Filter out all historical data
GROUP BY prd_key
HAVING COUNT(*) > 1
INSERT INTO silver.erp_px_cat_g1v2(
    id,
    cat,
    subcat,
    maintenance
)

SELECT 
    id,
    cat,
    subcat,
    CASE WHEN TRIM(maintenance) LIKE 'Y%' THEN 'Yes'
         WHEN TRIM(maintenance) LIKE 'N%' THEN 'No'
         ELSE 'n/a'
    END AS maintenance
FROM bronze.erp_px_cat_g1v2 
 
SELECT * FROM silver.erp_px_cat_g1v2 
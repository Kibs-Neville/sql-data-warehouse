INSERT INTO silver.erp_loc_a101(
    cid,
    cntry
)

SELECT

    REPLACE(cid, '-', '') AS cid,

    CASE WHEN TRIM(cntry) LIKE 'France%' THEN 'France'
         WHEN TRIM(cntry) LIKE 'US%' THEN 'United States'
         WHEN TRIM(cntry) LIKE 'United States%' THEN 'United States'
         WHEN TRIM(cntry) LIKE 'United Kingdom%' THEN 'United Kingdom'
         WHEN TRIM(cntry) LIKE 'Canada%' THEN 'Canada'
         WHEN TRIM(cntry) LIKE 'Germany%' THEN 'Germany'
         WHEN TRIM(cntry) LIKE 'Australia%' THEN 'Australia'
         WHEN TRIM(cntry) LIKE 'DE%' THEN 'Germany'
         ELSE 'n/a'
    END AS cntry

FROM bronze.erp_loc_a101;


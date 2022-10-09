SELECT
    airlinename AS Aeroporto,
    count(routeid) AS Total
FROM
    `433d378cad7e423a9ae606f37a980cf7`.routes
WHERE
    mdmDeleted IS NULL
    OR mdmDeleted = FALSE
GROUP BY
    airlinename
ORDER BY
    Total DESC
LIMIT
    10

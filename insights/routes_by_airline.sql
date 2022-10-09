SELECT
    airlinename AS Companhia,
    sourceairportname AS Origem,
    destinationairportname AS Destino
FROM
    `433d378cad7e423a9ae606f37a980cf7`.routes
WHERE
    mdmDeleted IS NULL
    OR mdmDeleted = FALSE
ORDER BY
    airlinename,
    sourceairportname,
    destinationairportname

SELECT 
    transaction_id, 
    amount, 
    tx_type, 
    tx_timestamp,
    COALESCE(description, 'EXCLUSIÓN OPORTUNAMENTE DETECTADA - SIN MOTIVO DE PAGO') AS descripcion_monitoreada
FROM core.transactions
WHERE  amount >= 10000.00 AND tx_type IN ('TRANSFER', 'WITHDRAWAL')
       OR description ILIKE '%crypto%'
        OR description ILIKE '%offshore%'
        OR description ILIKE '%shell%'
        OR description ILIKE '%casino%'
NULLIF(TRIM(description), '') IS NULL AND tx_type != 'DEPOSIT'
ORDER BY  amount DESC;


--Explicación: EL script falló porque AND se toma en cuenta antes que OR, como no se uso el paréntesis, las condiciones se interpretaron de una forma diferente, por eso description IS NULL podía activar la alerta por sí sola generando miles de falsos positivos en depósitos normales.
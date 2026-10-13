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


Correcion
Aprendí más o menos que debo buscar movimientos sospechosos por su monto o descripción, detectar los que no tienen motivo y ordenar los resultados del monto más alto al más bajo.


Reference Solution

SELECT transaction_id,account_id,tx_type,amount,
       COALESCE(NULLIF(TRIM(description),''),'SIN DESCRIPCIÓN') AS visible_description
FROM core.transactions
WHERE (tx_type IN ('TRANSFER','WITHDRAWAL') AND amount>=100)
   OR (tx_type='WITHDRAWAL' AND NULLIF(TRIM(description),'') IS NULL)
ORDER BY amount DESC,transaction_id;
Los dos TRANSFER superan el umbral didáctico. El retiro de 50 entra por descripción faltante. El depósito no cumple ninguno de los dos bloques. Una alerta exploratoria requiere revisión adicional y no constituye una acusación ni un reporte legal.
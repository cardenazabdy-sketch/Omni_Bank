--1.Construye una muestra de cuatro valores válida para PostgreSQL con tres números (10000, 0, 0) y un NULL. Calcula AVG sobre la muestra y luego sobre la misma muestra con COALESCE a cero; registra los denominadores 3 y 4:

WITH sample(x) AS (VALUES (10000::numeric),(0::numeric),(0::numeric),(NULL::numeric))
SELECT COUNT(*) AS rows, COUNT(x) AS known_values,
    ROUND(AVG(x), 2) AS known_average,                             
    COUNT(COALESCE(x, 0)) AS values_with_zero,                   
    ROUND(AVG(COALESCE(x, 0)), 2) AS average_with_zero
FROM sample;

/*La muestra contiene cuatro filas, pero solo tres valores conocidos: 10000, 0 y 0.
Denominador 3: Al aplicar AVG(x), ignora la fila con valor NULL, dividiendo la suma entre los 3 valores conocidos para un promedio de 3333.33.
Denominador 4:Al usar COALESCE(x, 0), la fila NULL se convierte en 0, contando como la cuarta fila de la muestra para un promedio de 2500.00.*/

--2.Desde accounts y transactions, informa para cada cuenta CREDIT activa el saldo almacenado, número de movimientos y volumen bruto. Conserva la cuenta aunque no tuviera eventos; no llames saldo al volumen:

SELECT a.account_number,  a.balance AS saldo_almacenado,
    COUNT(t.transaction_id) AS números_movimientos,
    COALESCE(SUM(t.amount), 0) AS volumen_bruto
FROM core.accounts AS a
LEFT JOIN core.transactions AS t ON t.account_id = a.account_id
WHERE a.account_type = ‘CREDIT’ AND a.is_active 
GROUP BY a.account_number, a.balance
HAVING COUNT(t.transaction_id) = 0 OR COALESCE(SUM(t.amount), 0) >= 300
ORDER BY a.account_number;


--3.Explicación: Una cuenta con eventos por menos de 300 quedaría fuera del segmento porque su volumen registrado no llega a 300, mientras que una cuenta sin eventos permanecería porque tiene cero movimientos y cumple con  la condición COUNT(t.transaction_id) = 0 en el HAVING.
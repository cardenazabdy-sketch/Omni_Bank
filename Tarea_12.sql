--1.Extiende la consulta de ausencia de la actividad para devolver solo cuentas activas sin ningún movimiento. Mantén el filtro administrativo fuera de la subconsulta de existencia.
--Cuentas activas sin movimientos: 1

SELECT a.account_number, a.is_active
FROM core.accounts AS a
WHERE a.is_active = TRUE
  AND NOT EXISTS ( SELECT 1 FROM core.transactions AS t
      WHERE t.account_id = a.account_id )
ORDER BY a.account_number;

--2.Construye un segundo NOT EXISTS que busque ausencia de DEPOSIT para todas las cuentas. No confíes en NOT IN si la subconsulta puede devolver NULL; muestra con una pequeña consulta de valores por qué ese caso cambia la lógica.
--Cuentas sin depósitos: 4

SELECT a.account_number, a.is_active
FROM core.accounts AS a
WHERE NOT EXISTS ( SELECT 1 FROM core.transactions AS t
    WHERE t.account_id = a.account_id AND t.tx_type = 'DEPOSIT' )
ORDER BY a.account_number;

--3.Compara los dos conjuntos con recuentos independientes y describe por qué una cuenta con TRANSFER puede estar en el segundo pero no en el primero:
--Una cuenta con TRANSFER puede aparecer en el segundo conjunto porque no tiene depósitos registrados, aunque sí haya realizado una transferencia, pero no aparece en el primero porque ya tiene una transferencia registrada.




/*Muestra aislada de NOT IN con NULL:
WITH valores(x) AS (VALUES (1),(NULL::integer))
SELECT 2 NOT IN (SELECT x FROM valores) AS not_in_result; 

Interpretación: NOT IN devuelve NULL (UNKNOWN) porque la lista contiene un valor nulo. En cambio, NOT EXISTS devuelve TRUE porque no encuentra ninguna fila con el valor 2.    
NOT EXISTS (SELECT 1 FROM valores WHERE x=2) AS not_exists_result;*/

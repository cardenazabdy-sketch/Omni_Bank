--1.Calcula para cada movimiento el promedio de amount de los eventos que comparten su account_id. Usa una subconsulta correlacionada o una estrategia equivalente y conserva el identificador de la fila externa.

SELECT t.transaction_id, t.account_id, t.amount,
    ( SELECT AVG(x.amount)
        FROM core.transactions AS x
        WHERE x.account_id = t.account_id ) AS promedio_cuenta
FROM core.transactions AS t
WHERE t.amount > (
    SELECT AVG(x.amount)
    FROM core.transactions AS x
    WHERE x.account_id = t.account_id)
ORDER BY t.account_id, t.transaction_id;

--2.Filtra únicamente movimientos cuyo importe supera ese promedio. Comprueba el resultado contra un promedio agrupado independiente antes de interpretar el evento.

SELECT account_id, AVG(amount) AS promedio_cuenta
FROM core.transactions
GROUP BY account_id
ORDER BY account_id;

--3.Desde accounts, utiliza NOT EXISTS para hallar cuentas sin filas relacionadas en transactions. Proyecta account_number e is_active en columnas distintas.

SELECT a.account_number, a.is_active
FROM core.accounts AS a
WHERE NOT EXISTS (
    SELECT 1 FROM core.transactions AS t WHERE t.account_id = a.account_id)
ORDER BY a.account_number;


--4.Ordena los resultados y explica por qué una cuenta sin movimientos no tiene promedio de eventos, pero sigue apareciendo en el segundo reporte: 
--Ordené los movimientos por cuenta para que sea más fácil y también ordené la lista de cuentas sin movimientos por número de cuenta.
--Una cuenta sin movimientos no tiene promedio de eventos porque no hay importes para calcularlo, pero sí aparece en el segundo reporte porque ahí se buscan las cuentas que no tienen movimientos registrados.



/*Explicación: El promedio 100 de ACCT-1001 y de los estados distintos de ACCT-1002 y ACCT-3002:
-ACCT-1001 tiene dos movimientos, uno de 150 y otro de 50. Al sumar los dos importes da 200, y al repartirlo entre los dos movimientos queda en 100 cada uno. Por eso solo el movimiento de 150 queda por encima del promedio de su cuenta. La cuenta de Jane y la CREDIT de Alice solo tienen un movimiento, así que no pueden estar por encima de su propio promedio.
-ACCT-1002 y ACCT-3002 no tienen movimientos, pero tienen estados diferentes una está activa y la otra no. Esto quiere decir que una cuenta puede seguir activa aunque no haya registrado ningún movimiento.*/

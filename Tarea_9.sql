--1.Cuantifica la matriz sin relaciones:
--Explicación en una frase: Cada combinación representa un cliente, una cuenta y un movimiento juntos solo porque el CROSS JOIN los multiplica, sin tener alguna relación, muchas parejas son falsas desde el punto de vista del negocio porque cada movimiento pertenece a una sola cuenta y a un solo cliente.


SELECT (SELECT COUNT(*) FROM core.customers) AS c,       --Grano: Muestra el total de clientes. Predicados: no se establecen condiciones.
(SELECT COUNT(*) FROM core.accounts) AS a,               --Grano:Muestra el total de cuentas. Predicados: no se establecen condiciones.
(SELECT COUNT(*) FROM core.transactions) AS t;           --Grano: Muestra el total de movimientos. Predicados: no se establecen condiciones.

(SELECT COUNT(*) AS combinations
FROM core.customers 
CROSS JOIN core.accounts, core.transactions;


--2.Repara el reporte de movimientos:
--Grano: cada fila muestra un movimiento  junto con los datos de su cuenta y cliente. 
--Predicados:c.is_active = TRUE: el cliente debe estar activo.  t.amount >= 100: el movimiento debe ser de 100 o más.

SELECT 
     c.email,
     a.account_number,
     t.tx_type,
     t.amount,
     t.tx_timestamp
FROM core.transactions AS t
INNER JOIN core.accounts  AS a ON t.account_id  = a.account_id
INNER JOIN core.customers AS c ON a.customer_id = c.customer_id
WHERE c.is_active = true  AND t.amount >= 100
ORDER BY t.tx_timestamp, t.transaction_id;



--3.Explicación de la diferencia: La diferencia es que el producto cartesiano da 80 combinaciones, la consulta corregida solo muestra los movimientos que están relacionados, las uniones conectan cada movimiento con su cuenta y cada cuenta con su cliente. el WHERE solo muestra los clientes activos y movimientos de 100 o más.


/*Dictamen: 
- Los tres recuentos de origen son: 4 customers, 5 accounts  y 4 transactions. 
- El producto calculado es de 80 combinaciones (4 × 5 × 4).
- El reporte corregido devuelve las filas que cumplen las relaciones entre customer, account y transaction, además de los predicados de customer activo y monto >= 100. 
- La discrepancia se debe a que el CROSS JOIN combina todos los registros entre sí, mientras que el reporte corregido utiliza las claves de unión para relacionar solamente los registros correspondientes.*/




Correcion

Aprendí que debo contar las combinaciones entre las tablas y que debo comparar los resultados antes y después de relacionarlas.



Reference Solution

SELECT (SELECT COUNT(*) FROM core.customers) AS customers,
       (SELECT COUNT(*) FROM core.accounts) AS accounts,
       (SELECT COUNT(*) FROM core.transactions) AS transactions;
SELECT COUNT(*) AS combinations
FROM core.customers CROSS JOIN core.accounts CROSS JOIN core.transactions;

SELECT c.email,a.account_number,t.tx_type,t.amount,t.tx_timestamp
FROM core.transactions t
JOIN core.accounts a ON a.account_id=t.account_id
JOIN core.customers c ON c.customer_id=a.customer_id
WHERE c.is_active AND t.amount>=100
ORDER BY t.tx_timestamp,t.transaction_id;
El CROSS JOIN enumera todas las combinaciones posibles de las tres relaciones. La unión con claves preserva la pertenencia de cada movimiento a una cuenta y de esta a un cliente. El número de combinaciones por sí solo no determina el plan físico, la memoria usada ni el tiempo de respuesta.

Lectura de la solución: Una consulta exploratoria sin condiciones de unión puede producir muchas combinaciones que parecen operaciones bancarias pero que no corresponden a ninguna relación real. El área de revisión quiere cuantificar ese error lógico antes de incorporar el reporte al repositorio. La tarea extiende los JOIN de la actividad y deja un archivo reutilizable para los días de agregaciones.
--Reporte 1: Extracción Quirúrgica de Cuentas Prioritarias
/*Justificativo: Puse las columnas por su nombre en lugar de usar SELECT  para no pedir datos de más a la base. 
Usé AND para que se cumplan las dos condiciones, que el saldo sea mayor o igual a 1000.00y que la cuenta sea de tipo SAVINGS, 
ordené el saldo de mayor a menor y limité  el resultado a dos filas para mostrar las cuentas con mayor saldo. */


SELECT 
     account_number, 
     account_type, 
     balance
FROM core.accounts
WHERE balance >=1000.00 AND account_type = SAVINGS
ORDER BY balance DESC
LIMIT 2;


--Reporte 2: Búsqueda Insensible por Patrones en Clientes
/*Justificativo: Utilice ILIKE para encontrar los correos sin importar si están escritos con mayúsculas o minúsculas, 
puse el porcentaje antes de @email.com para encontrar cualquier correo que termine con ese dominio.*/


SELECT 
     first_name, 
     last_name, 
     email,
FROM core.customers
WHERE email ILIKE 'email.com';


--Reporte 3: El Desmantelamiento del Fallo por Nulidad (Lógica Tri-Valuada)
/*Justificativo: Puse IS NULL porque = NULL no permite detectar los valores que no tienen dato, 
use la coma después de amount para separar las columnas y evitar un error de sintaxis y 
use COALESCE para mostrar un texto cuando la descripción este vacía y WITHDRAWAL para mostrar solo retiros.*/

SELECT 
     account_id, 
     tx_type, 
     amount,
COALESCE (description, 'COBRO INSTITUCIONAL O COMISIÓN - SIN RECEPTOR') AS descripcion_visible
FROM core.transactions
WHERE description IS NULL AND tx_type = WITHDRAWAL;


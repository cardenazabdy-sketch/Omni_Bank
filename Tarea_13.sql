--1.Reutiliza la etapa de volumen por cuenta de la actividad y conserva en una CTE intermedia las cuentas activas sin eventos con volumen cero.
WITH movimientos_agregados AS (
    SELECT  t.account_id,
        COUNT(*) AS recuento,
        SUM(t.amount) FILTER (WHERE t.amount > 0) AS volumen_bruto
    FROM core.transactions AS t
    GROUP BY t.account_id),      --Grano: una fila por cuenta que tiene movimientos.

cuentas_activas AS (SELECT a.account_id, a.account_number, a.currency,
        COALESCE(m.recuento, 0) AS recuento,
        COALESCE(m.volumen_bruto, 0) AS volumen_bruto
    FROM core.accounts AS a
    LEFT JOIN movimientos_agregados AS m ON m.account_id = a.account_id
    WHERE a.is_active = true ),      --Grano: una fila por cuenta activa.
 

--2.Agrupa esa salida por currency para obtener número de cuentas, volumen bruto y promedio por cuenta. Redondea solo la presentación del promedio.
por_moneda AS (
    SELECT ca.currency,
        COUNT(*) AS numero_cuentas,
        SUM(volumen_bruto) AS volumen_bruto,
        ROUND(AVG(volumen_bruto), 2) AS promedio_por_cuenta
    FROM cuenta_activa AS ca
    GROUP BY ca. currency )
---Aquí cambia el grano: una fila por moneda.


--3.Verifica de manera independiente cuántas cuentas activas hay, cuánto suman los cuatro movimientos iniciales y qué aporta ACCT-3002 al denominador.

SELECT (SELECT COUNT(*) FROM core.accounts WHERE is_active = true)  AS cuenta_activa,   --Cuántas cuentas activas hay (4)
      (SELECT COALESCE(SUM(amount), 0) FROM core.transactions) AS suma_movimientos;     --Cuánto suman los cuatro movimientos iniciales (800)




Correcion

Aprendí que un pipeline de CTE ayuda a organizar la consulta paso a paso, calcular los movimientos de cada cuenta, conservar las cuentas activas sin movimientos y después sacar los totales y promedios por moneda.



Reference Solution

WITH movement AS (
 SELECT account_id, SUM(amount) AS gross_volume
 FROM core.transactions GROUP BY account_id
), account_metrics AS (
 SELECT a.account_id, a.currency, COALESCE(m.gross_volume,0) AS gross_volume
 FROM core.accounts a LEFT JOIN movement m USING (account_id)
 WHERE a.is_active
), by_currency AS (
 SELECT currency, COUNT(*) AS account_count, SUM(gross_volume) AS gross_volume
 FROM account_metrics GROUP BY currency
)
SELECT currency, account_count, gross_volume,
       ROUND(gross_volume / account_count,2) AS average_per_account
FROM by_currency ORDER BY currency;
SELECT (SELECT COUNT(*) FROM core.accounts WHERE is_active) AS active_accounts,
       (SELECT COALESCE(SUM(amount),0) FROM core.transactions) AS direct_gross_volume,
       (SELECT COUNT(*) FROM core.transactions t JOIN core.accounts a USING (account_id)
        WHERE a.account_number='ACCT-3002') AS empty_account_events;

Lectura de la solución: Finanzas quiere una vista por moneda a partir del mismo pipeline, sin reescribir el cálculo de movimientos ni perder cuentas activas de volumen cero. La tarea añade una etapa de agregación sobre el resultado por cuenta; ese cambio de grano debe quedar explícito en nombres y columnas.
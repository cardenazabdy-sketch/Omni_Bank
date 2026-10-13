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


--1. Cuentas activas sin depósitos
SELECT a.account_number, a.account_type, c.first_name, c.last_name
FROM core.accounts AS a
LEFT JOIN core.customers AS c ON c.customer_id = a.customer_id
WHERE a.is_active = true
        AND NOT EXISTS ( SELECT 1 FROM core.transactions AS t
        WHERE t.account_id = a.account_id AND t.tx_type = 'DEPOSIT')
ORDER BY a.account_number;


--2. Cuentas activas que sí tienen algún movimiento
SELECT a.account_number, a.account_type, c.first_name, c.last_name
FROM core.accounts AS a
LEFT JOIN core.customers AS c ON c.customer_id = a.customer_id
WHERE a.is_active = true 
      AND EXISTS ( SELECT 1 FROM core.transactions AS t
      WHERE t.account_id = a.account_id )
ORDER BY a.account_number;

--Explicación: Ambos conjuntos pueden solaparse porque una cuenta puede tener movimientos, como retiros o transferencias, pero no tener ningún depósito. Por eso, una cuenta puede aparecer en las dos listas: cuentas activas sin depósitos y cuentas activas con algún movimiento.

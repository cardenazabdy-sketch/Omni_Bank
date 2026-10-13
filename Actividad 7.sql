1.La Inserción Idempotente de los Clientes Pioneros (core.customers):

INSERT INTO core.customers (customer_id, first_name, last_name, email, phone_number, Tax_id, Fecha_nacimiento)
VALUES 
    ('11111111-1111-1111-1111-111111111111', 'John', 'Doe', 'john.doe@email.com', '555-0100', 'TAX-100', '1985-04-12')
    ('22222222-2222-2222-2222-222222222222', 'Jane', 'Smith', 'jane.smith@email.com', '555-0200', 'TAX-200', '1990-08-25')
    ('33333333-3333-3333-3333-333333333333', 'Alice', 'Johnson', 'alice.j@email.com', '555-0300', 'TAX-300', '1978-11-05')

ON CONFLICT (email) DO NOTHING;

2.La Apertura de Cuentas Financieras (core.accounts):

INSERT INTO core.accounts (account_id, customer_id, número_cuenta, tipo_cuenta, saldo, limite_crédito)
VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'ACCT-1001', 'CHECKING', 5000.00, 0)
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '22222222-2222-2222-2222-222222222222', 'ACCT-2001', 'SAVINGS', 15000.00, 0)
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', '33333333-3333-3333-3333-333333333333', 'ACCT-3001', 'CREDIT', 0.00, 10000.00)

ON CONFLICT (account_number) DO NOTHING;


3.El Primer Movimiento Bancario de Prueba:

NSERT INTO core.transactions (id_cuenta_origen, id_cuenta_destino, importe, moneda, tipo_transaccion, estado)
VALUES 
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 150.00, 'USD', 'TRANSFER', 'COMPLETED')
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 300.00, 'USD', 'TRANSFER', 'COMPLETED')
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL, 50.00, 'USD', 'FEE', 'COMPLETED');


4.La Deducción y Confirmación al Vuelo (UPDATE ... RETURNING):

UPDATE core.accounts 
SET balance = balance - 50.00,
WHERE account_number = 'ACCT-1001'
RETURNING account_number, balance;


Correcion

Aprendí y entendí para qué sirven palabras como INSERT INTO, VALUES, WHERE y RETURNING, poco a poco voy aprendiendo dónde y cómo utilizar cada una. Cuando empecé a comparar mi respuesta, me di cuenta de que la idea principal sí la entendí, pero me faltaron algunos detalles. Por ejemplo, no puse updated_at = CURRENT_TIMESTAMP en el UPDATE y tampoco agregué la columna description en las transacciones, no los puse porque todavía no sabía que también debía incluirlos.



Reference Solution

1. Script DML Idempotente de Población (03_initial_data.sql)
-- 1. Inserción resiliente e idempotente de Clientes Pioneros de OmniBank
INSERT INTO core.customers (customer_id, first_name, last_name, email, phone, tax_id)
VALUES 
    ('11111111-1111-1111-1111-111111111111', 'John', 'Doe', 'john.doe@email.com', '555-0100', 'TAX-100'),
    ('22222222-2222-2222-2222-222222222222', 'Jane', 'Smith', 'jane.smith@email.com', '555-0200', 'TAX-200'),
    ('33333333-3333-3333-3333-333333333333', 'Alice', 'Johnson', 'alice.j@email.com', '555-0300', 'TAX-300')
ON CONFLICT (email) DO NOTHING;

-- 2. Apertura protegida ante duplicidades para Cuentas Financieras
INSERT INTO core.accounts (account_id, customer_id, account_number, account_type, balance)
VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'ACCT-1001', 'CHECKING', 5000.00),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '22222222-2222-2222-2222-222222222222', 'ACCT-2001', 'SAVINGS', 15000.00),
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', '33333333-3333-3333-3333-333333333333', 'ACCT-3001', 'CREDIT', 0.00)
ON CONFLICT (account_number) DO NOTHING;

-- 3. Inserción de Operaciones y Movimientos Iniciales de Prueba
-- (Nota: No aplica obligatoriamente ON CONFLICT en transacciones sin una columna única asignada, pero podemos insertarlas convencionalmente).
INSERT INTO core.transactions (account_id, tx_type, amount, description)
VALUES 
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'TRANSFER', 150.00, 'Pago de cena a Jane'),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'TRANSFER', 300.00, 'Abono a tarjeta de crédito de Alice'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'WITHDRAWAL', 50.00, 'Comisión mensual por manejo de cuenta');

-- 4. Deducción de Comisión con Filtro Inquebrantable WHERE y Extracción al Vuelo con RETURNING
UPDATE core.accounts 
SET balance = balance - 50.00,
    updated_at = CURRENT_TIMESTAMP
WHERE account_number = 'ACCT-1001'
RETURNING account_number, balance;
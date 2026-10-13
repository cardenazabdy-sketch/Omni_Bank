CREATE SCHEMA IF NOT EXISTS core;

1.CREATE TABLE core.customers (
cliente_id UUID DEFAULT gen_random_uuid().
nombre_completo VARCHAR (100) NOT NULL,
email VARCHAR (150) NOT FULL,
No.telefono VARCHAR (100) NOT FULL, 
created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
is_active BOOLEAN DEFAULT true NOT NULL

CONSTRAINT pk_cliente PRIMARY KEY (cliente_id)
CONSTRAINT uq_cliente_email UNIQUE (email)
CONSTRAINT uq_customer_telefono UNIQUE (No.telefono)
);

2.CREATE TABLE core.accounts (
cuenta_id UUID DEFAULT gen_random_uuid().
cliente_id UUID NOT FULL,
core.tipo_moneda NOT NULL, 
core.tipo_cuenta NOT NULL,
saldo NUMERIC (15,2) Check (monto > = 0.00)
created_at TIMESTAMPTZ DEFAULT CURRENT-TIMESTAMP NOT NULL
is_active BOOLEAN DEFAULT true NOT NULL

CONSTRAINT cuenta_id UUID DEFAULT gen_random_uuid().
CONSTRAINT pk_cliente PRIMARY KEY (cliente_id)
CONSTRAINT accounst_customers FOREING KEY (customer_id)
REFERENCES core.customers (cliente_id) ON DELETE RESTRICT
CONSTRAINT saldo check (monto > = 0.00)
);

3.CREATE TABLE core.loans (
loans UUID DEFAULT gen_random_uuid().
customer_id UUID NOT FULL,
loan_numero VARCHAR (50) NOT NULL,
monto AS NUMERIC (15,2) NOT NULL,
estado VARCHAR (100) DEFAULT ACTIVE,
created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL

CONSTRAINT pk_loans PRIMARY KEY (loan_id)
CONSTRAINT uq_loan_numero UNIQUE (loan_numero)
CONSTRAINT monto Check (monto > 0.00)
CONSTRAINT loans_customer FOREING KEY (customer_id)
REFERENCES core_customers (customer_id) ON DELETE RESTRICT
);

4.CREATE TABLE core.transactions (
transaction_id UUID DEFAULT gen_random_uuid()
cliente_id UUID NOT NULL,
core.tipo_transaccion NOT NULL,
monto_tipo AS NUMERIC (15,2) NOT NULL,
created.at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL

CONSTRAINT pk_transactions PRIMAY KEY (transaction_id)
CONSTRAINT cuenta FOREING KEY (cuenta_id)
CONSTRAINT monto Check (monto > 0.00)
REFERENCES core.accounts (cuenta_id) ON DELETE RESTRICT
);

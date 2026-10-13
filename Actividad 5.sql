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



Correcion
Aprendí a crear tablas, organizar las entidades y saber los atributos, al comparar los resultados, me di cuenta de que me faltó definir bien algunos datos, poco a poco voy entendiendo cómo acomodar cada parte.



Reference Solution
1. Script SQL de Creación Relacional (DDL Core)
-- 1. Asegurar la creación de nuestro esquema relacional centralizado
CREATE SCHEMA IF NOT EXISTS core;

-- 2. Declarar Entidad Raíz Madre: customers
CREATE TABLE core.customers (
    customer_id UUID DEFAULT gen_random_uuid(),
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(30),
    tax_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT true NOT NULL,
    
    CONSTRAINT pk_customers PRIMARY KEY (customer_id),
    CONSTRAINT uq_customers_email UNIQUE (email),
    CONSTRAINT uq_customers_tax_id UNIQUE (tax_id)
);

-- 3. Declarar Entidad Hija Financiera de Cuentas: accounts
CREATE TABLE core.accounts (
    account_id UUID DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
    account_number VARCHAR(30) NOT NULL,
    currency core.tipo_moneda DEFAULT 'USD' NOT NULL,
    account_type core.tipo_cuenta DEFAULT 'CHECKING' NOT NULL,
    balance NUMERIC(15, 2) DEFAULT 0.00 NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT true NOT NULL,
    
    CONSTRAINT pk_accounts PRIMARY KEY (account_id),
    CONSTRAINT uq_accounts_number UNIQUE (account_number),
    CONSTRAINT chk_accounts_balance_no_negativo CHECK (balance >= 0.00),
    CONSTRAINT fk_accounts_customer FOREIGN KEY (customer_id)
        REFERENCES core.customers(customer_id) ON DELETE RESTRICT
);

-- 4. Declarar Entidad Hija de Crédito Bancario: loans
CREATE TABLE core.loans (
    loan_id UUID DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
    loan_number VARCHAR(30) NOT NULL,
    principal_amount NUMERIC(15, 2) NOT NULL,
    interest_rate NUMERIC(6, 4) NOT NULL, -- Ej: 0.0850 para un 8.5%
    status VARCHAR(20) DEFAULT 'ACTIVE' NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    
    CONSTRAINT pk_loans PRIMARY KEY (loan_id),
    CONSTRAINT uq_loans_number UNIQUE (loan_number),
    CONSTRAINT chk_loans_principal CHECK (principal_amount > 0.00),
    CONSTRAINT chk_loans_rate CHECK (interest_rate >= 0.00),
    CONSTRAINT fk_loans_customer FOREIGN KEY (customer_id)
        REFERENCES core.customers(customer_id) ON DELETE RESTRICT
);

-- 5. Declarar Entidad Transaccional Inmutable: transactions
CREATE TABLE core.transactions (
    transaction_id UUID DEFAULT gen_random_uuid(),
    account_id UUID NOT NULL,
    tx_type core.tipo_transaccion NOT NULL,
    amount NUMERIC(15, 2) NOT NULL,
    tx_timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    description VARCHAR(250),
    
    CONSTRAINT pk_transactions PRIMARY KEY (transaction_id),
    CONSTRAINT chk_transactions_amount CHECK (amount > 0.00),
    CONSTRAINT fk_transactions_account FOREIGN KEY (account_id)
        REFERENCES core.accounts(account_id) ON DELETE RESTRICT
);
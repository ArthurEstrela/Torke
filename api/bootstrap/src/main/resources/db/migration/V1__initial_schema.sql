create table tenants (
    id uuid primary key,
    name varchar(150) not null,
    slug varchar(60) not null unique,
    created_at timestamptz not null
);

create table users (
    id uuid primary key,
    tenant_id uuid not null references tenants(id) on delete cascade,
    name varchar(150) not null,
    email varchar(180) not null,
    password_hash varchar(100) not null,
    role varchar(30) not null,
    created_at timestamptz not null,
    unique (tenant_id, email)
);

create table customers (
    id uuid primary key,
    tenant_id uuid not null references tenants(id) on delete cascade,
    name varchar(150) not null,
    phone varchar(30) not null,
    email varchar(180) not null default '',
    created_at timestamptz not null,
    updated_at timestamptz not null,
    unique (tenant_id, id)
);

create table vehicles (
    id uuid primary key,
    tenant_id uuid not null references tenants(id) on delete cascade,
    customer_id uuid not null,
    brand varchar(80) not null,
    model varchar(100) not null,
    plate varchar(8) not null,
    year integer not null check (year between 1900 and 2100),
    color varchar(50) not null default '',
    created_at timestamptz not null,
    unique (tenant_id, id),
    unique (tenant_id, plate),
    foreign key (tenant_id, customer_id) references customers(tenant_id, id) on delete cascade
);

create table service_orders (
    id uuid primary key,
    tenant_id uuid not null references tenants(id) on delete cascade,
    number bigint not null,
    customer_id uuid not null,
    vehicle_id uuid not null,
    description varchar(500) not null,
    amount numeric(12,2) not null check (amount >= 0),
    scheduled_at timestamptz not null,
    status varchar(30) not null,
    created_at timestamptz not null,
    updated_at timestamptz not null,
    unique (tenant_id, number),
    foreign key (tenant_id, customer_id) references customers(tenant_id, id),
    foreign key (tenant_id, vehicle_id) references vehicles(tenant_id, id)
);

create table tenant_counters (
    tenant_id uuid primary key references tenants(id) on delete cascade,
    next_order_number bigint not null
);

create index idx_users_tenant on users(tenant_id);
create index idx_customers_tenant_name on customers(tenant_id, name);
create index idx_vehicles_tenant_customer on vehicles(tenant_id, customer_id);
create index idx_orders_tenant_status on service_orders(tenant_id, status);
create index idx_orders_tenant_schedule on service_orders(tenant_id, scheduled_at);

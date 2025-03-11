create schema if not exists jaffle_shop;
create schema if not exists stripe;
create schema if not exists dev;

-- drop table if exists affle_shop.customers;
create table jaffle_shop.customers(
    id integer,
    first_name varchar(50),
    last_name varchar(50)
);
--drop table jaffle_shop.orders;
create table jaffle_shop.orders(
    id integer,
    user_id integer,
    order_date date,
    status varchar(50)
);

-- drop table if exists stripe.payment;
create table stripe.payment(
    id integer,
    orderid integer,
    paymentmethod varchar(50),
    status varchar(50),
    amount integer,
    created date
);

-- drop table if exists jaffle_shop.payments;
create table jaffle_shop.payments(
    id integer,
    order_id integer,
    payment_method varchar(50),
    status varchar(50),
    amount integer,
    created date
);
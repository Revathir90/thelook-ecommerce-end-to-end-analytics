CREATE SCHEMA clean

CREATE TABLE clean.orders_base AS
SELECT DISTINCT *
FROM public.orders

SELECT count(*)
FROM clean.orders 
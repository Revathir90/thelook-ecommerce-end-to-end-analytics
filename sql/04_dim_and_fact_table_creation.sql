--Creating a fact & dimention tables and adding PRIMARY KEY and FOREIGN KEY constrains for analysis 

--dim_users
CREATE TABLE clean.dim_users AS
	SELECT 
		user_id, 
		first_name, 
		last_name, 
		email,
		age,
		gender,
		state,
		street_address,
		postal_code,
		city,
		country,
		latitude,
		longitude,
		traffic_source,
		created_at,
		user_geom
	FROM 
		clean.users_base

ALTER TABLE clean.dim_users
ADD CONSTRAINT pk_dim_users PRIMARY KEY (user_id)

--dim_products
CREATE TABLE clean.dim_products AS
	SELECT 
		product_id,
		cost,
		category,
		name,
		brand,
		retail_price,
		department,
		sku,
		distribution_center_id
	FROM 
		clean.products_base

ALTER TABLE clean.dim_products
ADD CONSTRAINT pk_dim_products PRIMARY KEY (product_id)

--dim_orders
CREATE TABLE clean.dim_orders AS
	SELECT 
		order_id,
		user_id,
		status,
		gender,
		created_at,
		returned_at,
		shipped_at,
		delivered_at,
		num_of_item
	FROM 
		clean.orders_base

ALTER TABLE clean.dim_orders
ADD CONSTRAINT pk_dim_orders PRIMARY KEY (order_id)

--dim_distribution_centers
CREATE TABLE clean.dim_distribution_centers AS 
	SELECT 
		id,
		name,
    	latitude,
    	longitude,
    	distribution_center_geom
	FROM
		clean.distribution_centers_base

ALTER TABLE clean.dim_distribution_centers
ADD CONSTRAINT pk_dim_distribution_centers PRIMARY KEY (id)


--fact_order_items
CREATE TABLE clean.fact_order_items AS
	SELECT
		id,
    	order_id,
   		user_id,
    	product_id,
		inventory_item_id,
    	status,
    	created_at,
    	shipped_at,
    	delivered_at,
    	returned_at,
    	sale_price
	FROM 
		clean.order_items_base

ALTER TABLE clean.fact_order_items
ADD CONSTRAINT pk_fact_order_itmes PRIMARY KEY (id)
--Adding foreign key
ALTER TABLE clean.fact_order_items
ADD CONSTRAINT FK_fact_users FOREIGN KEY (user_id)
REFERENCES clean.dim_users (user_id);

SELECT *
FROM clean.fact_order_items

--Removing the data with no corresponding data in dim table
DELETE FROM clean.fact_order_items
WHERE user_id NOT IN (SELECT user_id FROM clean.dim_users);

ALTER TABLE clean.fact_order_items
ADD CONSTRAINT FK_fact_orders FOREIGN KEY (order_id)
REFERENCES clean.dim_orders (order_id);

ALTER TABLE clean.fact_order_items
ADD CONSTRAINT FK_fact_products FOREIGN KEY (product_id)
REFERENCES clean.dim_products (product_id);
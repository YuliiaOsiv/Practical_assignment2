CREATE DATABASE IF NOT EXISTS opt_db;
USE opt_db;

CREATE TABLE IF NOT EXISTS opt_clients (
    id CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    address TEXT NOT NULL,
    status ENUM('active', 'inactive') NOT NULL
);

CREATE TABLE IF NOT EXISTS opt_products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_category ENUM('Category1', 'Category2', 'Category3', 'Category4', 'Category5') NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS opt_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    client_id CHAR(36),
    product_id INT,
    FOREIGN KEY (client_id) REFERENCES opt_clients(id),
    FOREIGN KEY (product_id) REFERENCES opt_products(product_id)
);




select c.name, c.surname, count(o.order_id) as total_orders,
		count(distinct p.product_id) as unique_products,
		max(o.order_date) as order_date_last
from opt_clients as c
INNER JOIN opt_orders as o ON c.id = o.client_id
INNER JOIN opt_products as p ON o.product_id = p.product_id
where c.status = 'active'
group by c.name, c.surname
order by total_orders DESC;




CREATE INDEX idx_client_status ON opt_clients(status);
CREATE INDEX idx_order_client ON opt_orders(client_id);
CREATE INDEX idx_order_product ON opt_orders(product_id);


with cte as (
	select c.name, c.surname, count(o.order_id) as total_orders,
		count(distinct p.product_id) as unique_products,
		max(o.order_date) as order_date_last
	from opt_clients as c
	INNER JOIN opt_orders as o ON c.id = o.client_id
	INNER JOIN opt_products as p ON o.product_id = p.product_id
	where c.status = 'active'
	group by c.name, c.surname
)
select *
from cte
order by total_orders DESC 
limit 10;



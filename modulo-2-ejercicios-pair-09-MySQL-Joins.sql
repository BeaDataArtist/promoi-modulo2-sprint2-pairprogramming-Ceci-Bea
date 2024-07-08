USE northwind;

-- 1. Pedidos por empresa en UK:
	-- Desde las oficinas en UK nos han pedido con urgencia que realicemos una consulta a la base de datos con la que podamos conocer cuántos pedidos ha realizado cada empresa cliente de UK. 
	-- Nos piden el ID del cliente y el nombre de la empresa y el número de pedidos.
    
SELECT c.customer_id, c.company_name, COUNT(o.order_id) AS numpedido
	FROM customers AS c
	INNER JOIN orders AS o ON c.customer_id = o.customer_id
	WHERE c.country = "UK"
	GROUP BY c.customer_id, c.company_name;
      
-- 2. Productos pedidos por empresa en UK por año:
	-- Desde Reino Unido se quedaron muy contentas con nuestra rápida respuesta a su petición anterior y han decidido pedirnos una serie de consultas adicionales. 
    -- La primera de ellas consiste en una query que nos sirva para conocer cuántos objetos ha pedido cada empresa cliente de UK durante cada año.
    -- Nos piden concretamente conocer el nombre de la empresa, el año, y la cantidad de objetos que han pedido. Para ello hará falta hacer 2 joins.
    
SELECT c.company_name,YEAR(o.order_date) AS fecha,SUM(od.quantity) AS total
	FROM customers AS c
    INNER JOIN orders AS o ON c.customer_id = o.customer_id
    INNER JOIN order_details AS od ON o.order_id = od.order_id
	WHERE c.country = 'UK'
	GROUP BY c.company_name, YEAR(o.order_date)
	ORDER BY c.company_name, YEAR(o.order_date);
    
    -- 3. Mejorad la query anterior:
	-- Lo siguiente que nos han pedido es la misma consulta anterior pero con la adición de la cantidad de dinero que han pedido por esa cantidad de objetos, teniendo en cuenta los descuentos, etc. 
    -- Ojo que los descuentos en nuestra tabla nos salen en porcentajes, 15% nos sale como 0.15.
    
SELECT c.company_name,YEAR(o.order_date) AS fecha,SUM(od.quantity) AS total, SUM(od.quantity * od.unit_price * (1 - od.discount)) AS total_dinero -- formula descuento= cantidad x precio unitario x (1- descuento)
	FROM customers AS c
	INNER JOIN orders AS o ON c.customer_id = o.customer_id
	INNER JOIN order_details AS od ON o.order_id = od.order_id
	WHERE c.country = 'UK'
	GROUP BY c.company_name, YEAR(o.order_date)
	ORDER BY c.company_name, YEAR(o.order_date);
    
-- 4. BONUS: Pedidos que ha realizado cada compañía y su fecha:
	-- Después de estas solicitudes desde UK y gracias a la utilidad de los resultados que se han obtenido, 
    -- desde la central nos han pedido una consulta que indique el nombre de cada compañia cliente junto con cada pedido que han realizado y su fecha

SELECT c.company_name, o.order_id, o.order_date
	FROM customers AS c
	INNER JOIN orders AS o ON c.customer_id = o.customer_id
	ORDER BY c.company_name, o.order_date;
    
-- 5. BONUS: Tipos de producto vendidos:
	-- Ahora nos piden una lista con cada tipo de producto que se han vendido, sus categorías, nombre de la categoría y el nombre del producto,
    -- y el total de dinero por el que se ha vendido cada tipo de producto (teniendo en cuenta los descuentos).
	-- Pista Necesitaréis usar 3 joins.
    
SELECT p.category_id, c.category_name, p.product_name, SUM(od.quantity * od.unit_price * (1 - od.discount)) AS ProductSales
	FROM products AS p
		INNER JOIN categories AS c ON p.category_id = c.category_id
		INNER JOIN order_details AS od ON p.product_id = od.product_id
		INNER JOIN orders AS o ON od.order_id = o.order_id
	GROUP BY p.category_id, p.product_name, c.category_name
    ORDER BY p.category_id ASC, p.product_name ASC, c.category_name ASC;
    
-- 6. Qué empresas tenemos en la BBDD Northwind:
	-- Lo primero que queremos hacer es obtener una consulta SQL que nos devuelva el nombre de todas las empresas cliente, los ID de sus pedidos y las fechas.
SELECT c.company_name,o.order_id,o.order_date
	FROM customers c
	INNER JOIN Orders o ON c.customer_id = o.customer_id
	ORDER BY c.company_name, o.order_date;

-- 7. Pedidos por cliente de UK:
	-- Desde la oficina de Reino Unido (UK) nos solicitan información acerca del número de pedidos que ha realizado cada cliente del propio Reino Unido de cara a conocerlos mejor y poder adaptarse al mercado actual. 
    -- Especificamente nos piden el nombre de cada compañía cliente junto con el número de pedidos.
    
SELECT c.company_name AS NombreCliente, COUNT(o.order_id) AS NumeroPedidos
	FROM customers AS c
    INNER JOIN orders AS o ON c.customer_id = o.customer_id
    WHERE c.country = 'UK'
    GROUP BY c.company_name
    ORDER BY NumeroPedidos DESC;
    
-- 8. Empresas de UK y sus pedidos:
	-- También nos han pedido que obtengamos todos los nombres de las empresas cliente de Reino Unido (tengan pedidos o no) junto con los ID de todos los pedidos que han realizado y la fecha del pedido.

SELECT c.company_name,o.order_id,o.order_date
	FROM customers c
	LEFT JOIN orders o ON c.customer_id = o.customer_id
	WHERE c.country = 'UK'
	ORDER BY c.company_name, o.order_date;

-- 9. Empleadas que sean de la misma ciudad:
	-- Ejercicio de SELF JOIN: Desde recursos humanos nos piden realizar una consulta que muestre por pantalla los datos de todas las empleadas y sus supervisoras. 
	-- Concretamente nos piden: la ubicación, nombre, y apellido tanto de las empleadas como de las jefas. Investiga el resultado, ¿sabes decir quién es el director?
    
SELECT e.city AS Ciudad, e.first_name AS NombreEmpleado, e.last_name AS ApellidoEmpleado, j.city AS Ciudad, j.first_name AS NombreJefe, j.last_name AS ApellidoJefe
	FROM employees AS e, eployees AS j
    WHERE e.reports_to = j.employee_id -- No se escriben como SELF JOIN, se indica con el WHERE y en el from pones las dos tablas.
    ORDER BY e.city, e.first_name, e.last_name;
    
-- 10. BONUS: FULL OUTER JOIN
	-- Pedidos y empresas con pedidos asociados o no:
	-- Selecciona todos los pedidos, tengan empresa asociada o no, y todas las empresas tengan pedidos asociados o no. Muestra el ID del pedido, el nombre de la empresa y la fecha del pedido (si existe).
    
    
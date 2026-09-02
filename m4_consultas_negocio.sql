-- Consulta 1
SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) / COUNT(id_venta) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- Consulta 2
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- Consulta 3
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- Consulta 4
WITH totales_por_mes AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM totales_por_mes)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM totales_por_mes
ORDER BY mes;

-- Hallazgos de la pre-entrega 4: 
-- 1. Todas las ventas registradas son de marzo 2024, asi que por ahora no se puede 
--    comparar la evolucion entre meses, se necesitan mas datos cargados. 

-- 2. El producto "Laptop Pro 15" (id_producto 1) es el que mas plata genera, aunque 
--    se vendieron pocas unidades comparado con otros productos mas baratos. 

-- 3. La mayoria de los clientes (4 de 5) volvieron a comprar mas de una vez, lo que 
--    muestra que hay bastante recurrencia en la base de clientes actual.
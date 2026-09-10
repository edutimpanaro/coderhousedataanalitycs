-- Limpieza previa "por si ya se corrio antes"
IF OBJECT_ID('FK_id_region', 'F') IS NOT NULL
    ALTER TABLE clientes DROP CONSTRAINT FK_id_region;
GO

IF COL_LENGTH('clientes', 'id_region') IS NOT NULL
    ALTER TABLE clientes DROP COLUMN id_region;
GO

IF COL_LENGTH('clientes', 'segmento') IS NOT NULL
    ALTER TABLE clientes DROP COLUMN segmento;
GO

IF OBJECT_ID('regiones', 'U') IS NOT NULL
    DROP TABLE regiones;
GO

-- Creación de la tabla de regiones
CREATE TABLE regiones (
	id_region INT PRIMARY KEY,
	nombre_region VARCHAR(50) NOT NULL
);
GO

-- Carga de datos 
INSERT INTO regiones VALUES (1, 'Centro');
INSERT INTO regiones VALUES (2, 'Norte');
INSERT INTO regiones VALUES (3, 'Sur');
GO

-- Vinculación con clientes
ALTER TABLE clientes ADD id_region INT;
GO

ALTER TABLE clientes ADD CONSTRAINT FK_id_region
	FOREIGN KEY (id_region) REFERENCES regiones(id_region);
GO

UPDATE clientes SET id_region = 1 WHERE ciudad IN ('Buenos Aires', 'Córdoba', 'Rosario');
UPDATE clientes SET id_region = 2 WHERE ciudad IN ('Tucumán', 'Salta');
UPDATE clientes SET id_region = 3 WHERE ciudad = 'Mendoza';
GO

-- Segmento de cliente 
ALTER TABLE clientes ADD segmento VARCHAR(50);
GO

UPDATE clientes SET segmento = 'minorista'  WHERE id_cliente IN (1, 3);
UPDATE clientes SET segmento = 'corporativo' WHERE id_cliente IN (2, 5);
UPDATE clientes SET segmento = 'revendedor'  WHERE id_cliente = 4;
GO



-- CONSULTA 1: JOIN principal 
SELECT
	v.fecha_venta                          AS fecha,
	c.id_cliente,
	c.nombre                               AS cliente,
	c.segmento,
	c.ciudad,
	r.nombre_region                        AS region,
	p.nombre_producto                      AS producto,
	cat.nombre_categoria                   AS categoria,
	v.cantidad,
	v.precio_unitario,
	v.cantidad * v.precio_unitario         AS total_venta
FROM ventas v
INNER JOIN clientes c
	ON v.id_cliente = c.id_cliente
INNER JOIN productos p
	ON v.id_producto = p.id_producto
INNER JOIN categorias cat
	ON p.id_categoria = cat.id_categoria
INNER JOIN regiones r
	ON c.id_region = r.id_region
ORDER BY v.fecha_venta;
GO


-- LEFT JOIN
IF NOT EXISTS (SELECT 1 FROM clientes WHERE id_cliente = 6)
    INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro)
    VALUES (6, 'Jorge Medina', 'jorge@mail.com', 'Salta', '2024-04-01');
GO

UPDATE clientes SET id_region = 2, segmento = 'minorista' WHERE id_cliente = 6;
GO

IF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = 7)
    INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo)
    VALUES (7, 'Webcam HD', 2, 45.00, 25, 1);
GO


-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
SELECT
	c.nombre,
	c.email,
	c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
	ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
GO


-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
SELECT
	p.nombre_producto,
	cat.nombre_categoria AS categoria,
	p.precio
FROM productos p
INNER JOIN categorias cat
	ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v
	ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;
GO


WITH ventas_canal AS (
	SELECT
		v.cantidad * v.precio_unitario AS total,
		'Sucursal Centro' AS canal
	FROM ventas v
	INNER JOIN clientes c
		ON v.id_cliente = c.id_cliente
	WHERE c.id_region = 1

	UNION ALL

	SELECT
		v.cantidad * v.precio_unitario AS total,
		'Otras Sucursales' AS canal
	FROM ventas v
	INNER JOIN clientes c
		ON v.id_cliente = c.id_cliente
	WHERE c.id_region <> 1 OR c.id_region IS NULL
)
SELECT
	canal,
	COUNT(*)     AS cantidad_ventas,
	SUM(total)   AS total_ventas
FROM ventas_canal
GROUP BY canal;
GO
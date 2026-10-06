- RetailPro — Proyecto de Análisis de Datos

Este es mi proyecto final del curso de Data Analytics de Coderhouse. Trabajo sobre un caso de negocio inventado, RetailPro, una distribuidora de tecnología que quiere entender por qué le cayeron las visitas de clientes en el último año, y si eso ya se le está notando en las ventas.

-- Qué hay en este repo

- **`Ventas_Tech_DB.sql`** — crea la base de datos desde cero: las tablas de categorías, clientes, productos y ventas, con algunos datos de ejemplo cargados.
- **`m4_consultas_negocio.sql`** — consultas sobre la tabla de ventas sola: evolución mensual, los productos que más venden, y qué clientes volvieron a comprar.
- **`m5_consultas_joins.sql`** — acá cruzo todas las tablas con JOIN, para tener una sola vista con ventas + cliente + producto + categoría. Es la que después uso como fuente de datos en Power BI.
- **`Pipeline_ETL_Timpanaro_Eduardo.pbix`** — el modelo armado en Power BI: limpieza de datos, relaciones entre tablas y las medidas DAX (total de ventas, ventas YTD, comparación interanual, etc).

-- Cómo correrlo

1. Abrí SQL Server Management Studio y corré primero `Ventas_Tech_DB.sql` completo — esto crea la base y carga los datos.
2. Después corré `m4_consultas_negocio.sql` para ver las consultas de análisis.
3. Después `m5_consultas_joins.sql` para las consultas con JOIN (necesita que el paso 1 ya esté hecho).
4. Para la parte de Power BI, abrís directamente el archivo `.pbix` en Power BI Desktop — ya tiene todo el modelo armado adentro.

-- Herramientas que usé

SQL Server para la base y las consultas, Power BI para el modelo y el dashboard. También usé IA (Claude) en partes puntuales del proyecto: para revisar una consulta SQL y ver si tenía algo para mejorar, y para algunos ajustes de documentación — en ambos casos, revisé y validé lo que me sugería antes de usarlo.

-- 1. consulta con filtro y join
-- objetivo: listar el catálogo disponible de una categoría específica.
select 
    p.nombre as producto, 
    p.precio, 
    p.stock,
    c.nombre as categoria
from productos p
join categorias c on p.id_categoria = c.id
where c.nombre = 'ropa y calzado' and p.stock > 0
order by p.precio asc;


-- 2. consulta de agregación
-- objetivo: top ventas.
select 
    p.nombre, 
    sum(dp.total) as total_ingresos_generados,
    sum(dp.cantidad) as unidades_vendidas
from detalles_pedido dp
join productos p on dp.id_producto = p.id
group by p.nombre
order by total_ingresos_generados desc
limit 3;


-- 3. consulta con subconsulta
-- objetivo: encontrar clientes que han gastado más que el promedio de todos los pedidos y sumar el total de sus pedidos.
select 
    c.nombre, 
    sum(p.total) as gasto_total_cliente
from clientes c
join pedidos p on c.id = p.id_cliente
group by c.nombre
having sum(p.total) > (
    select avg(total) from pedidos
);


-- 4. consulta de busqueda de ventas por fecha
-- objetivo: reporte de ventas agrupado por mes.
select 
    to_char(fecha_pedido, 'YYYY-MM') as mes,
    count(id) as cantidad_pedidos,
    sum(total) as ingresos_totales
from pedidos
group by mes
order by mes desc;


-- 5. consulta con left join y filtro de nulos
-- objetivo: identificar productos que nunca se han vendido.
select 
    p.nombre, 
    p.stock,
    count(dp.id) as total_vendido
from productos p
left join detalles_pedido dp on p.id = dp.id_producto
where dp.id is null 
group by p.nombre, p.stock;


-- transacción
-- objetivo: registrar una venta completa asegurando la integridad de los datos.
-- escenario: el cliente 'juan soto' (id=1) compra 1 'smartphone galaxy a54' (id=1).
-- si cualquier paso falla (ej. stock insuficiente), se debe hacer rollback.

begin;

    -- 1. insertar el encabezado del pedido
    insert into pedidos (fecha_pedido, estado, total, id_cliente) 
    values (current_timestamp, 'completado', 320000, 1);

    -- 2. insertar el detalle del pedido
    insert into detalles_pedido (cantidad, total, id_pedido, id_producto) 
    values (1, 320000, (select max(id) from pedidos), 1);

    -- 3. registrar el pago
    insert into pagos (fecha_pago, metodo_pago, id_pedido) 
    values (current_timestamp, 'transferencia', (select max(id) from pedidos));

    -- 4. actualizar el stock del producto (descontar 1 unidad)
    update productos 
    set stock = stock - 1 
    where id = 1;

    -- 5. registrar el movimiento de inventario
    insert into movimiento_inventario (cantidad, tipo_movimiento, id_pedido, id_producto) 
    values (-1, 'venta_cliente', (select max(id) from pedidos), 1);

commit;
-- Creación de categorias y clientes ficticios
insert into categorias (nombre) values
('tecnología'),
('ropa y calzado'),
('libros'),
('hogar y cocina'),
('deportes');

insert into clientes (rut, nombre, correo, direccion) values
('11111111-1', 'juan soto pérez', 'juan.soto@email.cl', 'av. providencia 1234, santiago'),
('22222222-2', 'maría lagos gonzález', 'maria.lagos@email.cl', 'calle valparaíso 567, viña del mar'),
('33333333-3', 'pedro tapia muñoz', 'pedro.tapia@email.cl', 'pasaje los aromos 890, concepción'),
('44444444-k', 'ana rojas silva', 'ana.rojas@email.cl', 'av. alemania 101, temuco'),
('55555555-5', 'carlos díaz castro', 'carlos.diaz@email.cl', 'calle larga 202, arica');


-- creación del catálogo de productos
insert into productos (nombre, precio, descripcion, id_categoria) values
('smartphone galaxy a54', 320000, 'celular gama media 128gb 5g', 1),
('notebook gamer nitro 5', 850000, 'i5 16gb ram rtx 3050', 1),
('audífonos bluetooth noise cancelling', 65000, 'batería larga duración', 1);

insert into productos (nombre, precio, descripcion, id_categoria) values
('jeans levis 501 original', 45000, 'clásico pantalón de mezclilla recto', 2),
('polera básica algodón pack x3', 15000, 'colores negro, blanco, gris', 2),
('zapatillas urbanas blancas', 35000, 'cuero sintético', 2);

insert into productos (nombre, precio, descripcion, id_categoria) values
('el señor de los anillos: la comunidad', 18000, 'edición de bolsillo j.r.r. tolkien', 3),
('hábitos atómicos', 22000, 'james clear, desarrollo personal', 3);

insert into productos (nombre, precio, descripcion, id_categoria) values
('cafetera italiana 6 tazas', 25000, 'aluminio clásico', 4),
('juego de sábanas 2 plazas', 30000, '180 hilos algodón', 4);

insert into productos (nombre, precio, descripcion, id_categoria) values
('pesa rusa 16kg', 40000, 'hierro fundido para crossfit', 5);


-- 3. carga inicial de inventario (simulación de compra a proveedores)

-- compra proveedor tecnologico
begin;
insert into movimiento_inventario (cantidad, tipo_movimiento, id_producto) 
values (50, 'recepcion_proveedor', 1);
update productos set stock = stock + 50 where id = 1;
insert into movimiento_inventario (cantidad, tipo_movimiento, id_producto) 
values (20, 'recepcion_proveedor', 2);
update productos set stock = stock + 20 where id = 2;
insert into movimiento_inventario (cantidad, tipo_movimiento, id_producto) 
values (100, 'recepcion_proveedor', 3);
update productos set stock = stock + 100 where id = 3;

-- compra proveedor vestuario
insert into movimiento_inventario (cantidad, tipo_movimiento, id_producto) 
values (30, 'recepcion_proveedor', 4);
update productos set stock = stock + 30 where id = 4;
insert into movimiento_inventario (cantidad, tipo_movimiento, id_producto) 
values (60, 'recepcion_proveedor', 5);
update productos set stock = stock + 60 where id = 5;

-- compra proveedor literatura
insert into movimiento_inventario (cantidad, tipo_movimiento, id_producto) 
values (5, 'recepcion_proveedor', 7);
update productos set stock = stock + 5 where id = 7;

commit;


-- simulación de ventas:

--- pedido 1: juan soto compra 1 notebook
begin;
insert into pedidos (fecha_pedido, estado, total, id_cliente) 
values (now() - interval '1 month', 'entregado', 850000, 1);
insert into detalles_pedido (cantidad, total, id_pedido, id_producto) 
values (1, 850000, 1, 2);
insert into pagos (fecha_pago, metodo_pago, id_pedido) 
values (now() - interval '1 month', 'credito', 1);
insert into movimiento_inventario (cantidad, tipo_movimiento, id_pedido, id_producto, fecha) 
values (-1, 'venta_cliente', 1, 2, now() - interval '1 month');
update productos set stock = stock - 1 where id = 2;
commit;

-- pedido 2: maría lagos compra ropa.
begin;
insert into pedidos (fecha_pedido, estado, total, id_cliente) 
values (now() - interval '3 weeks', 'entregado', 105000, 2);
insert into detalles_pedido (cantidad, total, id_pedido, id_producto) 
values (2, 90000, 2, 4); -- jeans
insert into detalles_pedido (cantidad, total, id_pedido, id_producto) 
values (1, 15000, 2, 5); -- poleras
insert into pagos (fecha_pago, metodo_pago, id_pedido) values (now() - interval '3 weeks', 'transferencia', 2);
insert into movimiento_inventario (cantidad, tipo_movimiento, id_pedido, id_producto, fecha) 
values (-2, 'venta_cliente', 2, 4, now() - interval '3 weeks');
insert into movimiento_inventario (cantidad, tipo_movimiento, id_pedido, id_producto, fecha) 
values (-1, 'venta_cliente', 2, 5, now() - interval '3 weeks');
update productos set stock = stock - 2 where id = 4;
update productos set stock = stock - 1 where id = 5;
commit;

-- pedido 3: pedro tapia compra 2 libros.
begin;
insert into pedidos (fecha_pedido, estado, total, id_cliente) 
values (now() - interval '2 weeks', 'en_ruta', 36000, 3);
insert into detalles_pedido (cantidad, total, id_pedido, id_producto) 
values (2, 36000, 3, 7);
insert into pagos (fecha_pago, metodo_pago, id_pedido) 
values (now() - interval '2 weeks', 'debito', 3);
insert into movimiento_inventario (cantidad, tipo_movimiento, id_pedido, id_producto, fecha) 
values (-2, 'venta_cliente', 3, 7, now() - interval '2 weeks');
update productos set stock = stock - 2 where id = 7;
commit;

-- pedido 4: maría lagos hace un pedido de audífonos, pero aun no finaliza el pago contraentrega, se hará una actualización.
begin;
insert into pedidos (fecha_pedido, estado, total, id_cliente)
values (now() - interval '1 day', 'completado', 65000, 2);
insert into detalles_pedido (cantidad, total, id_pedido, id_producto)
values (1, 65000, 4, 3);
insert into pagos (fecha_pago, metodo_pago, id_pedido)
values (now() - interval '1 day', 'credito', 4);
insert into movimiento_inventario (cantidad, tipo_movimiento, id_pedido, id_producto, fecha)
values (-1, 'venta_cliente', 4, 3, now() - interval '1 day');
update productos set stock = stock - 1 where id = 3;
commit;

-- simulación de merma.
begin;
insert into movimiento_inventario (cantidad, tipo_movimiento, id_producto, fecha) 
values (-1, 'merma_rotura', 9, now());
update productos set stock = stock - 1 where id = 9;
commit;
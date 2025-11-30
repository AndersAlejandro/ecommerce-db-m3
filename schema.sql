create table clientes (
    id serial primary key,
    rut varchar(12) not null unique,
    nombre varchar(50) not null,
    correo varchar(50) not null unique,
    direccion text not null
);

create table categorias (
    id serial primary key, 
    nombre varchar(50) not null unique
);

create table productos (
    id serial primary key, 
    nombre varchar(100) not null,
    precio int not null check (precio > 0),
    descripcion text,
    stock int not null default 0 check (stock >= 0),
    id_categoria int not null,
    foreign key (id_categoria) references categorias(id) 
);

create table pedidos (
    id serial primary key,
    fecha_pedido timestamp not null default current_timestamp,
    estado varchar(50) not null,
    total int not null check (total >= 0),
    id_cliente int not null,
    foreign key (id_cliente) references clientes(id)
);

create table detalles_pedido (
    id serial primary key,
    cantidad int not null check (cantidad > 0),
    total int not null check (total >= 0),
    id_pedido int not null,
    id_producto int not null,
    foreign key (id_pedido) references pedidos(id),
    foreign key (id_producto) references productos(id)
);

create table pagos (
    id serial primary key,
    fecha_pago timestamp not null default current_timestamp,
    metodo_pago varchar(100) not null,
    id_pedido int not null unique,
    foreign key (id_pedido) references pedidos(id) 
);

create table movimiento_inventario (
    id serial primary key,
    cantidad int not null check (cantidad != 0),
    fecha timestamp not null default current_timestamp,
    tipo_movimiento varchar(50) not null,
    id_pedido int,
    id_producto int not null,
    foreign key (id_pedido) references pedidos(id),
    foreign key (id_producto) references productos(id) 
);

create index idx_productos_nombre on productos(nombre);
create index idx_clientes_nombre on clientes(nombre);
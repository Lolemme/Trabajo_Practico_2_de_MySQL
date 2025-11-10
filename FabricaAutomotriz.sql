create schema FabricaAutomotriz;
use FabricaAutomotriz;

delimiter $$

create procedure insertarautomoviles(
    in p_marca varchar(100),
    in p_modelo varchar(100)
)
begin
    insert into automoviles (marca, modelo)
    values (p_marca, p_modelo);
end$$

delimiter ;


delimiter $$

create procedure insertarcliente(
    in p_nombre varchar(100),
    in p_email varchar(100)
)
begin
    insert into clientes (nombre, email)
    values (p_nombre, p_email);
end$$

delimiter ;
drop procedure insertarcliente;
delimiter $$

create procedure insertarconcesionario(
    in p_nombre varchar(100)
)
begin
    insert into concesionaria (nombre)
    values (p_nombre);
end$$
delimiter ;
drop procedure insertarconcesionario;

delimiter $$

create procedure insertarinsumo(
    in p_nombre_insumo varchar(100),
    in p_marca varchar(100),
    in p_cantidad int,
    in p_precio_unitario int,
    in p_proveedor int
)
begin
    insert into insumos (nombre_insumo, marca, cantidad, precio_unitario, proveedor)
    values (p_nombre_insumo, p_marca, p_cantidad, p_precio_unitario, p_proveedor);
end$$

delimiter $$

create procedure insertarpedido(
    in p_concesionaria int,
    in p_fecha_pedido date
)
begin
    insert into pedidos (concesionaria, fecha_pedido)
    values (p_concesionaria, p_fecha_pedido);
end$$

delimiter ;

drop procedure insertarpedido;

delimiter $$

create procedure insertarpedidodetalle(
    in p_id_pedido int,
    in p_id_modelo int,
    in p_cantidad int
)
begin
    insert into pedido_detalle (id_pedido, id_modelo, cantidad)
    values (p_id_pedido, p_id_modelo, p_cantidad);
end$$

delimiter ;
drop procedure insertarpedidodetalle;
delimiter $$

create procedure insertarproveedor(
    in p_nombre varchar(100)
)
begin
    insert into proveedores (nombre)
    values (p_nombre);
end$$

delimiter ;
drop procedure insertarproveedor;

delimiter $$

create procedure modificarcliente(
    in p_id int,
    in p_nombre varchar(100),
    in p_email varchar(100)
)
begin
    update clientes
    set nombre = p_nombre,
        email = p_email
    where id = p_id;
end$$

delimiter ;

delimiter $$

create procedure modificarconcesionario(
    in p_id_concesionaria int,
    in p_nombre varchar(100)
)
begin
    update concesionaria
    set nombre = p_nombre
    where id_concesionaria = p_id_concesionaria;
end$$

delimiter ;

delimiter $$

create procedure modificarinsumo(
    in p_id_insumo int,
    in p_nombre_insumo varchar(100),
    in p_marca varchar(100),
    in p_cantidad int,
    in p_precio_unitario int,
    in p_proveedor int
)
begin
    update insumos
    set nombre_insumo = p_nombre_insumo,
        marca = p_marca,
        cantidad = p_cantidad,
        precio_unitario = p_precio_unitario,
        proveedor = p_proveedor
    where id_insumo = p_id_insumo;
end$$

delimiter ;

delimiter $$

create procedure modificarpedido(
    in p_id_pedido int,
    in p_concesionaria int,
    in p_fecha_pedido date
)
begin
    update pedidos
    set concesionaria = p_concesionaria,
        fecha_pedido = p_fecha_pedido
    where id_pedido = p_id_pedido;
end$$

delimiter ;

delimiter $$

create procedure modificarpedidodetalle(
    in p_id_pedido int,
    in p_id_modelo int,
    in p_cantidad int
)
begin
    update pedido_detalle
    set cantidad = p_cantidad
    where id_pedido = p_id_pedido
      and id_modelo = p_id_modelo;
end$$

delimiter ;

delimiter $$

create procedure modificarproveedor(
    in p_id_proveedor int,
    in p_nombre varchar(100)
)
begin
    update proveedores
    set nombre = p_nombre
    where id_proveedor = p_id_proveedor;
end$$

delimiter ;

delimiter $$
create procedure InsertarVentas (precio_venta int, cliente int, concesionaria int, automovil int)
begin
insert into ventas (precio_venta, cliente, concesionaria, automovil) values (precio_venta, cliente, concesionaria, automovil);
end$$;
delimiter ;

delimiter $$

create procedure insertarvehiculofabricado(in p_id_pedido int)
begin
    declare v_id_modelo int;
    declare v_cantidad int;
    declare v_contador int default 0;
    declare nueva_patente varchar(10);
    declare existe int default 1;

    select id_modelo, cantidad
    into v_id_modelo, v_cantidad
    from pedido_detalle
    where id_pedido = p_id_pedido
    limit 1;

    while v_contador < v_cantidad do
        set existe = 1;
        while existe = 1 do
            set nueva_patente = concat(
                char(floor(65 + rand() * 26)),
                char(floor(65 + rand() * 26)),
                char(floor(65 + rand() * 26)),
                lpad(floor(rand() * 900 + 100), 3, '0')
            );

            select count(*) into existe
            from vehiculos_fabricados
            where patente = nueva_patente;
        end while;

        insert into vehiculos_fabricados(id_modelo, patente, fecha_entrada, fecha_salida)
        values(v_id_modelo, nueva_patente, now(), date_add(now(), interval 1 day));

        set v_contador = v_contador + 1;
    end while;

    select concat('se insertaron ', v_cantidad, ' vehiculos para el pedido ', p_id_pedido) as resultado;
end$$

delimiter ;
drop procedure insertarvehiculofabricado;

call insertarvehiculofabricado(1);
call insertarvehiculofabricado(2);
select * from vehiculos_fabricados;

-- Procedimiento para insertar el nombre y el email de los clientes
call InsertarCliente('Juan Perez', 'juanperez@gmail.com');
call InsertarCliente('Martina Lopez', 'martinalopez@gmail.com');
call InsertarCliente('Franco Parsino', 'francoparsino@gmail.com');
call InsertarCliente('Alberto Lara', 'albertolara@gmail.com');
call InsertarCliente('Pablo Ruiz', 'pabloruiz@gmail.com');

select * from clientes;

-- Actualizaciones de clientes
call modificarcliente(1, 'Juan P. Perez', 'juanperez@gmail.com');
call modificarcliente(2, 'Martina Lopez', 'martinalopez2000@gmail.com');

-- Eliminaciones de clientes
delete from clientes where id = 4;
delete from clientes where id = 5;

-- Inserciones de proveedores
call InsertarProveedor("Autopartes Industrales S.R.L.");
call InsertarProveedor("Repuestos del Plata S.A.");
call InsertarProveedor("Motores y Componentes S.A.");
call InsertarProveedor("TecnoParts S.R.L.");
call InsertarProveedor("Distribuidora Mecánica del Norte");

select * from proveedores;

-- Eliminaciones de proveedores
delete from proveedores where id_proveedor = 4;
delete from proveedores where id_proveedor = 5;

-----------------------------------------------------------

-- Procedimiento para insertar nombre del concesionario
call InsertarConcesionario("Concesionaria Lopez");
call InsertarConcesionario("Motores Argentinos S.R.L.");
call InsertarConcesionario("Autovisión S.A.");
call InsertarConcesionario("Velocidad Motor Group");
call InsertarConcesionario("Automecánica del Sur");
select * from concesionaria;

-- Actualizaciones de concesionarias
update concesionaria set nombre = "Concesionaria López S.A." where id_concesionaria = 1;
update concesionaria set nombre = "Velocidad Motors" where id_concesionaria = 4;

-- Eliminaciones de concesionarias
delete from concesionaria where id_concesionaria = 2;
delete from concesionaria where id_concesionaria = 5;

-----------------------------------------------------------

-- Procedimiento para insertar la marca y el modelo de un automovil
call InsertarAutomoviles("Toyota", "Hilux");
call InsertarAutomoviles("Renault", "Twingo");
call InsertarAutomoviles("Nissan", "Frontier");
call InsertarAutomoviles("Volkswagen", "Gol");
call InsertarAutomoviles("Volkswagen", "Up");
select * from automoviles;

-- Actualizaciones de automoviles
update automoviles set modelo = "Hilux SRV" where id_automovil = 1;
update automoviles set marca = "VW" where id_automovil = 4;

-- Eliminaciones de automoviles
delete from automoviles where id_automovil = 2;
delete from automoviles where id_automovil = 5;

-----------------------------------------------------------

-- Procedimiento para insertar el nombre, marca, cantidad, precio unitario y proveedor de un insumo
call InsertarInsumo("Filtro de aceite", "Bosch", 50, 1200, 1);
call InsertarInsumo("Pastillas de freno", "Brembo", 80, 4500, 2);
call InsertarInsumo("Batería 12V", "Moura", 30, 32000, 3);
call InsertarInsumo("Neumático 185/65 R15", "Pirelli", 60, 65000, 4);
call InsertarInsumo("Aceite sintético 5W30", "Shell", 100, 9000, 5);
call InsertarInsumo("Amortiguador delantero", "Monroe", 40, 27000, 1);
call InsertarInsumo("Filtro de aire", "Mann", 70, 2500, 2);
call InsertarInsumo("Bujías", "NGK", 200, 1500, 3);
call InsertarInsumo("Correa de distribución", "Gates", 35, 18000, 4);
call InsertarInsumo("Radiador de aluminio", "Valeo", 25, 42000, 5);
select * from insumos;

-- Actualizaciones de insumos
update insumos set cantidad = 75 where id_insumo = 1;
update insumos set precio_unitario = 4700 where id_insumo = 2;

-- Eliminaciones de insumos
delete from insumos where id_insumo = 4;
delete from insumos where id_insumo = 10;

-----------------------------------------------------------

-- Procedimiento para insertar pedidos
call insertarpedido(1, '2024-10-01');
call insertarpedido(2, '2024-10-05');
call insertarpedido(3, '2024-10-09');
call insertarpedido(4, '2024-10-12');
call insertarpedido(5, '2024-10-15');
select * from pedidos;

-- Actualizaciones de pedidos
update pedidos set fecha_pedido = '2024-10-02' where id_pedido = 1;
update pedidos set concesionaria = 3 where id_pedido = 2;

-- Eliminaciones de pedidos
delete from pedidos where id_pedido = 4;
delete from pedidos where id_pedido = 5;

-----------------------------------------------------------

-- Procedimiento para insertar detalles de los pedidos
call insertarpedidodetalle(1, 1, 5);
call insertarpedidodetalle(2, 1, 3);
call insertarpedidodetalle(3, 2, 7);
call insertarpedidodetalle(4, 3, 4);
call insertarpedidodetalle(5, 4, 6);
select * from pedido_detalle;

-- Actualizaciones de detalles
update pedido_detalle set cantidad = 8 where id_pedido = 1 and id_modelo = 1;
update pedido_detalle set cantidad = 5 where id_pedido = 2 and id_modelo = 1;

-- Eliminaciones de detalles
delete from pedido_detalle where id_pedido = 4 and id_modelo = 3;
delete from pedido_detalle where id_pedido = 5 and id_modelo = 4;

-----------------------------------------------------------

-- Procedimiento para insertar el nombre, capacidad mensual y modelo de auto producido por una linea de montaje
call InsertarLineaDeMontaje("Línea A - Hilux", 800, 1);
call InsertarLineaDeMontaje("Línea B - Twingo", 600, 2);
call InsertarLineaDeMontaje("Línea C - Frontier", 700, 3);
call InsertarLineaDeMontaje("Línea D - Gol", 900, 4);
call InsertarLineaDeMontaje("Línea E - Up", 1000, 5);
select * from lineas_de_montaje;

-- Actualizaciones de lineas de montaje
update linea_de_montaje set capacidad_mensual = 85 where id_linea = 1;
update linea_de_montaje set capacidad_mensual = 70 where id_linea = 3;
update linea_de_montaje set capacidad_mensual = 90 where id_linea = 4;

-- Eliminaciones de lineas de montaje
delete from linea_de_montaje where id_linea = 2;
delete from linea_de_montaje where id_linea = 5;

-----------------------------------------------------------

-- Procedimiento para insertar en una venta el precio, cliente, concesionaria y auto
call InsertarVentas(19000000, 2, 3, 1);
call InsertarVentas(10500000, 1, 1, 2);
call InsertarVentas(22000000, 3, 4, 3);
call InsertarVentas(8700000, 4, 5, 4);
call InsertarVentas(9600000, 5, 2, 5);
select * from ventas;

-- Actualizaciones de ventas
update ventas set precio_venta = 19500000 where id_venta = 1;
update ventas set cliente = 3 where id_venta = 2;

-- Eliminaciones de ventas
delete from ventas where id_venta = 4;
delete from ventas where id_venta = 5;

-----------------------------------------------------------

-- Procedimiento para insertar un automovil fabricado usando su ID, fecha de entrada y fecha de salida
call InsertarVehiculoFabricado(1, "2024-10-09 18:30:00", "2024-10-10 12:00:00");
call InsertarVehiculoFabricado(3, "2024-10-11 21:00:00", "2024-10-13 08:20:00");
call InsertarVehiculoFabricado(2, "2024-11-01 16:25:00", "2024-11-02 10:50:00");
call InsertarVehiculoFabricado(4, "2024-11-04 10:40:00", "2024-11-05 12:30:00");
call InsertarVehiculoFabricado(4, "2024-11-18 16:15:00", "2024-11-19 19:55:00");
select * from vehiculos_fabricados;

-- Actualizaciones de vehículos fabricados
update vehiculos_fabricados set fecha_salida = "2024-10-10 14:00:00" where id_fabricado = 1;
update vehiculos_fabricados set id_modelo = 4 where id_fabricado = 2;

-- Eliminaciones de vehículos fabricados
delete from vehiculos_fabricados where id_fabricado = 4;
delete from vehiculos_fabricados where id_fabricado = 5;

-- Tablas principales

create table automoviles(
	id_automovil int primary key auto_increment not null,
    marca varchar(100) not null,
    modelo varchar(100) not null
);
drop table automoviles;

create table clientes(
	id int primary key auto_increment not null,
    nombre varchar(100) not null,
    email varchar(100) not null
);
drop table clientes;

create table concesionaria(
	id_concesionaria int primary key auto_increment not null,
	nombre varchar(45) not null
);
drop table concesionaria;

create table proveedores(
	id_proveedor int primary key auto_increment not null,
	nombre varchar(45) not null
);
drop table proveedores;

create table pedidos(
	id_pedido int auto_increment primary key not null,
    concesionaria int not null,
    fecha_pedido date not null,
    foreign key (concesionaria) references concesionaria(id_concesionaria)
);
drop table pedidos;

create table linea_de_montaje(
	id_linea int primary key auto_increment not null,
    nombre_linea varchar(100) not null,
    capacidad_mensual int not null,
    id_modelo int not null,
    foreign key (id_modelo) references automoviles(id_automovil)
);
drop table linea_de_montaje;

create table estacion_de_trabajo(
	id_estacion int primary key auto_increment not null,
    trabajo_especificado varchar(100) not null,
    linea_de_montaje int not null,
    foreign key (linea_de_montaje) references linea_de_montaje(id_linea)
);
drop table estacion_de_trabajo;

create table vehiculos_fabricados(
	id_fabricado int primary key auto_increment not null,
    id_modelo int not null,
    patente varchar(10) not null unique,
    fecha_entrada datetime,
    fecha_salida datetime,
    foreign key (id_modelo) references automoviles(id_automovil)
);
drop table vehiculos_fabricados;

create table insumos(
	id_insumo int primary key auto_increment not null,
    nombre_insumo varchar(100) not null,
	marca varchar(100) not null,
    cantidad int not null,
	precio_unitario int not null,
	precio_total int as (cantidad * precio_unitario) stored,
    proveedor int,
    foreign key (proveedor) references proveedores(id_proveedor)
);
drop table insumos;


create table ventas(
	id_venta int primary key auto_increment not null,
    precio_venta int not null,
    cliente int,
    concesionaria int,
    automovil int,
    foreign key (cliente) references clientes(id),
    foreign key (concesionaria) references concesionaria(id_concesionaria),
    foreign key (automovil) references automoviles(id_automovil)
);
drop table ventas;

-- Tablas auxiliares 

create table proveedor_insumo (
    id_proveedor int not null,
    id_insumo int not null,
    precio_unitario int not null,
    primary key (id_proveedor, id_insumo),
    foreign key (id_proveedor) references proveedores(id_proveedor),
    foreign key (id_insumo) references insumos(id_insumo)
);
drop table proveedor_insumo;

create table pedidos_proveedor (
    id_pedido int auto_increment primary key,
    id_proveedor int not null,
    fecha_pedido date not null,
    estado varchar(50),
    foreign key (id_proveedor) references proveedores(id_proveedor)
);
drop table pedidos_proveedor;

create table pedidos_proveedor_detalle (
    id_pedido int not null,
    id_insumo int not null,
    cantidad int not null,
    primary key (id_pedido, id_insumo),
    foreign key (id_pedido) references pedidos_proveedor(id_pedido),
    foreign key (id_insumo) references insumos(id_insumo)
);
drop table pedidos_proveedor_detalle;

create table automovil_insumo(
	id_automovil int,
    id_insumo int,
    foreign key (id_automovil) references automoviles(id_automovil),
    foreign key (id_insumo) references insumos(id_insumo)
);
drop table automovil_insumo;

create table pedido_detalle(
    id_pedido int,
    id_modelo int,
    cantidad int not null,
    primary key (id_pedido, id_modelo),
    foreign key (id_pedido) references pedidos(id_pedido),
    foreign key (id_modelo) references automoviles(id_automovil)
);
drop table pedido_detalle;

create table estacion_insumo (
    id_estacion int not null,
    id_insumo int not null,
    cantidad_necesaria int not null,
    primary key (id_estacion, id_insumo),
    foreign key (id_estacion) references estacion_de_trabajo(id_estacion),
    foreign key (id_insumo) references insumos(id_insumo)
);
drop table estacion_insumo;

create table vehiculo_estacion (
    id_vehiculo int not null,
    id_estacion int not null,
    fecha_entrada datetime,
    fecha_salida datetime,
    primary key (id_vehiculo, id_estacion),
    foreign key (id_vehiculo) references vehiculos_fabricados(id_fabricado),
    foreign key (id_estacion) references estacion_de_trabajo(id_estacion)
);
drop table vehiculo_estacion;



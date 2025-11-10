create schema FabricaAutomotriz;
use FabricaAutomotriz;

delimiter $$
create procedure InsertarCliente (nombre varchar(100), email varchar(100))
begin
insert into clientes (nombre, email) values (nombre, email);
end$$;
delimiter ;

delimiter $$

create table InsertarVehiculoFabricado(
    in p_id_modelo int
)
begin
    declare nueva_patente varchar(10);
    declare existe int default 1;

    -- Generar patente hasta que sea única
    while existe = 1 do
        set nueva_patente = CONCAT(
            char(FLOOR(65 + RAND()*26)),  -- letra A-Z
            char(FLOOR(65 + RAND()*26)),
            char(FLOOR(65 + RAND()*26)),
            FLOOR(RAND()*900 + 100)       -- número de 3 dígitos
        );

        select count(*) into existe
        from vehiculos_fabricados
        where patente = nueva_patente;
    end while;

    -- Insertar vehículo
    insert into vehiculos_fabricados(id_modelo, patente, fecha_entrada)
    values(p_id_modelo, nueva_patente, CURDATE());
END$$

DELIMITER ;
call InsertarCliente("Juan Perez", "juanperez@gmail.com");

create table clientes(
	id int primary key auto_increment not null,
    nombre varchar(100) not null,
    email varchar(100) not null
);

select * from clientes;

create table pedidos(
	id_pedido int auto_increment primary key not null,
    concesionaria int not null,
    fecha_pedido date not null,
    foreign key (concesionaria) references concesionaria(id_concesionaria)
);

create table pedido_detalle(
    id_pedido int,
    id_modelo int,
    cantidad int not null,
    primary key (id_pedido, id_modelo),
    foreign key (id_pedido) references pedidos(id_pedido),
    foreign key (id_modelo) references automoviles(id_automovil)
);

create table linea_de_montaje(
	id_linea int primary key auto_increment not null,
    nombre_linea varchar(100) not null,
    capacidad_mensual int not null,
    id_modelo int not null,
    foreign key (id_modelo) references automoviles(id_automovil)
);

create table estacion_de_trabajo(
	id_estacion int primary key auto_increment not null,
    trabajo_especificado varchar(100) not null,
    linea_de_montaje int not null,
    foreign key (linea_de_montaje) references linea_de_montaje(id_linea)
);

create table vehiculos_fabricados(
	id_fabricado int primary key not null,
    id_modelo int not null,
    patente int not null,
    fecha_entrada date not null,
    fecha_salida date not null unique,
    foreign key (id_modelo) references automoviles(id_automovil)
);

create table proveedores(
	id_proveedor int primary key,
	nombre varchar(45) not null
);

create table automoviles(
	id_automovil int primary key not null,
    marca varchar(100) not null,
    modelo varchar(100) not null
);

create table automovil_insumo(
	id_automovil int,
    id_insumo int,
    foreign key (id_automovil) references automoviles(id_automovil),
    foreign key (id_insumo) references insumos(id_insumo)
);

create table insumos(
	id_insumo int primary key,
    nombre_insumo varchar(100) not null,
	marca varchar(100) not null,
    cantidad int not null,
	precio_unitario int not null,
	precio_total int as (cantidad * precio_unitario) stored,
    proveedor int,
    foreign key (proveedor) references proveedores(id_proveedor)
);

create table concesionaria(
	id_concesionaria int primary key,
	nombre varchar(45) not null
);

create table ventas(
	id_venta int primary key,
    precio_venta int not null,
    cliente int,
    concesionaria int,
    automovil int,
    foreign key (cliente) references clientes(id),
    foreign key (concesionaria) references concesionaria(id_concesionaria),
    foreign key (automovil) references automoviles(id_automovil)
);

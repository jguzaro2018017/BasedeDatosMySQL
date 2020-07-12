-- Programador:
-- Joel Alexander Gúzaro Tzunun 2018017 
-- Control de Versiones
-- Creado 25/03/2019
-- Modificaciones
-- 26/03/2019 Agregar Datos
-- 26/03/2019 Crear Procedimientos

Create Database DBConsultas;
USE DBConsultas;

Create Table Categorias (
	categoriaID int not null,
    nombreCategoria varchar(45) not null,
	sueldoBase decimal (6,2) not null,
    bonificacion decimal (6,2) not null,
    bonificacionEmpresa decimal(6,2) not null,
    tipoCategoria varchar(20) not null,
    primary key PK_categoriaID (categoriaID)
);

Create table Regiones(
	regionID int not null,
    nombreRegion varchar(20),
	primary key PK_regionID (regionID)
);

Create table Departamentos (
	departamentoID int not null,
    departamento varchar(20) not null,
    regionID int not null,
    primary key PK_DepartamentoID (departamentoID),
    Constraint FK_Departamentos_Regiones foreign key (regionID) references Regiones(regionID)
);

Create table Oficinas (
	oficinaID int not null,
    direccion varchar(256) not null,
    departamentoID int not null,
    primary key PK_oficinaID (oficinaID),
    Constraint FK_Oficinas_Departamentos foreign key (departamentoID) references Departamentos(departamentoID)
);

Create Table Telefonos (
	telefonoID int not null,
    numeroTelefono varchar(15),
    oficinaID int not null,
    primary key PK_telefonoID (telefonoID),
    Constraint FK_Telefonos_Oficinas foreign key (oficinaID) references Oficinas(oficinaID)
);

Create Table Secciones (
	seccionID int not null,
    nombreSeccion varchar(30) not null,
    oficinaID int not null,
    primary key PK_seccionID (seccionID),
    Constraint FK_Secciones_Oficinas foreign key (oficinaID) references Oficinas(oficinaID)
);

Create Table Empleados (
	empleadoID int not null,
	nombre varchar(45) not null,
    fechaDeNacimiento date not null,
    edad int,
    telefonoPersonal varchar(15) not null,
    fechaDeContratacion date not null,
    categoriaID int not null,
    seccionID int not null,
    primary key PK_empleadoID (empleadoID),
    Constraint FK_Empleados_Categorias foreign key (categoriaID) references Categorias(categoriaID),
    Constraint FK_Empleados_Secciones foreign key (seccionID) references Secciones(seccionID)
);

Delimiter $$
Create Function fn_CalculoEdad (x date) returns int
Reads Sql data deterministic 
	Begin
		declare edad int;
        set edad = (Select timestampdiff(Year,x,curdate()));
        return edad;
    End$$
Delimiter ;

Delimiter $$
Create Procedure sp_AgregarCategoria(IN cateID int, IN nomCat varchar(45),IN sueldoB decimal(6,2), IN bon decimal(6,2),IN bonEm decimal(6,2),IN tipCat varchar(20))
	Begin
		Insert into Categorias(categoriaID, nombreCategoria,sueldoBase,bonificacion,bonificacionEmpresa,tipoCategoria) values (cateID,nomCat,sueldoB,bon,bonEm,tipCat);
    End$$
Delimiter ;

Delimiter $$
Create Procedure sp_AgregarRegion (IN regID int,IN nomReg varchar(20))
	Begin
		Insert into Regiones (regionID,nombreRegion) values (regID,nomReg);
    End$$
Delimiter ;

Delimiter $$
Create Procedure sp_AgregarDepartamento(IN deparID int,IN depar varchar(20),IN regID int)
	Begin
		Insert into Departamentos (departamentoID,departamento,regionID) values (deparID,depar,regID);
    End$$
Delimiter ;

Delimiter $$
Create Procedure sp_AgregarOficina (IN ofiID int,IN dir varchar(256),IN deparID int)
	Begin
		Insert into Oficinas (oficinaID,direccion,departamentoID) values (ofiID,dir,deparID);
    End$$
Delimiter ;

Delimiter $$
Create Procedure sp_AgregarTelefono (IN telID int,IN numTel varchar(15),IN ofiID int)
	Begin
		Insert into Telefonos (telefonoID,numeroTelefono,oficinaID) values (telID,numTel,ofiID); 
    End$$
Delimiter ;

Delimiter $$
Create Procedure sp_AgregarSeccion (IN secID int,IN nomSec varchar(30),IN ofiID int)
	Begin
		Insert into Secciones (seccionID,nombreSeccion,oficinaID) values (secID,nomSec,ofiID);
    End$$
Delimiter ;

Delimiter $$
Create Procedure sp_AgregarEmpleado(IN empleID int, IN nom varchar(45),IN fecNac date, IN telPer varchar(15), IN fecContra date,IN cateID int, IN secID int)
	Begin
		Insert into Empleados (empleadoID,nombre,fechaDeNacimiento,edad,telefonoPersonal,fechaDeContratacion,categoriaID,seccionID) values (empleID,nom,fecNac,fn_CalculoEdad(Empleados.fechaDeNacimiento),telPer,fecContra,cateID,secID);
    End$$
Delimiter ;

Call sp_AgregarRegion (1,'Metropolitana');
Call sp_AgregarRegion (2,'Nororiente');
Call sp_AgregarRegion (3,'Central');
Call sp_AgregarRegion (4,'Norte');
Call sp_AgregarRegion (5,'Suroriente');
Call sp_AgregarRegion (6,'Noroccidente');
Call sp_AgregarRegion (7,'Suroccidente');
Call sp_AgregarRegion (8,'Petén');

Call sp_AgregarDepartamento (1001,'Ciudad de Guatemala',1);
Call sp_AgregarDepartamento (1002,'El Progreso',2);
Call sp_AgregarDepartamento (1003,'Chimaltenango', 3);
Call sp_AgregarDepartamento (1004,'Chiquimula', 2);
Call sp_AgregarDepartamento (1005,'Baja Verapaz', 4);
Call sp_AgregarDepartamento (1006,'Alta Verapaz', 4);
Call sp_AgregarDepartamento (1007,'Santa Rosa', 5);
Call sp_AgregarDepartamento (1008,'Quiche', 6);
Call sp_AgregarDepartamento (1009,'Izabal', 2);
Call sp_AgregarDepartamento (1010,'Retalhuleu',7);
Call sp_AgregarDepartamento (1011,'Zacapa', 2);
Call sp_AgregarDepartamento (1012,'Suchitepequez', 5);
Call sp_AgregarDepartamento (1013,'Peten', 8);
Call sp_AgregarDepartamento (1014,'Jutiapa', 5);
Call sp_AgregarDepartamento (1015,'Huehuetenango',6);

Call sp_AgregarOficina (7001, 'Blv. Los Próceres 13-50 zona 10, Ciudad Capital', 1001);
Call sp_AgregarOficina (7002, '16 Av. 15 calle "A" zona 1, El Progreso', 1002);
Call sp_AgregarOficina (7003, '18 calle zona 3, Chimaltenango', 1003);
Call sp_AgregarOficina (7004, '28 calle zona 4, Chiquimula ', 1004);
Call sp_AgregarOficina (7005, '16 Av. entre 26 y 27 calle zona 5, Baja Verapaz', 1005);
Call sp_AgregarOficina (7006, '11 Avenida, zona 6 Alta Verapaz', 1006);
Call sp_AgregarOficina (7007, '11 Av. y 27 calle zona 7, Santa Rosa', 1007);
Call sp_AgregarOficina (7008, '0 Avenida 11-04 zona 1, Quiche', 1008);
Call sp_AgregarOficina (7009, 'Barrio el Estrecho, Puerto Barrios, Izabal', 1009);
Call sp_AgregarOficina (7010, '8va. Calle final Colonia Concepción Zona 3 Retalhuleu.', 1010);
Call sp_AgregarOficina (7011, 'Calzada Miguel García Granados, Zacapa', 1011);
Call sp_AgregarOficina (7012, 'carretera al pacífico, Cuyotenango, Suchitepéquez', 1012);
Call sp_AgregarOficina (7013, 'Santa Elena de la Cruz, Flores,El Petén', 1013);
Call sp_AgregarOficina (7014, 'KM. 189 CARRETERA A CHAMPERICO ZONA 4 DE Jalapa', 1014);
Call sp_AgregarOficina (7015, '5 Calle 7-96 Zona 1 Huehuetenango', 1015);

Call sp_AgregarTelefono (501,'7589-6523',7001);
Call sp_AgregarTelefono (502,'7485-9623',7002);
Call sp_AgregarTelefono (503,'8594-7859',7003);
Call sp_AgregarTelefono (504,'2659-8456',7004);
Call sp_AgregarTelefono (505,'8597-4859',7005);
Call sp_AgregarTelefono (506,'2598-6421',7006);
Call sp_AgregarTelefono (507,'1526-9854',7007);
Call sp_AgregarTelefono (508,'6958-7485',7008);
Call sp_AgregarTelefono (509,'3659-8264',7009);
Call sp_AgregarTelefono (510,'9586-7485',7010);
Call sp_AgregarTelefono (511,'9658-9325',7011);
Call sp_AgregarTelefono (512,'8596-2358',7012);
Call sp_AgregarTelefono (513,'8597-4826',7013);
Call sp_AgregarTelefono (514,'9568-4752',7014);
Call sp_AgregarTelefono (515,'1023-9586',7015);

Call sp_AgregarSeccion (5001,'Ventas', 7001);
Call sp_AgregarSeccion (5002,'TICS', 7002);
Call sp_AgregarSeccion (5003,'Contabilidad', 7003);
Call sp_AgregarSeccion (5004,'Atención al Cliente', 7004);
Call sp_AgregarSeccion (5005,'Mantenimiento', 7005);
Call sp_AgregarSeccion (5006,'Seguridad', 7006);
Call sp_AgregarSeccion (5007,'Producción', 7007);
Call sp_AgregarSeccion (5008,'Compras', 7008);
Call sp_AgregarSeccion (5009,'Recursos Humanos', 7009);
Call sp_AgregarSeccion (5010,'Marketing',7010);
Call sp_AgregarSeccion (5011,'Administración', 7011);
Call sp_AgregarSeccion (5012,'Finanzas', 7012);
Call sp_AgregarSeccion (5013,'Auditoría', 7013);
Call sp_AgregarSeccion (5014,'Desarrollo', 7014);
Call sp_AgregarSeccion (5015,'Mecánica',7015);

Call sp_AgregarCategoria (4041,'Conserje',2000.09,250.00, 50.00,'Administrativo');
Call sp_AgregarCategoria (4042,'Secretaria', 8296.77,250.00, 300.00,'Administrativo');
Call sp_AgregarCategoria (4043,'Vendedor', 8007.76,250.00, 200.00,'Comercial');
Call sp_AgregarCategoria (4044,'Jefe de sección', 8206.29,250.00, 600.00,'Administrativo');
Call sp_AgregarCategoria (4045,'Recepcionista', 4092.33,250.00, 500.00,'Administrativo');
Call sp_AgregarCategoria (4046,'Contador', 9499.12,250.00, 350.00,'Administrativo');
Call sp_AgregarCategoria (4047,'Técnico', 5978.87,250.00, 300.00,'Administrativo');
Call sp_AgregarCategoria (4048,'Director', 4157.39,250.00, 750.00,'Administrativo');
Call sp_AgregarCategoria (4049,'Recepcionista', 6474.35,250.00,300.00,'Administrativo');
Call sp_AgregarCategoria (4050,'Auditor', 3654.16,250.00, 600.00,'Administrativo');
Call sp_AgregarCategoria (4051,'Programador', 6259.51,250.00, 600.00,'Administrativo');
Call sp_AgregarCategoria (4052,'Mecánico', 7549.52,250.00, 1200.00,'Administrativo');
Call sp_AgregarCategoria (4053,'Diseñador', 7807.12,250.00, 700.00,'Administrativo');
Call sp_AgregarCategoria (4054,'Policía', 2500.7,250.00, 50.00,'Administrativo');
Call sp_AgregarCategoria (4055,'Auxiliar', 5207.79,250.00, 500.00,'Administrativo');

Call sp_AgregarEmpleado (101,'Carny Ferrie Marns Suarez','1995-12-05','6808-4302','2015-12-28',4041,5005);
Call sp_AgregarEmpleado (102,'Felipa Antinia McBrier Ferry','1990-03-11','4950-2900', '2012-01-01',4044,5007);
Call sp_AgregarEmpleado (103,'Alexandra Sofia Bartelli Guzman','1996-05-12','6804-7186', '2008-04-18',4042,5009);
Call sp_AgregarEmpleado (104,'Jose Andres Roskilly Rosales','1992-02-14','6089-9070', '2006-03-16',4043,5001);
Call sp_AgregarEmpleado (105,'Pierson Galileo Perez Gillio','1992-6-15','4934-9837', '2013-08-16',4044,5001);
Call sp_AgregarEmpleado (106,'Jose Pedro Massingberd Zannoti','1994-03-20','1057-8055', '2012-10-13',4044,5002);
Call sp_AgregarEmpleado (107,'Verin Carlo Auditore Calcutt','1992-10-14','0378-6727', '2009-09-30',4048,5002);
Call sp_AgregarEmpleado (108,'Kessi Fry Gozales Fritschel','1970-12-01','0527-1537', '2014-01-06',4047,5002);
Call sp_AgregarEmpleado (109,'Jessica Alejandra Connold Guzman','1972-08-10','6586-2142', '2013-11-17',4044,5003);
Call sp_AgregarEmpleado (110,'Kacie Abigail Doren Abbis','1985-04-12','1512-7957','2008-07-08',4049,5004);
Call sp_AgregarEmpleado (111,'Jose Poul Fawltey Salay','1984-08-15','6822-0089', '2007-09-29',4046,5003);
Call sp_AgregarEmpleado (112,'Terri Isabel Prickly Pridgeon','1980-06-14','1007-4882', '2005-12-21',4048,5003);
Call sp_AgregarEmpleado (113,'Humfrid Jose Budgie Cokly','1980-12-14','4934-6854', '2012-11-24',4044,5004);
Call sp_AgregarEmpleado (114,'Myrta Ana Plowes Jade','1960-07-10','0378-6060','2005-01-05',4054,5006);
Call sp_AgregarEmpleado (115,'Bernardina Olga Juarez Nolda','1970-08-12','6217-5580', '2015-07-07',4044,5006);
Call sp_AgregarEmpleado (116,'Goldie Sadina Dunn Volpe','1990-05-15','4193-6317', '2014-05-29',4042,5007);
Call sp_AgregarEmpleado (117,'Kania Guisela Montenegro Moores','1969-01-15','5545-5578', '2011-11-25',4048,5007);
Call sp_AgregarEmpleado (118,'Drusy Freddy Frostick Avila','1985-09-16','7253-3902', '2014-02-06',4042,5008);
Call sp_AgregarEmpleado (119,'Mead Giancarlo Abadam Casinos','1990-04-18','4508-5318', '2012-01-01',4048,5008);
Call sp_AgregarEmpleado (120,'Carly Anai Mcurdy Batkin','1962-11-15','8982-2262', '2005-09-21',4044,5009);
Call sp_AgregarEmpleado (121,'Manfred Jose Muckle Kennedy','1970-10-12','8769-5506', '2012-03-25',4053,5010);
Call sp_AgregarEmpleado (122,'Jose Kyle Trinke Rougue','1975-06-18','9734-6020', '2013-01-08',4044,5010);
Call sp_AgregarEmpleado (123,'Celesta Valery Gittus Roche','1978-06-19','6121-9681', '2006-03-02',4055,5011);
Call sp_AgregarEmpleado (124,'Peyton Madison Aers Godinez','1978-09-17','2497-9770', '2012-12-16',4044,5011);
Call sp_AgregarEmpleado (125,'Bryan Kristopher Martinez Molina','1975-03-26','9401-9245', '2013-08-16',4046,5012);
Call sp_AgregarEmpleado (126,'Riordan Zacari Akid Matias','1960-12-15','9837-7547', '2010-05-27',4048,5012);
Call sp_AgregarEmpleado (127,'Hirsch Bruno Couch Muss','1962-09-14','99549921', '2007-03-26',4044,5014);
Call sp_AgregarEmpleado (128,'Jose Conor Struijs Satij','1978-08-15','17790641', '2011-06-05',4048,5014);
Call sp_AgregarEmpleado (129,'Ginnifer Sofia Lawrence Cornillot','1975-03-12','43946419', '2013-08-30',4051,5014);
Call sp_AgregarEmpleado (130,'Jose Red Oakey Manrique','1960-02-18','38249248', '2011-03-27',4048,5005);
Call sp_AgregarEmpleado (131,'Javier Alejandro Barahona Pasan','1990-11-13','5563-7813','2010-02-15',4044,5005);
Call sp_AgregarEmpleado (132,'Brandon Tony Rosenfield Vasquez', '1997-04-26', '3992-1162', '2016-01-28',4048,5001);
Call sp_AgregarEmpleado (133,'Britany Luisa Estrada Marisol', '1970-03-23', '4093-0234', '2018-06-07',4048,5004);
Call sp_AgregarEmpleado (134,'Denys Steve Holley Donnan', '1974-12-21', '2756-5999', '2017-09-16',4048,5006);
Call sp_AgregarEmpleado (135,'Rafa Alexander Colo Gonzales', '1989-07-11', '4603-5587', '2016-09-13',4044,5008);
Call sp_AgregarEmpleado (136,'Abygail Jenilee Guyonnet Armas', '1996-03-03', '3857-2699', '2017-05-08',4048,5009);
Call sp_AgregarEmpleado (137,'Peter Adolfo Alfaro Noguera', '1989-01-09', '8088-9644', '2015-11-19',4048,5010);
Call sp_AgregarEmpleado (138,'Olivia Fernanda Quiñones Salazar', '1996-09-16', '2534-1777', '2018-01-19',4048,5011);
Call sp_AgregarEmpleado (139,'Alejandro Emanuel Salazar Barrera', '1970-10-31', '3365-1077', '2018-12-07',4044,5012);
Call sp_AgregarEmpleado (140,'Emmy Andrea Velasquez Avila', '1994-07-03', '3793-4587', '2018-09-28',4050,5013);
Call sp_AgregarEmpleado (141,'Karol Gabriela Fajardo Callen', '1982-03-14', '3949-2949', '2018-11-23',4044,5013);
Call sp_AgregarEmpleado (142,'Jose Adolfo Suarez Acevedo', '1977-02-09', '2223-1010', '2015-08-31',4048,5013);
Call sp_AgregarEmpleado (143,'Joaquin Fernando Williment Lemus', '1994-01-05', '6754-3230', '2017-11-10',4052,5015);
Call sp_AgregarEmpleado (144,'Dina Guisela Valle Carrillo', '1983-05-20', '2308-2261', '2018-01-09',4044,5015);
Call sp_AgregarEmpleado (145,'Brayan Alexander Pineda Prichard', '1990-06-19', '4081-2076', '2017-06-23',4048,5015);

--  Consulta 1 --
Delimiter $$
Create Procedure sp_ListarNombreYEdadEmpleados()
	Begin
		select nombre,edad from Empleados;
	End$$
Delimiter ;

-- Consulta 2 --
Delimiter $$
Create Procedure sp_ListarSalarios()
	Begin
		Select nombre, nombreCategoria,(sueldoBase + (sueldoBase * 0.02)) * (timestampdiff(Year,fechaDeContratacion,curdate())) As SalarioLiquido from Categorias C Inner Join Empleados E ON C.categoriaID = E.categoriaID;
    End$$
Delimiter ;

-- Consulta 3 --
Delimiter $$
Create procedure sp_ListarFechaContratacion()
	Begin
		Select nombre,fechaDeContratacion from Empleados;
	End$$
Delimiter ;

-- Consulta 4 --
Delimiter $$
Create procedure sp_ListarEdadEmpleados()
	Begin
		Select edad from Empleados;
	End$$
Delimiter ;

-- Consulta 5 --
Delimiter $$
Create Procedure sp_ListarEmpleadosParaCadaEdad()
	Begin
		Select edad,count(*) From Empleados Group By edad;
	End$$
Delimiter ;

-- Consulta 6 --
Delimiter $$
Create Procedure sp_ListarEdadMedia()
	Begin
		Select departamento,AVG(edad) As Promedio From Empleados E Inner Join Secciones S on S.seccionID = E.seccionID Inner Join Oficinas O ON O.oficinaID  = S.oficinaID Inner Join Departamentos D ON D.departamentoID = O.departamentoID Group By departamento;
	End$$
Delimiter ;

-- Consulta 7 --
Delimiter $$
Create Procedure sp_ListarCategoriasProfesionales()
	Begin
		Select nombreCategoria, (sueldoBase + bonificacion + bonificacionEmpresa)*14 as sueldoTotal From Categorias Where (sueldoBase + bonificacion + bonificacionEmpresa)*14 > 35000;
    End$$
Delimiter ;
call sp_ListarCategoriasProfesionales();
-- Consulta 8 --
Delimiter $$
Create Procedure sp_ListarEmpleadoEspecifico(IN x INT)
	Begin
		Select empleadoID, nombre, fechaDeNacimiento, edad, telefonoPersonal, fechaDeContratacion, categoriaID, seccionID from Empleados where empleadoID = x;
    End$$
Delimiter ;

-- Consulta 9 --
Delimiter $$
	Create Function fn_Like ( y varchar(256)) returns varchar(256) 
    reads sql data deterministic 
	Begin
			return concat('%', y , '%');
    End$$
Delimiter ;

Delimiter $$
	Create Procedure sp_ListarEmpleadoDepartamento (IN x int, IN y varchar(256))
		Begin
			if y <> ' ' then
				set y = fn_Like(y);
			End if;
				Select empleadoID, nombre, fechaDeNacimiento, edad, telefonoPersonal, fechaDeContratacion, categoriaID, E.seccionID from Departamentos D INNER JOIN Oficinas O ON D.departamentoID = O.departamentoID INNER JOIN Secciones S ON O.OficinaID = S.oficinaID 
					INNER JOIN Empleados E ON S.seccionID = E.seccionID WHERE D.departamentoID = x OR D.departamento like y;
		End$$
Delimiter ;

-- Consulta 10 --
Delimiter $$
	Create Procedure sp_ListarFContratacionEmpleados(IN x year)
    Begin
		Select empleadoID, nombre, fechaDeNacimiento, edad, telefonoPersonal, fechaDeContratacion, categoriaID, seccionID From Empleados where year(fechaDeContratacion) = x;
    End$$
Delimiter ;

-- Consulta 11 --
Delimiter $$
	Create Procedure sp_ListarEmpleadosNoJefes(IN x int)
	Begin
		Select empleadoID, nombre, fechaDeNacimiento, edad, telefonoPersonal, fechaDeContratacion, E.categoriaID, E.seccionID,nombreCategoria,nombreSeccion From Categorias C INNER JOIN Empleados E ON C.categoriaID = E.categoriaID Inner Join Secciones S ON S.seccionID = E.seccionID Where S.seccionID = x AND C.nombreCategoria != 'Jefe de sección';
    End$$
Delimiter ;

-- Consulta  12 --
Delimiter $$
Create Procedure sp_ListarEmpleadosContratadosA(IN x year, IN y year)
Begin
	Select empleadoID, nombre, fechaDeNacimiento, edad, telefonoPersonal, fechaDeContratacion, categoriaID, seccionID From Empleados Where Year(fechaDeContratacion) Between x and y;
End$$
Delimiter ;

-- Consulta 13 --
Delimiter $$
Create procedure sp_ListarCategoriasSueldo()
	Begin
		Select categoriaID,nombreCategoria,(sueldoBase + bonificacion + bonificacionEmpresa)*14 as Sueldo_Total from Categorias where ((sueldoBase + bonificacion + bonificacionEmpresa)*14) < 35000 or ((sueldoBase + bonificacion + bonificacionEmpresa)*14) > 40000;
	End$$
Delimiter ;

-- Consulta 14 -- 
Delimiter $$ 
Create Procedure sp_ListarPuesto()
	Begin
		Select empleadoID, nombre, fechaDeNacimiento, edad, telefonoPersonal, fechaDeContratacion, E.categoriaID, seccionID,nombreCategoria from Categorias C INNER JOIN Empleados E ON C.categoriaID = E.categoriaID WHERE C.nombreCategoria = 'Jefe de Sección' OR C.nombreCategoria = 'Director';
    End$$
Delimiter ;

-- Consulta 15 --
Delimiter $$
Create Procedure sp_ListarJose()
	Begin
		Select empleadoID, nombre, fechaDeNacimiento, edad, telefonoPersonal, fechaDeContratacion, categoriaID, seccionID from Empleados Where nombre like '%Jose%';
	End$$
Delimiter ;


-- Consulta 16 --
Delimiter $$
Create Procedure sp_ListarCategoriaAdministrativo()	
	Begin
		Select tipoCategoria,empleadoID, nombre, fechaDeNacimiento, edad, telefonoPersonal, fechaDeContratacion,E.categoriaID,seccionID From Empleados E Inner Join Categorias C ON C.categoriaID = E.categoriaID Where tipoCategoria = 'Administrativo' AND edad > 35; 
    End$$
Delimiter ;

-- Consulta 17 --
Delimiter $$
Create Procedure sp_ListarEmpleadosQueNoPertenecen(IN x varchar(256))
	Begin
		Select departamento,empleadoID, nombre, fechaDeNacimiento, edad, telefonoPersonal, fechaDeContratacion, categoriaID, E.seccionID From Empleados E Inner Join Secciones S ON 
        S.seccionID = E.seccionID Inner join Oficinas O ON O.oficinaID = S.oficinaID Inner join Departamentos D ON D.departamentoID = O.departamentoID WHERE D.departamento != x;
    End$$
Delimiter ;

-- Consulta 18 --
Delimiter $$
Create procedure sp_EmpleadosOrdenados()
	Begin
		Select nombre,edad from Empleados Order by edad Asc;
    End$$
Delimiter ;

-- Consulta 19 --
Delimiter $$
Create Procedure sp_ListarEmpleadosDescendente()
	Begin
		Select nombre, edad From Empleados ORDER BY nombre DESC;
    End$$
Delimiter ;
 
 -- Consulta 20 --
Delimiter $$
Create procedure sp_EmpleadoYCategoria()
	begin
		select nombre, nombreCategoria FROM Empleados E INNER JOIN Categorias C ON E.categoriaID = C.categoriaID  ;
    end$$
Delimiter ;
 
-- Consulta 21 --
Delimiter $$
Create Procedure sp_ListarCodigoTelefono()
	Begin
	Select telefonoID,numeroTelefono From Telefonos T Inner join Oficinas O ON O.oficinaID = T.oficinaID Inner join Departamentos D ON D.departamentoID = O.departamentoID Inner join Regiones R ON R.regionID = D.regionID WHERE nombreRegion = 'Central';
	End$$
Delimiter ;

-- Consulta 22 --
Delimiter $$
Create Procedure sp_ListarLugarDeTrabajo ()
	Begin
		Select nombre, departamento From Empleados E INNER JOIN Secciones S ON E.seccionID = S.seccionID INNER JOIN Oficinas O ON S.oficinaID = O.oficinaID INNER JOIN Departamentos D ON D.departamentoID = O.departamentoId;
    End$$
Delimiter ;

-- Consulta 23 -- 
Delimiter $$
Create procedure sp_ListarEmpleadoSueldoBonificacion()
	Begin
		Select nombre,sueldoBase,bonificacion,bonificacionEmpresa FROM Empleados E INNER JOIN Categorias C ON E.categoriaID = C.categoriaID;
    End$$
Delimiter ;

-- Consulta 24 --
Delimiter $$
Create Procedure sp_ListarEmpleadosYJefes()
	Begin
		Select nombreSeccion,nombre,nombreCategoria From Categorias C Inner Join Empleados E ON E.categoriaID = C.categoriaID Inner join Secciones S ON S.seccionID = E.seccionID Where C.nombreCategoria != 'Director' Order By S.nombreSeccion Desc; 
    End$$
Delimiter ;

-- Consulta 25 --
Delimiter $$
Create procedure sp_ListarSumadeSueldos ()
	Begin
		Select sum(sueldoBase) as SumaDeSueldos from Categorias;
    End$$
Delimiter ;

-- Consulta 26 --
Delimiter $$
Create Procedure sp_PromedioSueldo()
	Begin
		Select AVG(sueldoBase) as Promedio from Categorias;
    End$$
Delimiter ;

-- Consulta 27 --
Delimiter $$
Create procedure sp_ListarSalarioMaximoYMinimo()
	Begin
		Select MAX(sueldoBase + bonificacion + bonificacionEmpresa) as Sueldo_Maximo,Min(sueldoBase + bonificacion + bonificacionEmpresa) as Sueldo_Minimo From Categorias;
    End$$
Delimiter ;

-- Consulta 28 --
Delimiter $$
Create Procedure sp_ListarEdadesMasCuarenta()
	Begin
		Select COUNT(*) As EmpleadosMayoresA40 From Empleados WHERE edad>40; 
	End $$
Delimiter ;

-- Consulta 29 -- 
Delimiter $$
	Create Procedure sp_ListarEdadesDif()
	Begin
		Select COUNT(distinct edad) FROM empleados; 
	END $$
Delimiter ;

-- Consulta 30 --
Delimiter $$
Create Procedure sp_SumaSueldosDeOficina()
	Begin
		Select departamento,sum(sueldoBase),O.oficinaID From Categorias C Inner Join Empleados E ON C.categoriaID = E.categoriaID Inner join Secciones S ON S.seccionID = E.seccionID Inner join Oficinas O ON O.oficinaID = S.oficinaID Inner join Departamentos D ON D.departamentoID = O.departamentoID Group By oficinaID;
	End$$
Delimiter ;


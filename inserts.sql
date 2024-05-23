INSERT INTO npc.usuarios (rut,nombre,apellido,correo,contrasena,rol_id,is_connect,dv) VALUES
	 (21621035,'admin','admin','admin@admin.cl','admin',2,0,'2');


INSERT INTO npc.tipo_pago (id,descripcion) VALUES
	 (1,'Webpay'),
INSERT INTO npc.marca (id,descripcion) VALUES
	 (1,'Bosch'),
	 (2,'Makita'),
	 (3,'Stanley'),
	 (4,'Sika');

INSERT INTO npc.estado_pedido (id,descripcion) VALUES
	 (1,'Pendiente'),
	 (2,'En preparación'),
	 (3,'Entregado');

INSERT INTO npc.categoria (id,descripcion) VALUES
	 (1,'Herramienta Manual'),
	 (2,'Herramienta Eléctrica'),
	 (3,'Pintura'),
	 (4,'Material Electrico'),
	 (5,'Accesorio'),
	 (6,'Articulo de Seguridad');

INSERT INTO npc.tipo_pago (id,descripcion) VALUES
	 (1,'Webpay'),
	 (2,'Transferencia'),
	 (3,'Efectivo');

INSERT INTO npc.rol (id,descripcion) VALUES
	 (2,'Vendedor'),
	 (3,'Bodeguero'),
	 (4,'Contador'),
	 (5,'Cliente');

INSERT INTO npc.producto (nombre,descripcion,imagen,precio,stock,categoria_id,marca_id) VALUES
	 ('Esmeril angular 9 2200W GA9020','El producto en cuestión destaca por su durabilidad incluso bajo cargas intensas, así como por contar con protección contra el aumento de temperatura y una estructura diseñada para resistir la acumulación de polvo. Además, está construido con engranajes de alta resistencia para garantizar un funcionamiento fiable a lo largo del tiempo. Equipado con un potente motor de alto rendimiento que varía según la tensión de alimentación, ya sea 120V con 1,650W o 220V con 2,200W, este dispositivo ofrece un excelente desempeño en diversas aplicaciones. Además, su empuñadura suave proporciona mayor comodidad y control durante su uso.','puli.png',154000,2,2,2),
	 ('Sikafill Alta Elasticidad Pintura Impermeable Gris 3 Kg','Impermeabilización de muros, losas y cubiertas sobre diversos tipos de soportes: hormigón, morteros, aluminio, fibrocemento, madera, zinc, tejas, ladrillo. Protección de paredes medianeras contra filtraciones de agua. Tratamiento de encuentros en chimeneas, salidas de ductos, pasadas, etc.','pin1.png',30000,4,3,4),
	 ('Set Accesorios Bosch 91 Pc Taladrar y atornillar MS4091','Set Accesorios Bosch 91 Pc Taladrar y Atornillar, 2610038619, el mas completo juego de accesorios de taladrado y atornillado de la linea Bosch, incluye vara telescópica imantada, indispensable en trabajos en zonas de difícil acceso como motores de vehículos, atornillador  con ratchet para un manejo optimo de la herramienta, juegos de brocas para taladrar muro, madera y metal, así como un completo juego de punta de atornillado de diferente tipo así como longitudes.','acce1.png',35000,6,1,1),
	 ('Destornillador Aislado Stanley 1000V 3mm','El destornillador con aislamiento Stanley es una herramienta imprescindible para trabajos eléctricos seguros. Su aislamiento de dos capas protege al usuario de descargas eléctricas, y su punta plana de 3 mm permite aflojar y apretar tornillos de cabeza plana con facilidad.','des1.png',2000,8,1,3),
	 ('EasyDrill 18V-40','Un todoterreno para taladrar y fijar Versátil portabrocas de 13 mm de una sola pieza para cambiar con facilidad brocas y puntas de atornillar. Caja de engranajes de 2 velocidades y 20 niveles de par que proporcionan un par de atornillado y una velocidad de perforación óptimo Ideal para taladrar en madera, metal y plástico y para aplicaciones de atornillado Diseño delgado y ergonómico para un manejo cómodoLuz LED para trabajar en áreas poco iluminadas POWER FOR ALL: una batería y un cargador para todo un sistema de herramientas Home & Garden','deselecbosch.png',65000,7,2,1),
	 ('Casco Protector Combinado','Obtenga el accesorio correcto para sus Sierras de Cadena Makita. El Casco Protector Combinado (986-200-002) incluye protección para cara y oído. El protector para la cara permite buena visibilidad del área de trabajo, y los protectores de oídos son fácilmente ajustables. El diseño liviano está construido para comodidad del operador. Es ideal para usar con las sierras de cadena de Makita. (Nota: las sierras de cadena se venden por separado).','casco1.png',50000,12,1,1),
	 ('Alicate Corte Diagonal 5″ (84-104La)','Es una herramienta manual para agarrar y sujetar pequeñas piezas, dar forma y cortar alambres, cables blandos o duros. Fabricado en acero con mangos con cubierta antideslizante, que proporcionan aislación eléctrica.','ali1.png',11000,5,1,3),
	 ('Cadena para Sierra de 18, 3/8 LP, .050, 62, Contragolpe Bajo','La Cadena para Sierra de 18, 3/8 LP, .050 de Makita (E-18225) es para usarse tanto con la Sierra de Cadena de 18 Inalámbrica XGT® de 40V sin Escobillas como la Sierra de Cadena de 18 Inalámbrica XGT® de 40V (GCU04 y GCU06, ambas se venden por separado). Los indicadores de llenado en la placa superior hace el afilado más fácil. Presenta bajo retroceso de acuerdo con el estándar ANSI B175.1. La E-18225 presenta una cadena de bajo perfil para eficiencia de corte incrementada.','acce2.png',20000,8,5,2),
	 ('Taladro atornillador LXT ®DDF487','Eficiente taladro con motor BL sin escobillas con dos rangos de velocidad para atornillar y taladrar para uso profesional. Par máximo de 40 / 23 Nm. Una herramienta versátil para instaladores, constructores y personal de mantenimiento. Luz LED integrada.','DDF483.png',48000,4,2,2);

INSERT INTO npc.usuarios (rut,nombre,apellido,correo,contrasena,rol_id,is_connect,dv) VALUES
	 (21621035,'admin','admin','admin@admin.cl','admin',1,0,'2');

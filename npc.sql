PGDMP      ,                |            postgres    16.3    16.3 Q    "           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            #           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            $           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            %           1262    5    postgres    DATABASE     {   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Chile.1252';
    DROP DATABASE postgres;
                postgres    false            &           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    4901                        2615    16514    npc    SCHEMA        CREATE SCHEMA npc;
    DROP SCHEMA npc;
                postgres    false            �            1255    16731 ;   insertar_pedido_y_pago(integer, character varying, numeric)    FUNCTION     �  CREATE FUNCTION npc.insertar_pedido_y_pago(user_id integer, numero_orden character varying, monto_total numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    ped_id INTEGER;
BEGIN
    INSERT INTO npc.pedido (fecha_pedido, usuario_id, estado_pedido_id)
    VALUES (to_char(LOCALTIMESTAMP, 'YYYY/MM/DD HH:MI:SS'), user_id, 1)
    RETURNING id INTO ped_id;

    INSERT INTO npc.pago (tipo_pago_id, num_orden, pedido_id, monto)
    VALUES (1, numero_orden, ped_id, monto_total);
END;
$$;
 p   DROP FUNCTION npc.insertar_pedido_y_pago(user_id integer, numero_orden character varying, monto_total numeric);
       npc          postgres    false    7            �            1259    16655    carro    TABLE     �   CREATE TABLE npc.carro (
    id integer NOT NULL,
    productos character varying(100) NOT NULL,
    total integer NOT NULL,
    usuario_id integer NOT NULL
);
    DROP TABLE npc.carro;
       npc         heap    postgres    false    7            �            1259    16666    carro_producto    TABLE     �   CREATE TABLE npc.carro_producto (
    carro_id integer NOT NULL,
    producto_id integer NOT NULL,
    id_1 integer NOT NULL
);
    DROP TABLE npc.carro_producto;
       npc         heap    postgres    false    7            �            1259    16584 	   categoria    TABLE     i   CREATE TABLE npc.categoria (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL
);
    DROP TABLE npc.categoria;
       npc         heap    postgres    false    7            �            1259    16589    estado_pedido    TABLE     m   CREATE TABLE npc.estado_pedido (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL
);
    DROP TABLE npc.estado_pedido;
       npc         heap    postgres    false    7            �            1259    16594    marca    TABLE     e   CREATE TABLE npc.marca (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL
);
    DROP TABLE npc.marca;
       npc         heap    postgres    false    7            �            1259    16713    pago    TABLE     �   CREATE TABLE npc.pago (
    id integer NOT NULL,
    tipo_pago_id integer NOT NULL,
    num_orden character varying NOT NULL,
    pedido_id integer NOT NULL,
    monto integer NOT NULL
);
    DROP TABLE npc.pago;
       npc         heap    postgres    false    7            �            1259    16580    pago_id_seq    SEQUENCE     q   CREATE SEQUENCE npc.pago_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    DROP SEQUENCE npc.pago_id_seq;
       npc          postgres    false    7            �            1259    16712    pago_id_seq1    SEQUENCE     �   CREATE SEQUENCE npc.pago_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE npc.pago_id_seq1;
       npc          postgres    false    7    237            '           0    0    pago_id_seq1    SEQUENCE OWNED BY     6   ALTER SEQUENCE npc.pago_id_seq1 OWNED BY npc.pago.id;
          npc          postgres    false    236            �            1259    16682    pedido    TABLE     �   CREATE TABLE npc.pedido (
    id integer NOT NULL,
    fecha_pedido character varying NOT NULL,
    usuario_id integer NOT NULL,
    estado_pedido_id integer NOT NULL
);
    DROP TABLE npc.pedido;
       npc         heap    postgres    false    7            �            1259    16581    pedido_id_seq    SEQUENCE     s   CREATE SEQUENCE npc.pedido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE npc.pedido_id_seq;
       npc          postgres    false    7            �            1259    16681    pedido_id_seq1    SEQUENCE     �   CREATE SEQUENCE npc.pedido_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE npc.pedido_id_seq1;
       npc          postgres    false    7    233            (           0    0    pedido_id_seq1    SEQUENCE OWNED BY     :   ALTER SEQUENCE npc.pedido_id_seq1 OWNED BY npc.pedido.id;
          npc          postgres    false    232            �            1259    16701    pedido_productos    TABLE     �   CREATE TABLE npc.pedido_productos (
    id integer NOT NULL,
    producto integer NOT NULL,
    cantidad integer NOT NULL,
    pedido_id integer NOT NULL
);
 !   DROP TABLE npc.pedido_productos;
       npc         heap    postgres    false    7            �            1259    16582    pedido_productos_id_seq    SEQUENCE     }   CREATE SEQUENCE npc.pedido_productos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE npc.pedido_productos_id_seq;
       npc          postgres    false    7            �            1259    16700    pedido_productos_id_seq1    SEQUENCE     �   CREATE SEQUENCE npc.pedido_productos_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE npc.pedido_productos_id_seq1;
       npc          postgres    false    235    7            )           0    0    pedido_productos_id_seq1    SEQUENCE OWNED BY     N   ALTER SEQUENCE npc.pedido_productos_id_seq1 OWNED BY npc.pedido_productos.id;
          npc          postgres    false    234            �            1259    16632    productos_id_seq    SEQUENCE     v   CREATE SEQUENCE npc.productos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE npc.productos_id_seq;
       npc          postgres    false    7            �            1259    16636    producto    TABLE     n  CREATE TABLE npc.producto (
    id integer DEFAULT nextval('npc.productos_id_seq'::regclass) NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion character varying(2000) NOT NULL,
    imagen character varying(100) NOT NULL,
    precio integer NOT NULL,
    stock integer NOT NULL,
    categoria_id integer NOT NULL,
    marca_id integer NOT NULL
);
    DROP TABLE npc.producto;
       npc         heap    postgres    false    228    7            �            1259    16599    rol    TABLE     c   CREATE TABLE npc.rol (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL
);
    DROP TABLE npc.rol;
       npc         heap    postgres    false    7            �            1259    16604 	   tipo_pago    TABLE     h   CREATE TABLE npc.tipo_pago (
    id integer NOT NULL,
    descripcion character varying(50) NOT NULL
);
    DROP TABLE npc.tipo_pago;
       npc         heap    postgres    false    7            �            1259    16613    usuarios    TABLE     |  CREATE TABLE npc.usuarios (
    id integer NOT NULL,
    rut integer NOT NULL,
    nombre character varying(40) NOT NULL,
    apellido character varying(40) NOT NULL,
    correo character varying(150) NOT NULL,
    contrasena character varying(50) NOT NULL,
    rol_id integer DEFAULT 5 NOT NULL,
    is_connect integer DEFAULT 0 NOT NULL,
    dv character varying(1) NOT NULL
);
    DROP TABLE npc.usuarios;
       npc         heap    postgres    false    7            �            1259    16583    usuarios_id_seq    SEQUENCE     u   CREATE SEQUENCE npc.usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE npc.usuarios_id_seq;
       npc          postgres    false    7            �            1259    16612    usuarios_id_seq1    SEQUENCE     �   CREATE SEQUENCE npc.usuarios_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE npc.usuarios_id_seq1;
       npc          postgres    false    7    227            *           0    0    usuarios_id_seq1    SEQUENCE OWNED BY     >   ALTER SEQUENCE npc.usuarios_id_seq1 OWNED BY npc.usuarios.id;
          npc          postgres    false    226            W           2604    16716    pago id    DEFAULT     ]   ALTER TABLE ONLY npc.pago ALTER COLUMN id SET DEFAULT nextval('npc.pago_id_seq1'::regclass);
 3   ALTER TABLE npc.pago ALTER COLUMN id DROP DEFAULT;
       npc          postgres    false    236    237    237            U           2604    16685 	   pedido id    DEFAULT     a   ALTER TABLE ONLY npc.pedido ALTER COLUMN id SET DEFAULT nextval('npc.pedido_id_seq1'::regclass);
 5   ALTER TABLE npc.pedido ALTER COLUMN id DROP DEFAULT;
       npc          postgres    false    233    232    233            V           2604    16704    pedido_productos id    DEFAULT     u   ALTER TABLE ONLY npc.pedido_productos ALTER COLUMN id SET DEFAULT nextval('npc.pedido_productos_id_seq1'::regclass);
 ?   ALTER TABLE npc.pedido_productos ALTER COLUMN id DROP DEFAULT;
       npc          postgres    false    235    234    235            Q           2604    16616    usuarios id    DEFAULT     e   ALTER TABLE ONLY npc.usuarios ALTER COLUMN id SET DEFAULT nextval('npc.usuarios_id_seq1'::regclass);
 7   ALTER TABLE npc.usuarios ALTER COLUMN id DROP DEFAULT;
       npc          postgres    false    226    227    227                      0    16655    carro 
   TABLE DATA           >   COPY npc.carro (id, productos, total, usuario_id) FROM stdin;
    npc          postgres    false    230   �Y                 0    16666    carro_producto 
   TABLE DATA           B   COPY npc.carro_producto (carro_id, producto_id, id_1) FROM stdin;
    npc          postgres    false    231   Z                 0    16584 	   categoria 
   TABLE DATA           1   COPY npc.categoria (id, descripcion) FROM stdin;
    npc          postgres    false    221   Z                 0    16589    estado_pedido 
   TABLE DATA           5   COPY npc.estado_pedido (id, descripcion) FROM stdin;
    npc          postgres    false    222   ;Z                 0    16594    marca 
   TABLE DATA           -   COPY npc.marca (id, descripcion) FROM stdin;
    npc          postgres    false    223   XZ                 0    16713    pago 
   TABLE DATA           J   COPY npc.pago (id, tipo_pago_id, num_orden, pedido_id, monto) FROM stdin;
    npc          postgres    false    237   uZ                 0    16682    pedido 
   TABLE DATA           M   COPY npc.pedido (id, fecha_pedido, usuario_id, estado_pedido_id) FROM stdin;
    npc          postgres    false    233   �Z                 0    16701    pedido_productos 
   TABLE DATA           J   COPY npc.pedido_productos (id, producto, cantidad, pedido_id) FROM stdin;
    npc          postgres    false    235   �Z                 0    16636    producto 
   TABLE DATA           g   COPY npc.producto (id, nombre, descripcion, imagen, precio, stock, categoria_id, marca_id) FROM stdin;
    npc          postgres    false    229   �Z                 0    16599    rol 
   TABLE DATA           +   COPY npc.rol (id, descripcion) FROM stdin;
    npc          postgres    false    224   �Z                 0    16604 	   tipo_pago 
   TABLE DATA           1   COPY npc.tipo_pago (id, descripcion) FROM stdin;
    npc          postgres    false    225   [                 0    16613    usuarios 
   TABLE DATA           f   COPY npc.usuarios (id, rut, nombre, apellido, correo, contrasena, rol_id, is_connect, dv) FROM stdin;
    npc          postgres    false    227   #[       +           0    0    pago_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('npc.pago_id_seq', 1, false);
          npc          postgres    false    217            ,           0    0    pago_id_seq1    SEQUENCE SET     8   SELECT pg_catalog.setval('npc.pago_id_seq1', 1, false);
          npc          postgres    false    236            -           0    0    pedido_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('npc.pedido_id_seq', 1, false);
          npc          postgres    false    218            .           0    0    pedido_id_seq1    SEQUENCE SET     :   SELECT pg_catalog.setval('npc.pedido_id_seq1', 1, false);
          npc          postgres    false    232            /           0    0    pedido_productos_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('npc.pedido_productos_id_seq', 1, false);
          npc          postgres    false    219            0           0    0    pedido_productos_id_seq1    SEQUENCE SET     D   SELECT pg_catalog.setval('npc.pedido_productos_id_seq1', 1, false);
          npc          postgres    false    234            1           0    0    productos_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('npc.productos_id_seq', 1, false);
          npc          postgres    false    228            2           0    0    usuarios_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('npc.usuarios_id_seq', 1, false);
          npc          postgres    false    220            3           0    0    usuarios_id_seq1    SEQUENCE SET     <   SELECT pg_catalog.setval('npc.usuarios_id_seq1', 1, false);
          npc          postgres    false    226            h           2606    16659    carro carro_pk 
   CONSTRAINT     I   ALTER TABLE ONLY npc.carro
    ADD CONSTRAINT carro_pk PRIMARY KEY (id);
 5   ALTER TABLE ONLY npc.carro DROP CONSTRAINT carro_pk;
       npc            postgres    false    230            j           2606    16670     carro_producto carro_producto_pk 
   CONSTRAINT     ]   ALTER TABLE ONLY npc.carro_producto
    ADD CONSTRAINT carro_producto_pk PRIMARY KEY (id_1);
 G   ALTER TABLE ONLY npc.carro_producto DROP CONSTRAINT carro_producto_pk;
       npc            postgres    false    231            Y           2606    16588    categoria categoria_pk 
   CONSTRAINT     Q   ALTER TABLE ONLY npc.categoria
    ADD CONSTRAINT categoria_pk PRIMARY KEY (id);
 =   ALTER TABLE ONLY npc.categoria DROP CONSTRAINT categoria_pk;
       npc            postgres    false    221            [           2606    16593    estado_pedido estado_pedido_pk 
   CONSTRAINT     Y   ALTER TABLE ONLY npc.estado_pedido
    ADD CONSTRAINT estado_pedido_pk PRIMARY KEY (id);
 E   ALTER TABLE ONLY npc.estado_pedido DROP CONSTRAINT estado_pedido_pk;
       npc            postgres    false    222            ]           2606    16598    marca marca_pk 
   CONSTRAINT     I   ALTER TABLE ONLY npc.marca
    ADD CONSTRAINT marca_pk PRIMARY KEY (id);
 5   ALTER TABLE ONLY npc.marca DROP CONSTRAINT marca_pk;
       npc            postgres    false    223            p           2606    16720    pago pago_pk 
   CONSTRAINT     G   ALTER TABLE ONLY npc.pago
    ADD CONSTRAINT pago_pk PRIMARY KEY (id);
 3   ALTER TABLE ONLY npc.pago DROP CONSTRAINT pago_pk;
       npc            postgres    false    237            l           2606    16689    pedido pedido_pk 
   CONSTRAINT     K   ALTER TABLE ONLY npc.pedido
    ADD CONSTRAINT pedido_pk PRIMARY KEY (id);
 7   ALTER TABLE ONLY npc.pedido DROP CONSTRAINT pedido_pk;
       npc            postgres    false    233            n           2606    16706 $   pedido_productos pedido_productos_pk 
   CONSTRAINT     j   ALTER TABLE ONLY npc.pedido_productos
    ADD CONSTRAINT pedido_productos_pk PRIMARY KEY (id, pedido_id);
 K   ALTER TABLE ONLY npc.pedido_productos DROP CONSTRAINT pedido_productos_pk;
       npc            postgres    false    235    235            e           2606    16643    producto producto_pk 
   CONSTRAINT     O   ALTER TABLE ONLY npc.producto
    ADD CONSTRAINT producto_pk PRIMARY KEY (id);
 ;   ALTER TABLE ONLY npc.producto DROP CONSTRAINT producto_pk;
       npc            postgres    false    229            _           2606    16603 
   rol rol_pk 
   CONSTRAINT     E   ALTER TABLE ONLY npc.rol
    ADD CONSTRAINT rol_pk PRIMARY KEY (id);
 1   ALTER TABLE ONLY npc.rol DROP CONSTRAINT rol_pk;
       npc            postgres    false    224            a           2606    16608    tipo_pago tipo_pago_pk 
   CONSTRAINT     Q   ALTER TABLE ONLY npc.tipo_pago
    ADD CONSTRAINT tipo_pago_pk PRIMARY KEY (id);
 =   ALTER TABLE ONLY npc.tipo_pago DROP CONSTRAINT tipo_pago_pk;
       npc            postgres    false    225            c           2606    16620    usuarios usuario_pk 
   CONSTRAINT     N   ALTER TABLE ONLY npc.usuarios
    ADD CONSTRAINT usuario_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY npc.usuarios DROP CONSTRAINT usuario_pk;
       npc            postgres    false    227            f           1259    16665 
   carro__idx    INDEX     F   CREATE UNIQUE INDEX carro__idx ON npc.carro USING btree (usuario_id);
    DROP INDEX npc.carro__idx;
       npc            postgres    false    230            u           2606    16671 &   carro_producto carro_producto_carro_fk    FK CONSTRAINT     �   ALTER TABLE ONLY npc.carro_producto
    ADD CONSTRAINT carro_producto_carro_fk FOREIGN KEY (carro_id) REFERENCES npc.carro(id);
 M   ALTER TABLE ONLY npc.carro_producto DROP CONSTRAINT carro_producto_carro_fk;
       npc          postgres    false    4712    230    231            v           2606    16676 )   carro_producto carro_producto_producto_fk    FK CONSTRAINT     �   ALTER TABLE ONLY npc.carro_producto
    ADD CONSTRAINT carro_producto_producto_fk FOREIGN KEY (producto_id) REFERENCES npc.producto(id);
 P   ALTER TABLE ONLY npc.carro_producto DROP CONSTRAINT carro_producto_producto_fk;
       npc          postgres    false    4709    231    229            t           2606    16660    carro carro_usuario_fk    FK CONSTRAINT     u   ALTER TABLE ONLY npc.carro
    ADD CONSTRAINT carro_usuario_fk FOREIGN KEY (usuario_id) REFERENCES npc.usuarios(id);
 =   ALTER TABLE ONLY npc.carro DROP CONSTRAINT carro_usuario_fk;
       npc          postgres    false    230    227    4707            z           2606    16721    pago pago_pedido_fk    FK CONSTRAINT     o   ALTER TABLE ONLY npc.pago
    ADD CONSTRAINT pago_pedido_fk FOREIGN KEY (pedido_id) REFERENCES npc.pedido(id);
 :   ALTER TABLE ONLY npc.pago DROP CONSTRAINT pago_pedido_fk;
       npc          postgres    false    237    4716    233            {           2606    16726    pago pago_tipo_pago_fk    FK CONSTRAINT     x   ALTER TABLE ONLY npc.pago
    ADD CONSTRAINT pago_tipo_pago_fk FOREIGN KEY (tipo_pago_id) REFERENCES npc.tipo_pago(id);
 =   ALTER TABLE ONLY npc.pago DROP CONSTRAINT pago_tipo_pago_fk;
       npc          postgres    false    4705    237    225            w           2606    16690    pedido pedido_estado_pedido_fk    FK CONSTRAINT     �   ALTER TABLE ONLY npc.pedido
    ADD CONSTRAINT pedido_estado_pedido_fk FOREIGN KEY (estado_pedido_id) REFERENCES npc.estado_pedido(id);
 E   ALTER TABLE ONLY npc.pedido DROP CONSTRAINT pedido_estado_pedido_fk;
       npc          postgres    false    222    4699    233            y           2606    16707 +   pedido_productos pedido_productos_pedido_fk    FK CONSTRAINT     �   ALTER TABLE ONLY npc.pedido_productos
    ADD CONSTRAINT pedido_productos_pedido_fk FOREIGN KEY (pedido_id) REFERENCES npc.pedido(id);
 R   ALTER TABLE ONLY npc.pedido_productos DROP CONSTRAINT pedido_productos_pedido_fk;
       npc          postgres    false    235    4716    233            x           2606    16695    pedido pedido_usuario_fk    FK CONSTRAINT     w   ALTER TABLE ONLY npc.pedido
    ADD CONSTRAINT pedido_usuario_fk FOREIGN KEY (usuario_id) REFERENCES npc.usuarios(id);
 ?   ALTER TABLE ONLY npc.pedido DROP CONSTRAINT pedido_usuario_fk;
       npc          postgres    false    4707    227    233            r           2606    16644    producto producto_categoria_fk    FK CONSTRAINT     �   ALTER TABLE ONLY npc.producto
    ADD CONSTRAINT producto_categoria_fk FOREIGN KEY (categoria_id) REFERENCES npc.categoria(id);
 E   ALTER TABLE ONLY npc.producto DROP CONSTRAINT producto_categoria_fk;
       npc          postgres    false    4697    229    221            s           2606    16649    producto producto_marca_fk    FK CONSTRAINT     t   ALTER TABLE ONLY npc.producto
    ADD CONSTRAINT producto_marca_fk FOREIGN KEY (marca_id) REFERENCES npc.marca(id);
 A   ALTER TABLE ONLY npc.producto DROP CONSTRAINT producto_marca_fk;
       npc          postgres    false    223    4701    229            q           2606    16621    usuarios usuario_rol_fk    FK CONSTRAINT     m   ALTER TABLE ONLY npc.usuarios
    ADD CONSTRAINT usuario_rol_fk FOREIGN KEY (rol_id) REFERENCES npc.rol(id);
 >   ALTER TABLE ONLY npc.usuarios DROP CONSTRAINT usuario_rol_fk;
       npc          postgres    false    224    4703    227                  x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �     
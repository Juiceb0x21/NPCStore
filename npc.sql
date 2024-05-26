PGDMP  +    +                |            postgres    16.3    16.3 @               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    5    postgres    DATABASE     {   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Chile.1252';
    DROP DATABASE postgres;
                postgres    false                       0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    4879                        2615    16514    npc    SCHEMA        CREATE SCHEMA npc;
    DROP SCHEMA npc;
                postgres    false            �            1255    16738 ;   insertar_pedido_y_pago(integer, character varying, numeric)    FUNCTION     -  CREATE FUNCTION npc.insertar_pedido_y_pago(user_id integer, numero_orden character varying, monto_total numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    pago_id INTEGER;
	ped_id INTEGER;
BEGIN
	INSERT INTO npc.pago (tipo_pago_id, num_orden, monto)
    VALUES (1, numero_orden, monto_total)
    RETURNING id INTO pago_id;

    INSERT INTO npc.pedido (fecha_pedido, usuario_id, estado_pedido_id, id_pago)
    VALUES (to_char(LOCALTIMESTAMP, 'YYYY/MM/DD HH:MI:SS'), user_id, 1, pago_id)
	RETURNING id INTO ped_id;

	RETURN ped_id;
END ;
$$;
 p   DROP FUNCTION npc.insertar_pedido_y_pago(user_id integer, numero_orden character varying, monto_total numeric);
       npc          postgres    false    7            �            1259    16584 	   categoria    TABLE     i   CREATE TABLE npc.categoria (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL
);
    DROP TABLE npc.categoria;
       npc         heap    postgres    false    7            �            1259    16589    estado_pedido    TABLE     m   CREATE TABLE npc.estado_pedido (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL
);
    DROP TABLE npc.estado_pedido;
       npc         heap    postgres    false    7            �            1259    24613    linea_pedido_id_seq    SEQUENCE     y   CREATE SEQUENCE npc.linea_pedido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE npc.linea_pedido_id_seq;
       npc          postgres    false    7            �            1259    24581    linea_pedido    TABLE     �   CREATE TABLE npc.linea_pedido (
    id integer DEFAULT nextval('npc.linea_pedido_id_seq'::regclass) NOT NULL,
    producto_id integer NOT NULL,
    pedido_id integer NOT NULL,
    cantidad integer NOT NULL,
    usuario_id integer NOT NULL
);
    DROP TABLE npc.linea_pedido;
       npc         heap    postgres    false    231    7            �            1259    16594    marca    TABLE     e   CREATE TABLE npc.marca (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL
);
    DROP TABLE npc.marca;
       npc         heap    postgres    false    7            �            1259    16713    pago    TABLE     �   CREATE TABLE npc.pago (
    id integer NOT NULL,
    tipo_pago_id integer NOT NULL,
    num_orden character varying NOT NULL,
    monto integer NOT NULL
);
    DROP TABLE npc.pago;
       npc         heap    postgres    false    7            �            1259    16712    pago_id_seq1    SEQUENCE     �   CREATE SEQUENCE npc.pago_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE npc.pago_id_seq1;
       npc          postgres    false    228    7                       0    0    pago_id_seq1    SEQUENCE OWNED BY     6   ALTER SEQUENCE npc.pago_id_seq1 OWNED BY npc.pago.id;
          npc          postgres    false    227            �            1259    24616    pedido    TABLE     �   CREATE TABLE npc.pedido (
    id integer NOT NULL,
    fecha_pedido character varying NOT NULL,
    usuario_id integer NOT NULL,
    estado_pedido_id integer NOT NULL,
    id_pago integer NOT NULL
);
    DROP TABLE npc.pedido;
       npc         heap    postgres    false    7            �            1259    24615    pedido_id_seq    SEQUENCE     �   CREATE SEQUENCE npc.pedido_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE npc.pedido_id_seq;
       npc          postgres    false    7    233                       0    0    pedido_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE npc.pedido_id_seq OWNED BY npc.pedido.id;
          npc          postgres    false    232            �            1259    16582    pedido_productos_id_seq    SEQUENCE     }   CREATE SEQUENCE npc.pedido_productos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE npc.pedido_productos_id_seq;
       npc          postgres    false    7            �            1259    16632    productos_id_seq    SEQUENCE     v   CREATE SEQUENCE npc.productos_id_seq
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
       npc         heap    postgres    false    225    7            �            1259    16599    rol    TABLE     c   CREATE TABLE npc.rol (
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
       npc         heap    postgres    false    7            �            1259    16612    usuarios_id_seq1    SEQUENCE     �   CREATE SEQUENCE npc.usuarios_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE npc.usuarios_id_seq1;
       npc          postgres    false    7    224                       0    0    usuarios_id_seq1    SEQUENCE OWNED BY     >   ALTER SEQUENCE npc.usuarios_id_seq1 OWNED BY npc.usuarios.id;
          npc          postgres    false    223            K           2604    16716    pago id    DEFAULT     ]   ALTER TABLE ONLY npc.pago ALTER COLUMN id SET DEFAULT nextval('npc.pago_id_seq1'::regclass);
 3   ALTER TABLE npc.pago ALTER COLUMN id DROP DEFAULT;
       npc          postgres    false    228    227    228            M           2604    24619 	   pedido id    DEFAULT     `   ALTER TABLE ONLY npc.pedido ALTER COLUMN id SET DEFAULT nextval('npc.pedido_id_seq'::regclass);
 5   ALTER TABLE npc.pedido ALTER COLUMN id DROP DEFAULT;
       npc          postgres    false    233    232    233            G           2604    16616    usuarios id    DEFAULT     e   ALTER TABLE ONLY npc.usuarios ALTER COLUMN id SET DEFAULT nextval('npc.usuarios_id_seq1'::regclass);
 7   ALTER TABLE npc.usuarios ALTER COLUMN id DROP DEFAULT;
       npc          postgres    false    224    223    224            �          0    16584 	   categoria 
   TABLE DATA                 npc          postgres    false    218   wE       �          0    16589    estado_pedido 
   TABLE DATA                 npc          postgres    false    219   *F                 0    24581    linea_pedido 
   TABLE DATA                 npc          postgres    false    229   �F       �          0    16594    marca 
   TABLE DATA                 npc          postgres    false    220   �F                 0    16713    pago 
   TABLE DATA                 npc          postgres    false    228   CG       	          0    24616    pedido 
   TABLE DATA                 npc          postgres    false    233   ]G                 0    16636    producto 
   TABLE DATA                 npc          postgres    false    226   wG       �          0    16599    rol 
   TABLE DATA                 npc          postgres    false    221   2P       �          0    16604 	   tipo_pago 
   TABLE DATA                 npc          postgres    false    222   �P                 0    16613    usuarios 
   TABLE DATA                 npc          postgres    false    224   :Q                  0    0    linea_pedido_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('npc.linea_pedido_id_seq', 22, true);
          npc          postgres    false    231                       0    0    pago_id_seq1    SEQUENCE SET     8   SELECT pg_catalog.setval('npc.pago_id_seq1', 41, true);
          npc          postgres    false    227                       0    0    pedido_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('npc.pedido_id_seq', 13, true);
          npc          postgres    false    232                       0    0    pedido_productos_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('npc.pedido_productos_id_seq', 1, false);
          npc          postgres    false    217                       0    0    productos_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('npc.productos_id_seq', 21, true);
          npc          postgres    false    225                       0    0    usuarios_id_seq1    SEQUENCE SET     ;   SELECT pg_catalog.setval('npc.usuarios_id_seq1', 4, true);
          npc          postgres    false    223            O           2606    16588    categoria categoria_pk 
   CONSTRAINT     Q   ALTER TABLE ONLY npc.categoria
    ADD CONSTRAINT categoria_pk PRIMARY KEY (id);
 =   ALTER TABLE ONLY npc.categoria DROP CONSTRAINT categoria_pk;
       npc            postgres    false    218            Q           2606    16593    estado_pedido estado_pedido_pk 
   CONSTRAINT     Y   ALTER TABLE ONLY npc.estado_pedido
    ADD CONSTRAINT estado_pedido_pk PRIMARY KEY (id);
 E   ALTER TABLE ONLY npc.estado_pedido DROP CONSTRAINT estado_pedido_pk;
       npc            postgres    false    219            _           2606    24585    linea_pedido linea_pedido_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY npc.linea_pedido
    ADD CONSTRAINT linea_pedido_pkey PRIMARY KEY (id);
 E   ALTER TABLE ONLY npc.linea_pedido DROP CONSTRAINT linea_pedido_pkey;
       npc            postgres    false    229            S           2606    16598    marca marca_pk 
   CONSTRAINT     I   ALTER TABLE ONLY npc.marca
    ADD CONSTRAINT marca_pk PRIMARY KEY (id);
 5   ALTER TABLE ONLY npc.marca DROP CONSTRAINT marca_pk;
       npc            postgres    false    220            ]           2606    16720    pago pago_pk 
   CONSTRAINT     G   ALTER TABLE ONLY npc.pago
    ADD CONSTRAINT pago_pk PRIMARY KEY (id);
 3   ALTER TABLE ONLY npc.pago DROP CONSTRAINT pago_pk;
       npc            postgres    false    228            a           2606    24623    pedido pedido_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY npc.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (id);
 9   ALTER TABLE ONLY npc.pedido DROP CONSTRAINT pedido_pkey;
       npc            postgres    false    233            [           2606    16643    producto producto_pk 
   CONSTRAINT     O   ALTER TABLE ONLY npc.producto
    ADD CONSTRAINT producto_pk PRIMARY KEY (id);
 ;   ALTER TABLE ONLY npc.producto DROP CONSTRAINT producto_pk;
       npc            postgres    false    226            U           2606    16603 
   rol rol_pk 
   CONSTRAINT     E   ALTER TABLE ONLY npc.rol
    ADD CONSTRAINT rol_pk PRIMARY KEY (id);
 1   ALTER TABLE ONLY npc.rol DROP CONSTRAINT rol_pk;
       npc            postgres    false    221            W           2606    16608    tipo_pago tipo_pago_pk 
   CONSTRAINT     Q   ALTER TABLE ONLY npc.tipo_pago
    ADD CONSTRAINT tipo_pago_pk PRIMARY KEY (id);
 =   ALTER TABLE ONLY npc.tipo_pago DROP CONSTRAINT tipo_pago_pk;
       npc            postgres    false    222            Y           2606    16620    usuarios usuario_pk 
   CONSTRAINT     N   ALTER TABLE ONLY npc.usuarios
    ADD CONSTRAINT usuario_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY npc.usuarios DROP CONSTRAINT usuario_pk;
       npc            postgres    false    224            f           2606    24586 *   linea_pedido linea_pedido_producto_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY npc.linea_pedido
    ADD CONSTRAINT linea_pedido_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES npc.producto(id);
 Q   ALTER TABLE ONLY npc.linea_pedido DROP CONSTRAINT linea_pedido_producto_id_fkey;
       npc          postgres    false    4699    229    226            g           2606    24607 )   linea_pedido linea_pedido_usuario_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY npc.linea_pedido
    ADD CONSTRAINT linea_pedido_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES npc.usuarios(id) NOT VALID;
 P   ALTER TABLE ONLY npc.linea_pedido DROP CONSTRAINT linea_pedido_usuario_id_fkey;
       npc          postgres    false    4697    224    229            e           2606    16726    pago pago_tipo_pago_fk    FK CONSTRAINT     x   ALTER TABLE ONLY npc.pago
    ADD CONSTRAINT pago_tipo_pago_fk FOREIGN KEY (tipo_pago_id) REFERENCES npc.tipo_pago(id);
 =   ALTER TABLE ONLY npc.pago DROP CONSTRAINT pago_tipo_pago_fk;
       npc          postgres    false    4695    228    222            h           2606    24624    pedido pedido_estado_pedido_fk    FK CONSTRAINT     �   ALTER TABLE ONLY npc.pedido
    ADD CONSTRAINT pedido_estado_pedido_fk FOREIGN KEY (estado_pedido_id) REFERENCES npc.estado_pedido(id);
 E   ALTER TABLE ONLY npc.pedido DROP CONSTRAINT pedido_estado_pedido_fk;
       npc          postgres    false    219    233    4689            i           2606    24629    pedido pedido_id_pago_fkey    FK CONSTRAINT     r   ALTER TABLE ONLY npc.pedido
    ADD CONSTRAINT pedido_id_pago_fkey FOREIGN KEY (id_pago) REFERENCES npc.pago(id);
 A   ALTER TABLE ONLY npc.pedido DROP CONSTRAINT pedido_id_pago_fkey;
       npc          postgres    false    228    233    4701            j           2606    24634    pedido pedido_usuario_fk    FK CONSTRAINT     w   ALTER TABLE ONLY npc.pedido
    ADD CONSTRAINT pedido_usuario_fk FOREIGN KEY (usuario_id) REFERENCES npc.usuarios(id);
 ?   ALTER TABLE ONLY npc.pedido DROP CONSTRAINT pedido_usuario_fk;
       npc          postgres    false    224    233    4697            c           2606    16644    producto producto_categoria_fk    FK CONSTRAINT     �   ALTER TABLE ONLY npc.producto
    ADD CONSTRAINT producto_categoria_fk FOREIGN KEY (categoria_id) REFERENCES npc.categoria(id);
 E   ALTER TABLE ONLY npc.producto DROP CONSTRAINT producto_categoria_fk;
       npc          postgres    false    4687    226    218            d           2606    16649    producto producto_marca_fk    FK CONSTRAINT     t   ALTER TABLE ONLY npc.producto
    ADD CONSTRAINT producto_marca_fk FOREIGN KEY (marca_id) REFERENCES npc.marca(id);
 A   ALTER TABLE ONLY npc.producto DROP CONSTRAINT producto_marca_fk;
       npc          postgres    false    226    4691    220            b           2606    16621    usuarios usuario_rol_fk    FK CONSTRAINT     m   ALTER TABLE ONLY npc.usuarios
    ADD CONSTRAINT usuario_rol_fk FOREIGN KEY (rol_id) REFERENCES npc.rol(id);
 >   ALTER TABLE ONLY npc.usuarios DROP CONSTRAINT usuario_rol_fk;
       npc          postgres    false    224    4693    221            �   �   x��ο
�0��Oq[[(�'��[�V���AL�5y(��3ut����k����t��D+B�G'�P��@附'bgKx�.���b]A~�"�bm=B�6���c�$h�?�6�7ya�Tq�[$��E��]�L<ҿ!����v"�s쒑Â�g
��z=a�j��Ms�_      �   v   x���v
Q���W�+H�K-.ILɏ/HM�L�W��L�QHI-N.�,H����Ts�	uV�0�QPH�K�L�+IU״��$� #�A�y
E��E�ə�7�Qb�1ظ���t�r�A\\ ̦H�         
   x���          �   i   x���v
Q���W�+H��M,JNT��L�QHI-N.�,H����Ts�	uV�0�QPw�/N�P״��$Q�P�obvfI"9�����K�rR+��nҞ���� ��J	         
   x���          	   
   x���             �  x��X�n�H��+괶Y#J�#gO��d��8F�8s[��-����&��O�+>�!,|���O�K�U5)���c�dWWW�z��O�.f/������ޥ���ڴG����(5A{[j��\�����A�B���iU���V��W��k��GW������hg��퉷YF��j<���OU.u����J�U*S�W�nii��{e|��W6���J-��*�-JF����.�)*��SьV��b�v-���MUJ��[*뢊VT�|���ӱZ+~f��W�Z�bH7&s�^;Pa�(��n�s����?�*��<�O���[c������o�P�桬l��45*{S ���
�5x�g�6�����Ǫ̬V�	��>��l���8[E_�_�b�Y^��Y;�x����;��NO�Z�u�ds��W:,�Y��B�����ϳ����G���o� �o�*9;��ys�X��4�P�\$��I�?\n�o�^���Q��u�,Vxvx0z��G�%{u�b�>�G��׍���O����''�Ɠ���li5�4�t��a��������Aޥ. �r��G��,o��n�3�pi�0��9���_U�4�4�YާO�N'��e[fl�Al;oB��
��8z)�6�l��LaŌ�S����T�9�Q���D�6��_4i���X!�t��;| :�}F�cG?,p��"������|���	M�]X���e�X����J�i��w7 h&����`0�!D:�o�:�e䀆�<W��|M�X,���}�|�4��Z����v��<V){KA�����,!�(�rs���j]��x�6������&T��6mB�xc뀃� dI�13��c$u�$~���=s�z���F����/���=���$ޘ#�7l��$��\�/jɍo���f8H[�t�"��Ӝ3i8����@#�';��}���5]�K��U�dJ3���a��#W\��ie�H!�{Se��v��
v�-?CJ8�����"C����H�Qe֊w��4 �y��I�#�|��U�ۘV5�{�U��Ŧ��
q���N�0(ƴ,�,�Q�w��JK�K[���l�8�E�=f�Cet�����*2sK	���Q�Kg`}�9W��%M\�e�[���mEj7�&��6�ѕGo(̊�ҧ���m�'^kU��VHM�����ܳ;9���(� BT,Yc-!�e��Ҡ���9�k
x!BM�>Qh��Ϸ�J.�rG/�˄�r�Zq�����p�3����&�[�5����S�HM5��U��B��Ԝ)j��ݲ[6_�Ge)PC��.��7�:o�	ń+����M�D�F�D� 9P]�s+Q��q��:v��{�H���T��<�Ȋ�-�D�f��WT .�2oY���-����
� ���Cp�����j�b5��sW��)��#���c~�Dk�߸��=X�C�	�w��!ʑ7IzВ��q��a��-�gN�R[�Gn	(��A�Eʎ�6E��E���׮$����5'�E�n�L��d�m��1�.$�0E�3��Kr0n��ŵD�Δ��`�P+�����v'��d0��=��oJ�n5�x��0Hi�bD,�1QL��S�$<�?�d��d�Bp����1	��	SɓҦ��Qn�϶����֋����Mc�<�`k),I$#����&�vE,IP�j���F?Lh~ޣ���9x9ZY��4���'�+�s&u�����px��}k+�@\�Q�uLo�_2�S fs�K������G�+��f�I)w�����ǟc����� 2���#'iSM��3}�L���"�Z,����!{�#.�FZ�fQ0؅��Yn�o��-�f�v������&��	�����e4D[\H��Y,��B;˙8�2/s��D�"��	���a��Ʃ��IdĂ�T4m��@oyާ���5]>�u��/ƃ�d�O/�n��x�����0�x���Xefp�umVMj�&�v���(�;���l�;��#ލ�3�3қ��iynF�{��Pr��H=����@4Q���櫶�X�/��4��x_g�绒R�Y���g=.^8E�;T܋G�͝���(�@�� Q�+��v�˞o�㳋�x4��	����+[����[�/~��b�ci��C\
�wn��!3�p�u�ի���t�      �   y   x���v
Q���W�+H�+��Q��L�QHI-N.�,H����Ts�	uV�0�QPwL���S״��$I�PkXj^JjJ~麍����SR�KS��I�n�W�H�� �9��y%� �\\ �)\�      �   o   x���v
Q���W�+H�+�,ȏ/HL�W��L�QHI-N.�,H����Ts�	uV�0�QPOM*H�T״��$�#�	!E�y�i�E�yə��d4�5-5�$�,d '^A$         �   x��O�
�0��{S!�&��^��Ah-T۫�I(�<$j��1'��^vfgv`����1@�w0��y�N���uA`�~;��NB)�-f����,��V�[DΣ��`>ɿ)����!)�⌋��ĵ�&�x�N�1�6Bp��T��Y}�p��^!
��8�D��
�Cʵ��
3cjo�w����q     
PGDMP      
                |            postgres    16.3    16.3 @               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
   TABLE DATA                 npc          postgres    false    218   vE       �          0    16589    estado_pedido 
   TABLE DATA                 npc          postgres    false    219   )F                 0    24581    linea_pedido 
   TABLE DATA                 npc          postgres    false    229   �F       �          0    16594    marca 
   TABLE DATA                 npc          postgres    false    220   \G                 0    16713    pago 
   TABLE DATA                 npc          postgres    false    228   �G       	          0    24616    pedido 
   TABLE DATA                 npc          postgres    false    233   �H                 0    16636    producto 
   TABLE DATA                 npc          postgres    false    226   uI       �          0    16599    rol 
   TABLE DATA                 npc          postgres    false    221   OR       �          0    16604 	   tipo_pago 
   TABLE DATA                 npc          postgres    false    222   �R                 0    16613    usuarios 
   TABLE DATA                 npc          postgres    false    224   WS                  0    0    linea_pedido_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('npc.linea_pedido_id_seq', 10, true);
          npc          postgres    false    231                       0    0    pago_id_seq1    SEQUENCE SET     8   SELECT pg_catalog.setval('npc.pago_id_seq1', 29, true);
          npc          postgres    false    227                       0    0    pedido_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('npc.pedido_id_seq', 1, true);
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
E��E�ə�7�Qb�1ظ���t�r�A\\ ̦H�         �   x���v
Q���W�+H����KM�/HM�L�W��L�Q((�O)M.ɏs�`frb^IfJ"�UZ\�X�	�Ts�	uV�0�Q0"S# Ҵ��E@���"3c�Eƴ��f��4��E`�����E�:
f�h�#C�_�G\\ � �-      �   i   x���v
Q���W�+H��M,JNT��L�QHI-N.�,H����Ts�	uV�0�QPw�/N�P״��$Q�P�obvfI"9�����K�rR+��nҞ���� ��J	           x����
�0E����T(�Gk+�D]D���RZ�ؤ�U��m������l��9����p�X�`��#�'�<�	�>�6*���6�;~�"!��Q&x):h=��&!jUՊ�iS������
��S�pf����̰.r�!�qUZ��#���Z/�gi�p���_;�<�,�q�ݟ�Ld��mC0(�%rQ"��9�z���<����a<y�G�35�x�@0��
�(��f�K���ߨ&�x_\I���,�b=Y      	   x   x���v
Q���W�+H�+HM�L�W��L�QHKM�H����(��&e�ǃdR�KS�R`�̔����|M�0G�P�`Cu##}S}#SCC++#Cu#�����5 r�$�         �  x��X�R�H��+�@��iu7��6`��Ll�m��T�T[Ri�$bി�q��	��8�'�%�2Kj�YGL�_@-���2_�|���˓wWtv~���J*�F׎�m�P銹7	e&ho+m]��-����n$j�?%�Um��[�/^Y(��j�>Lg�O.i{��ֱ�˾�y�2�ij_�e����R:?и(���I���_׮$�K
k��a�	Ԕ����񑂏�.h[fv���WT{5W+������[��`��wa@��#ۙ����T�I�fH�ԄFy�c嗪gP��n)4T5�E�+��W�TT_�V�[)���q���]���[�G^(ms��l�a���*��!\	$�&4�����g���G��c�)=��;�s�K�%C��7�kî�=/�]X>������9U��j���'O%L��l�#VB�f�*�V���v�m�XQd����J�oʥG8WF�эɝf�׎�TZ܊O���N:��0����y��V<����/���/%��T�-�e�yS"���
�r>C��5`�����r`�]0�뽏m0����2�b�ҕ�/��oQ��#���ˬ����q��'�{o�Km��T~_��x�޼}G���vd��g%g'�?�f��-�n��6��W����
C�S�3S�XF���}�bzO@������sk�G��1V)r��ǿ����d7NfjG��)� �M�g�T>�>4+)�� U��8̌j0E�� K���\
��@���3 �&"$:��|D��7��wR�{�|�K�̭�5Rem����
Az�j!��
�Q��X&M%#{߁f@m[G(���K������4�Hh0܃��ˑ+���+C�A�|����f����>Yn�d7=��v���R
������A�����(�0��B�D?�^��+?���[�I�n�%̹5�?v�O��' ��O�Q���D%0������̀n��$ϱO�P.�[��e���Ч�0MV����;�X�s+%�/�	��n��bx��{}_2Ƨ�g�:}�7H።6���h�Io�.��Gm[Kfa5*L[y��4m��)xu�"Vk3�5����ѳB��\	ǻ>]{��tE��z|�fr�R�#�6mKh��a��	VL+���<3���f����M�i���&p�s�I��[�@�~�ј΋����nz5��e�.R��O�q��G�� t	�SNi��B���cq��͙Dc�&mr I��?o������4ՌeA��ܓ�0�MW
��/'��t�//�n��x� ���~
��T��Unp�U_c=mLfJb��� �fE�-��;'\ys�HSf]��_1�XN��!�ʔ�����:.�Y�M3�XFݷ�D�����x�@�&��.����׈�Wb�EQ�-�Gí�{,�
t��UM���&�֟�c,H�D1*��S<���l�zVrW.m� W^�Z�x��h���$�Q����r�0i��H����h��L+���w����54�%Լ�Ђ�Vh�h�L�Џn'����2�(��]�MэO�� U7^�B�D����W 1�p�f���6R4�,���2�7�$���{l�o	|�ם��6d(2VDw8 ��hJQA����R�$��^��86?����j��Y gg�D��;r7DQ��Xk��X)c�\�W-�;��/9'�F~OQ:B�M�J�#dߨ�3J8�r~Fo�\���A=- %����Q��+k��� ����k�����'�����Ro%�"3�1�.$�0I�TMn;��7��~R��
��P�L�>�6��Α�e�mG��.<�!��ʳ��gQ%9}s(���]dlw8�l(�_5�X+��֟3'��-y���t�{pc���q*�]dq�
��6�b]�.P�<B��+,jՀx��v���U��\t|v�q���a ��0�nn�2�}���낹}�j���}K�r5��c轨���;P􈥀�Ĳ9�)S�	N�y^�tN��:cV,��ͩ����O�|k������?nz(QdS�st�g�����r��.�ڄWt���.�^
�%����|���.+"z�V�T0Պٟ/�� e�<)L�%*7����o�ٽB#�}Z+� �������A1����,�V�� ��:�-7�M7�Ж��!��W�ɗ���#M���ݟgG�0�����o7Vq���'�=/;�X� �=���נ'�{��OQt�      �   y   x���v
Q���W�+H�+��Q��L�QHI-N.�,H����Ts�	uV�0�QPwL���S״��$I�PkXj^JjJ~麍����SR�KS��I�n�W�H�� �9��y%� �\\ �)\�      �   o   x���v
Q���W�+H�+�,ȏ/HL�W��L�QHI-N.�,H����Ts�	uV�0�QPOM*H�T״��$�#�	!E�y�i�E�yə��d4�5-5�$�,d '^A$         �   x��O=�0��o��@�..00�(&�����4�i��o�����ww��� m7�A�,[�J�01!��@u����b2�����K�Կ9�-�֜y��L�V�M	F��=.r�C�I	�U���R� ���!j���ĭ%!O�rmB8Ϩ���CQ!3f�V�y^z���Q���q     
from django.test import TestCase
import requests
import json
from datetime import datetime

API_URL = "http://127.0.0.1:5000/api"

class UsersTest(TestCase):
    def test_create_user(self):
        json = {
            "rut": "12345678",
            "dv": 9,
            "nombre": "Test",
            "apellido": "User",
            "correo": "test@example.com",
            "contrasena": "testpassword",
        }

        response = requests.post(f'{API_URL}/users/registro', json=json)
        self.assertTrue(response.status_code == 200)

    def test_get_users(self):
        response = requests.get(f"{API_URL}/users")
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response.json(), list)
        if len(response.json()) > 0:
            user = response.json()[0]
            self.assertIn("id", user)
            self.assertIn("rut", user)
            self.assertIn("dv", user)
            self.assertIn("nombre", user)
            self.assertIn("apellido", user)
            self.assertIn("correo", user)
            self.assertIn("rol_id", user)
            self.assertIn("is_connect", user)

    def test_delete_user(self):
        json = {
            "rut": "12345678",
            "dv": 9,
            "nombre": "Test",
            "apellido": "User",
            "correo": "test@example.com",
            "contrasena": "testpassword",
        }

        response = requests.post(f'{API_URL}/users/registro', json=json)

        user_id = response.json()["id"]
        id_json = {
            'id' : user_id
        }
        response = requests.post(f"{API_URL}/users/delete", json=id_json)
        self.assertEqual(response.status_code, 200)

    def test_update_rol_user(self):
        json = {
            "rut": "12345678",
            "dv": 9,
            "nombre": "Test",
            "apellido": "User",
            "correo": "test@example.com",
            "contrasena": "testpassword",
        }

        response = requests.post(f'{API_URL}/users/registro', json=json)

        user_id = response.json()["id"]
        update_data = {
            "rol_id": 2,
            'id' : user_id
        }
        update_response = requests.post(f"{API_URL}/users/actualizar_rol", json=update_data)
        self.assertEqual(update_response.status_code, 200)

    def test_login_user(self):
        login_data = {
            "correo": "test@example.com",
            "contrasena": "testpassword"
        }
        response = requests.post(f"{API_URL}/users/login", json=login_data)
        self.assertEqual(response.status_code, 200)
        self.assertIn("nombre", response.json())

    def test_logout_user(self):
        login_data = {
            "correo": "test@example.com",
            "contrasena": "testpassword"
        }
        response = requests.post(f"{API_URL}/users/login", json=login_data)
        id = response.json()["id"]
        
        json = {
            "id": id
        }

        logout_response = requests.post(f"{API_URL}/users/logout", json=json)
        self.assertEqual(logout_response.status_code, 200)

class PedidosTest(TestCase):
    def test_create_pedido(self):
        json = {
            "rut": "12345678",
            "dv": 9,
            "nombre": "Test",
            "apellido": "User",
            "correo": "test@example.com",
            "contrasena": "testpassword",
        }

        response = requests.post(f'{API_URL}/users/registro', json=json)

        user_id = response.json()["id"]

        data = {
            "id_usuario": user_id,
            "num_orden": 'TestOrder',
            "monto": 100
        }
        response = requests.post(f"{API_URL}/pedidos/add", json=data)
        self.assertEqual(response.status_code, 200)

    def test_get_pedidos(self):
        response = requests.get(f"{API_URL}/pedidos")
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response.json(), list)
        if len(response.json()) > 0:
            pedido = response.json()[0]
            self.assertIn("id", pedido)
            self.assertIn("tipo_pago", pedido)
            self.assertIn("num_orden", pedido)
            self.assertIn("id_pago", pedido)
            self.assertIn("monto", pedido)
            self.assertIn("fecha_pedido", pedido)
            self.assertIn("id_usuario", pedido)
            self.assertIn("nombre_usuario", pedido)
            self.assertIn("apellido_usuario", pedido)
            self.assertIn("estado_pedido", pedido)

class ProductosTest(TestCase):
    def test_create_producto(self):
        data = {
            "nombre": "Producto de prueba",
            "descripcion": "Este es un producto de prueba",
            "imagen": "url_de_la_imagen",
            "precio": 9.99,
            "stock": 100,
            "categoria": 1,
            "marca": 1
        }
        response = requests.post(f"{API_URL}/productos/add", json=data)
        self.assertEqual(response.status_code, 200)

    def test_get_productos(self):
        response = requests.get(f"{API_URL}/productos")
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response.json(), list)
        if len(response.json()) > 0:
            producto = response.json()[0]
            self.assertIn("id", producto)
            self.assertIn("nombre", producto)
            self.assertIn("descripcion", producto)
            self.assertIn("imagen", producto)
            self.assertIn("precio", producto)
            self.assertIn("stock", producto)
            self.assertIn("categoria", producto)
            self.assertIn("marca", producto)

    def test_delete_producto(self):
        # Primero, crea un producto para luego eliminarlo
        create_data = {
            "nombre": "Producto a eliminar",
            "descripcion": "Este producto será eliminado",
            "imagen": "url_de_la_imagen",
            "precio": 19.99,
            "stock": 50,
            "categoria": 1,
            "marca": 1
        }
        create_response = requests.post(f"{API_URL}/productos/add", json=create_data)
        producto_id = create_response.json()["id"]
        json = {
            'id' : producto_id
        }
        delete_response = requests.post(f"{API_URL}/productos/delete_producto", json=json)
        self.assertEqual(delete_response.status_code, 200)

    def test_update_producto(self):
        # Primero, crea un producto
        create_data = {
            "nombre": "Producto original",
            "descripcion": "Este producto será actualizado",
            "imagen": "url_de_la_imagen",
            "precio": 29.99,
            "stock": 75,
            "categoria": 1,
            "marca": 1
        }
        create_response = requests.post(f"{API_URL}/productos/add", json=create_data)
        producto_id = create_response.json()["id"]
        
        # Luego, actualiza el producto
        update_data = {
            "nombre": "Producto actualizado",
            "descripcion": "Este producto será actualizado",
            "imagen": "url_de_la_imagen",
            "precio": 39.99,
            "stock": 100,
            "categoria_id": 1,
            "marca_id": 1,
            "id" : producto_id
        }
        update_response = requests.post(f"{API_URL}/productos/actualizar_producto", json=update_data)
        self.assertEqual(update_response.status_code, 200)
import json
from django.test import TestCase, Client
from django.urls import reverse
from unittest.mock import patch
import requests

class ViewsTest(TestCase):
    
    def setUp(self):
        self.client = Client()
        self.producto_json = """{
            "id": 1,
            "nombre": "Producto de prueba",
            "imagen": "puli.png",
            "precio": 100,
            "stock": 10,
            "marca": "Marca",
            "categoria": "Categoria",
            "descripcion": "Descripción del producto"
        }"""

        self.producto_dict = json.loads(self.producto_json)


    def test_detail_producto(self):

        mock_response_json = json.dumps([self.producto_dict])

        with patch('core.views.requests.post') as mock_post:

            mock_post.return_value.status_code = 200
            mock_post.return_value.json.return_value = json.loads(mock_response_json)

            url = reverse('detalleProducto', args=[self.producto_dict['id']])
            response = self.client.get(url)

            self.assertEqual(response.status_code, 200)
            self.assertTemplateUsed(response, 'core/detail.html')

            self.assertContains(response, self.producto_dict['nombre'])
            self.assertContains(response, str(self.producto_dict['precio']))
            self.assertContains(response, self.producto_dict['marca'])
            self.assertContains(response, self.producto_dict['categoria'])
            self.assertContains(response, self.producto_dict['descripcion'])
        


    def test_index_success(self):
        mock_productos = [
            {'id': 1, 'nombre': 'Producto 1', 'precio': 100, 'stock': 5},
            {'id': 2, 'nombre': 'Producto 2', 'precio': 150, 'stock': 0},
            {'id': 3, 'nombre': 'Producto 3', 'precio': 200, 'stock': 3},
            {'id': 4, 'nombre': 'Producto 4', 'precio': 250, 'stock': 8},
        ]
        mock_response_json = mock_productos

        with patch('core.views.requests.get') as mock_get:
            mock_get.return_value.status_code = 200
            mock_get.return_value.json.return_value = mock_response_json

            url = reverse('index')
            response = self.client.get(url)

            self.assertEqual(response.status_code, 200)
            self.assertTemplateUsed(response, 'core/index.html')

            for producto in mock_productos[:4]:  
                self.assertContains(response, producto['nombre'])
                self.assertContains(response, str(producto['precio']))
                self.assertContains(response, f'Stock: ({producto["stock"]})')

    def test_index_no_products(self):
        mock_response_json = []
        with patch('core.views.requests.get') as mock_get:
            mock_get.return_value.status_code = 200
            mock_get.return_value.json.return_value = mock_response_json

            url = reverse('index')
            response = self.client.get(url)

            self.assertEqual(response.status_code, 200)
            self.assertTemplateUsed(response, 'core/index.html')

            self.assertContains(response, 'No hay productos disponibles')

    def test_login_render(self):
        url = reverse('login')
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, 'core/login.html')

    def test_contact_render(self):
        url = reverse('contact')
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, 'core/contact.html')

    def test_shop_render(self):
        url = reverse('productos')
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, 'core/shop.html')


from django.http import HttpResponse
from django.shortcuts import render, redirect
from .models import *
from django.contrib.auth import authenticate, login
from .forms import loginForm
from django.contrib.auth.models import User
from django.contrib.auth import logout
import requests
import json
from django.core.paginator import Paginator
import random
import string
from transbank.webpay.webpay_plus.transaction import Transaction
from transbank.common.options import WebpayOptions
from transbank.common.integration_commerce_codes import IntegrationCommerceCodes
from transbank.common.integration_api_keys import IntegrationApiKeys
from transbank.common.integration_type import IntegrationType
from carro import context_processor
from django.http import HttpResponse
from django.shortcuts import render, redirect
from requests.exceptions import RequestException, HTTPError


def index(request):
    try:
        response = requests.get('http://127.0.0.1:5000/api/productos')
        response.raise_for_status() 
        data = response.json()
        context = {'productos': data[:4]} 
    except requests.exceptions.RequestException as e:
        context = {'error': f'No se pudo obtener los productos: {e}'}
    
    return render(request, 'core/index.html', context)
    

def login(request):
    if request.method == 'POST':
        form = loginForm(data=request.POST)
        if form.is_valid():
            json = {
                'correo': form.cleaned_data['correo'], 
                'contrasena': form.cleaned_data['contrasena']
            }
            response = requests.post('http://127.0.0.1:5000/api/users/login', json=json)
            if response.status_code == 200:
                data = response.json()
                try:
                    if data['is_connect'] == 1:
                        request.session['user_data'] = data
                        return redirect('index')
                except Exception as e:
                    print(f"Error al autenticar al usuario: {e}")

    else:
        form = loginForm()

    return render(request, 'core/login.html', {'form': form})

def obtener_productos():
    try:
        response = requests.get('http://127.0.0.1:5000/api/productos')
        response.raise_for_status()  # Lanzar una excepción para errores de solicitud
        return response.json()
    except requests.exceptions.RequestException as e:
        
        print(f'Error al obtener los productos: {str(e)}')
        return None

def productos(request):
    productos = obtener_productos()
    categoria = request.GET.get('categoria', '')
    marca = request.GET.get('marca', '')
    busqueda = request.GET.get('busqueda', '')

    if productos:
        if categoria:
            productos = [p for p in productos if p['categoria'] == categoria]
        if marca:
            productos = [p for p in productos if p['marca'] == marca]
        if busqueda:
            productos = [p for p in productos if busqueda.lower() in p['nombre'].lower()]

        return render(request, 'core/shop.html', {'productos': productos})
    else:
        return render(request, 'core/shop.html', {'error': 'No se pudo obtener los productos'})

def carrito(request):
    random_order = ''.join(random.choices(string.ascii_lowercase + string.digits, k=8))
    random_session = ''.join(random.choices(string.ascii_lowercase + string.digits, k=10))  

    response = redirect('index')
    if context_processor.importe_total_carro(request)['importe_total_carro'] > 0:

        buy_order = "ordenCompra" + random_order
        session_id = "sesion" + random_session
        return_url = 'http://127.0.0.1:8000/'
        amount = context_processor.importe_total_carro(request)['importe_total_carro']

        tx = Transaction(WebpayOptions(IntegrationCommerceCodes.WEBPAY_PLUS, IntegrationApiKeys.WEBPAY, IntegrationType.TEST))

        resp = tx.create(buy_order, session_id, amount, return_url)


        context = {'transaccion': resp}

    

        return render(request, 'core/cart.html', context)
    return render(request, 'core/cart.html')


def actualizar_producto(request, producto_id):
    print(f'Producto ID recibido: {producto_id}')  # Para depuración
    if request.method == 'POST':
        # Obtener los datos del formulario
        json = {
            'id' : producto_id,
            'categoria' : request.POST.get('categoria'),
            'descripcion' : request.POST.get('descripcion'),
            'imagen' : request.POST.get('imagen'),
            'marca' : request.POST.get('marca'),
            'nombre' : request.POST.get('nombre'),
            'precio' : request.POST.get('precio'),
            'stock' : request.POST.get('stock')
        }
        try:
            response = requests.post('http://127.0.0.1:5000/api/productos/actualizar_productos', json)
            
            if response.raise_for_status() == 200:
                return redirect('index')

        except (HTTPError, RequestException) as e:
            error_message = f'Error al obtener los productos: {str(e)}'
            print(json)
            return HttpResponse(f'<html><body><p>{error_message}</p></body></html>', status=500)

        return redirect('index')

    else:
        producto = obtener_producto_por_id(producto_id)
        if producto is None:
            error_message = 'El producto no se encuentra.'
            return HttpResponse(f'<html><body><p>{error_message}</p></body></html>', status=404)

        # Renderizar el contenido directamente
        return render(request, 'core/actualizar_producto.html', {'producto': producto})



def obtener_producto_por_id(producto_id):
    try:
        response = requests.get('http://127.0.0.1:5000/api/productos')
        response.raise_for_status()
        productos = response.json()
        for producto in productos:
            if producto['id'] == producto_id:
                return producto
        return None
    except (HTTPError, RequestException) as e:
        print(f'Error al obtener el producto: {str(e)}')
        return None

def detalleProducto(request, producto_id):
    json = {
        'id' : producto_id
    }
    response = requests.post('http://127.0.0.1:5000/api/productos/getbyid', json=json)
    if response.status_code == 200:
        data = response.json() 
    producto = data[0]
    context = {'producto': producto}
    return render (request, 'core/detail.html', context)

def logout(request, producto_id):
    json = {
        'id' : producto_id
    }
    response = requests.post('http://127.0.0.1:5000/api/users/logout', json=json)
    if response.status_code == 200:
        del request.session['user_data']
        return redirect('index')
    

def bodeguero(request):
    try:
        response = requests.get('http://127.0.0.1:5000/api/pedidos')
        response.raise_for_status()
        pedidos = response.json()
        context = {'pedidos': pedidos}
    except requests.exceptions.RequestException as e:
        context = {'error': f'No se pudo obtener las órdenes: {e}'}

    return render(request, 'core/bodeguero.html', context)


def contador(request):
    try:
        response = requests.get('http://127.0.0.1:5000/api/pagos')
        response.raise_for_status()
        pagos = response.json()
        context = {'pagos': pagos}
    except requests.exceptions.RequestException as e:
        context = {'error': f'No se pudo obtener los pagos: {e}'}

    return render(request, 'core/contador.html', context)
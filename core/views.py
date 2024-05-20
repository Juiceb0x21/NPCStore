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
                if data['is_connect'] == 1:
                    request.session['user_data'] = data
                    return redirect('index')
                else:
                    print("xd")

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
    if request.method == 'POST':
        # Obtener los datos del formulario
        categoria = request.POST.get('categoria')
        descripcion = request.POST.get('descripcion')
        imagen = request.POST.get('imagen')
        marca = request.POST.get('marca')
        nombre = request.POST.get('nombre')
        precio = request.POST.get('precio')
        stock = request.POST.get('stock')

        # Enviar la solicitud PUT a la API para actualizar el producto
        json_data = {
            'categoria': categoria,
            'descripcion': descripcion,
            'imagen': imagen,
            'marca': marca,
            'nombre': nombre,
            'precio': precio,
            'stock': stock
        }

        try:
            response = requests.put(f'http://127.0.0.1:5000/api/productos/{producto_id}', json=json_data)
            response.raise_for_status()  
        except requests.exceptions.RequestException as e:
            return render(request, 'actualizar_producto.html', {'error': f'Error al actualizar el producto: {str(e)}'})

        if response.status_code == 200:
            # Producto actualizado correctamente
            return redirect('index')
        else:
            # Ocurrió un error al actualizar el producto
            return render(request, 'actualizar_producto.html', {'error': 'Error al actualizar el producto'})

    else:
        try:
            response = requests.get(f'http://127.0.0.1:5000/api/productos/{producto_id}')
            response.raise_for_status()
            producto = response.json()
        except requests.exceptions.RequestException as e:
            return render(request, 'actualizar_producto.html', {'error': f'Error al obtener el producto: {str(e)}'})
        except ValueError as e:
            return render(request, 'actualizar_producto.html', {'error': 'La respuesta de la API no es un JSON válido'})

        return render(request, 'actualizar_producto.html', {'producto': producto})




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
        ordenes = response.json()
        context = {'pedidos': pedidos}
    except requests.exceptions.RequestException as e:
        context = {'error': f'No se pudo obtener las órdenes: {e}'}

    return render(request, 'core/bodeguero.html', context)


def contador(request):
    try:
        response = requests.get('http://127.0.0.1:5000/api')
        response.raise_for_status()
        ordenes = response.json()
        context = {'pagos': pagos}
    except requests.exceptions.RequestException as e:
        context = {'error': f'No se pudo obtener los pagos: {e}'}

    return render(request, 'core/contador.html', context)
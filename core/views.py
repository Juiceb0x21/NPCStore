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
from transbank.error.transbank_error import TransbankError
from carro import context_processor
from carro.views import procesar_pedido
from django.http import HttpResponse
from django.shortcuts import render, redirect
from requests.exceptions import RequestException, HTTPError
from django.http import HttpRequest
from django.views.decorators.csrf import csrf_exempt
from django.contrib import messages


def index(request):
        try:
            response = requests.get('http://127.0.0.1:5000/api/productos')
            response.raise_for_status() 
            data = response.json()
            context = {'productos': data[:4]} 
        except requests.exceptions.RequestException as e:
            context = {'error': f'No se pudo obtener los productos: {e}'}
        
        return render(request, 'core/index.html', context)

def mis_pedidos(request):
    if "user_data" in request.session:
        user_data = request.session['user_data']
        user_id = user_data['id']
        try:
            json = {
                        "id_usuario": user_id
                    }
            response = requests.post('http://127.0.0.1:5000/api/pedidos/get_pedido_linea_iduser', json=json)
            response.raise_for_status()
            pedidos = response.json()
            print(pedidos)
            context = {'pedidos': pedidos}
        except requests.exceptions.RequestException as e:
            context = {'error': f'No se pudo obtener los pedidos: {e}'}

        return render(request, 'core/mis_pedidos.html', context)
    else:
        # El usuario no está autenticado, redirigir a la página de inicio de sesión
        return redirect('login')

    

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
    if "user_data" in request.session:
        user_data = request.session['user_data']
    else:
        user_data = False
    if user_data:
        random_order = ''.join(random.choices(string.ascii_lowercase + string.digits, k=8))
        random_session = ''.join(random.choices(string.ascii_lowercase + string.digits, k=10))  

        response = redirect('index')
        if context_processor.importe_total_carro(request)['importe_total_carro'] > 0:

            buy_order = "ordenCompra" + random_order
            session_id = "sesion" + random_session
            return_url = 'http://127.0.0.1:8000/boleta/response/'
            amount = context_processor.importe_total_carro(request)['importe_total_carro']

            tx = Transaction(WebpayOptions(IntegrationCommerceCodes.WEBPAY_PLUS, IntegrationApiKeys.WEBPAY, IntegrationType.TEST))

            resp = tx.create(buy_order, session_id, amount, return_url)


            context = {'transaccion': resp}

        

            return render(request, 'core/cart.html', context)
        return render(request, 'core/cart.html')
    else:
        return redirect('login')



def actualizar_producto(request: HttpRequest, producto_id: int):
    if "user_data" in request.session:
        user_data = request.session['user_data']
    else:
        user_data = False

    if user_data:
        if user_data['is_connect'] == 1:
            try:
                if request.method == 'POST':
                    stock = request.POST.get('stock')
                    precio = request.POST.get('precio')
                    imagen = request.FILES.get('imagen')

                    # Validar el stock y el precio
                    if int(stock) <= 0:
                        messages.error(request, 'El stock debe ser mayor a 0.')
                    elif float(precio) <= 0:
                        messages.error(request, 'El precio debe ser mayor a 0.')
                    else:
                        json_data = {
                            'id': producto_id,
                            'categoria_id': request.POST.get('categoria'),
                            'descripcion': request.POST.get('descripcion'),
                            'imagen': imagen.name,
                            'marca_id': request.POST.get('marca'),
                            'nombre': request.POST.get('nombre'),
                            'precio': precio,
                            'stock': stock
                        }
                        print(json_data)

                        response = requests.post('http://127.0.0.1:5000/api/productos/actualizar_producto', json=json_data)
                        response.raise_for_status()
                        return redirect('index')
                        
                else:
                    producto = obtener_producto_por_id(producto_id)
                    if producto is None:
                        error_message = 'El producto no se encuentra.'
                        return HttpResponse(f'<html><body><p>{error_message}</p></body></html>', status=404)

                    return render(request, 'core/actualizar_producto.html', {'producto': producto})
            except Exception as e:
                            error_message = f'Error al actualizar el producto: {str(e)}'
                            messages.error(request, error_message)
                            return redirect('actualizar_producto', producto_id)
        else:
            return redirect('login')
    else:
        return redirect('login')

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
        if 'carro' in request.session:
            del request.session['carro']
        return redirect('index')
    

def bodeguero(request):
    try:
        response = requests.get('http://127.0.0.1:5000/api/pedidos/get_pedido_linea')
        response.raise_for_status()
        pedidos = response.json()
        print(pedidos)
        context = {'pedidos': pedidos}
    except requests.exceptions.RequestException as e:
        context = {'error': f'No se pudo obtener las órdenes: {e}'}

    if request.method == 'POST':
        pedido_id = request.POST.get('pedido_id')
        nuevo_estado = request.POST.get('nuevo_estado')

        if pedido_id and nuevo_estado:
            data = {
                'id_pedido': pedido_id,
                'nuevo_estado': nuevo_estado
            }

            try:
                response = requests.post('http://127.0.0.1:5000/api/pedidos/actualizar_estado', json=data)
                response.raise_for_status()
                print(response.json())
                if response.status_code == 200:
                    messages.success(request, 'Estado del pedido actualizado correctamente')
                else:
                    messages.error(request, 'Error al actualizar el estado del pedido')
                return redirect('bodeguero')

            except requests.exceptions.RequestException as e:
                messages.error(request, f'Error al actualizar el estado del pedido: {e}')

    return render(request, 'core/bodeguero.html', context)



def contact(request):
    return render(request, 'core/contact.html')



@csrf_exempt
def boleta(request):
    TBK_TOKEN = request.GET.get('token_ws')
    if TBK_TOKEN:
        try:
            tx = Transaction(WebpayOptions(IntegrationCommerceCodes.WEBPAY_PLUS, IntegrationApiKeys.WEBPAY, IntegrationType.TEST))
            resp = tx.commit(TBK_TOKEN)
            if resp['status'] != 'ABORTED':
                resp = tx.commit(TBK_TOKEN)
                if resp['status'] == 'AUTHORIZED':
                    if "user_data" in request.session:
                        user_data = request.session['user_data']
                        context = {}  # Inicializar context como un diccionario vacío
                        if 'carro' in request.session:  # Asignar valores de ejemplo
                            json = {
                                "id_usuario": user_data['id'],
                                "num_orden": resp['buy_order'],
                                "monto": resp['amount']
                            }
                            response = requests.post('http://127.0.0.1:5000/api/pedidos/add', json=json)
                            id_pedido = response.json()['id_pedido']
                            procesar_pedido(request, id_pedido, user_data['id'])
                            if id_pedido:
                                pedido = {
                                    "id_pedido": id_pedido
                                }
                                pedido_response = requests.post('http://127.0.0.1:5000/api/pedidos/get_pedido_linea_idpedido', json=pedido)
                                print(pedido_response.json())

                                context = {
                                    'descripcion': pedido_response.json()[0]['descripcion'],
                                    'estado': pedido_response.json()[0]['estado'],
                                    'fecha_pedido': pedido_response.json()[0]['fecha_pedido'],
                                    'id': pedido_response.json()[0]['id'],
                                    'lineas_pedido': pedido_response.json()[0]['lineas_pedido'],
                                    'monto': pedido_response.json()[0]['monto'],
                                    'num_orden': pedido_response.json()[0]['num_orden'],
                                    'usuario_id': pedido_response.json()[0]['usuario_id']
                                }
                                if 'carro' in request.session:
                                    del request.session['carro']
                                return render(request, 'core/boleta.html', {'context': context})
                        return redirect('boleta')
                else:
                    context = {
                        'message': "Transacción no autorizada o fallida",
                        'status': resp['status']
                    }
                    return render(request, 'core/error.html', {'context' : context})
            else:
                context = {
                    'message': "Transacción Fallida",
                    'status': resp['status']
                }
                return render(request, 'core/error.html', {'context' : context})
        except TransbankError as e:
            context = {
                'message': f"Error al procesar la transacción: {str(e)}",
                'status': 'Desconocido'
            }
    else:
        return redirect('carrito')

def contador(request):
    try:
        response = requests.get('http://127.0.0.1:5000/api/pagos')
        response.raise_for_status()
        pagos = response.json()
        context = {'pagos': pagos}
    except requests.exceptions.RequestException as e:
        context = {'error': f'No se pudo obtener los pagos: {e}'}

    return render(request, 'core/contador.html', context)

def obtener_usuarios():
    try:
        response = requests.get('http://127.0.0.1:5000/api/users')
        response.raise_for_status()  # Lanzar una excepción para errores de solicitud
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f'Error al obtener los usuarios: {str(e)}')
        return None
    



def control_users(request):
    if "user_data" in request.session:
        user_data = request.session['user_data']
    else:
        user_data = False
    if user_data:
        if user_data['is_connect'] == 1:
            usuarios = obtener_usuarios()
            busqueda = request.GET.get('busqueda', '')

            if usuarios:
                if busqueda:
                    usuarios = [u for u in usuarios if busqueda.lower() in u['nombre'].lower()]
                return render(request, 'core/control_users.html', {'usuarios': usuarios, 'busqueda': busqueda})
            else:
                return render(request, 'core/control_users.html', {'error': 'No se pudo obtener los usuarios'})    
        else:
            return redirect('login')
    else:
        return redirect('login')


    


def actualizar_rol_usuario(request, usuario_id):
    if request.method == 'POST':
        nuevo_rol_id = request.POST.get('nuevo_rol_id')
        if nuevo_rol_id:
            url = 'http://127.0.0.1:5000/api/users/actualizar_rol'
            data = {
                'id': usuario_id,
                'rol_id': nuevo_rol_id
            }
            response = requests.post(url, json=data)
            if response.status_code == 200:
                messages.success(request, 'El rol del usuario ha sido actualizado correctamente.')
                return redirect('control_users')
            else:
                messages.error(request, 'Hubo un error al actualizar el rol del usuario.')
                return redirect('control_users')
    return redirect('control_users')

def delete_producto(request, id):
    if id:
        idp = {
                'id': id
            }
        response = requests.post(f'http://127.0.0.1:5000/api/productos/delete_producto', json=idp)
        
        if response.status_code == 200:
            return redirect('index')
            print("pasó")
        else:
            pass
    return redirect('index')


def add_producto(request):
    if request.method == 'POST':
        try:
            # Obtener los datos del formulario
            nombre = request.POST.get('nombre')
            descripcion = request.POST.get('descripcion')
            categoria = request.POST.get('categoria')
            marca = request.POST.get('marca')
            precio = request.POST.get('precio')
            stock = request.POST.get('stock')
            imagen = request.FILES.get('imagen')

            # Validar el stock y el precio
            if int(stock) <= 0:
                messages.error(request, 'El stock debe ser mayor a 0.')
            elif float(precio) <= 0:
                messages.error(request, 'El precio debe ser mayor a 0.')
            else:
                # Crear un diccionario con los datos del producto
                producto = {
                    "nombre": nombre,
                    "descripcion": descripcion,
                    "categoria": categoria,
                    "marca": marca,
                    "precio": precio,
                    "stock": stock,
                    "imagen": imagen.name
                }

                response = requests.post('http://127.0.0.1:5000/api/productos/add', json=producto)
                if response.status_code == 200:
                    messages.success(request, 'Producto agregado correctamente.')
                else:
                    messages.error(request, 'Error al agregar el producto.')

        except Exception as e:
            messages.error(request, f"Error: {e}")

    return render(request, 'core/add_producto.html')

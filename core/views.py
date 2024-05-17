from django.shortcuts import render, redirect
from .models import *
from django.contrib.auth import authenticate, login
from .forms import loginForm
from django.contrib.auth.models import User
from django.contrib.auth import logout
import requests
import json
from django.core.paginator import Paginator



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
    return render(request, 'core/cart.html')

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


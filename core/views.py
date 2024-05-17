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
                if data['estado'] == True:
                    return redirect('index')
                else:
                    print("xd")

    else:
        form = loginForm()

    return render(request, 'core/login.html', {'form': form})

def productos(request):
    return render(request, 'core/shop.html')

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

def contacto(request):
    return render(request, 'core/contacto.html')

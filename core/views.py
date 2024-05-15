from django.shortcuts import render, redirect
from .models import *
from django.contrib.auth import authenticate, login
from .forms import loginForm
from django.contrib.auth.models import User
from django.contrib.auth import logout
import requests
import json


def index(request):
    response = requests.get('http://127.0.0.1:5000/api/productos')
    if response.status_code == 200:
        data = response.json()
    
    return render(request, 'core/index.html')

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
                    return redirect('home')

    else:
        form = loginForm()

    return render(request, 'core/login.html', {'form': form})

def productos(request):
    return render(request, 'core/shop.html')

def carrito(request):
    return render(request, 'core/cart.html')

def detalleProducto(request):
    return render (request, 'core/detail.html')


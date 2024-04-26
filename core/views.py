from django.shortcuts import render, redirect


def index(request):
    return render(request, 'core/index.html')

def productos(request):
    return render(request, 'core/shop.html')

def carrito(request):
    return render(request, 'core/cart.html')

def detalleProducto(request):
    return render (request, 'core/detail.html')

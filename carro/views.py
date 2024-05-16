from django.shortcuts import render, redirect

import requests

from .carro import Carro

from .models import Producto


def agregar_producto(request, producto_id):
    carro=Carro(request)
    json ={
        "id" : producto_id
    }
    response = requests.post('http://127.0.0.1:5000/api/productos/getbyid', json=json)
    data = response.json()
    
    producto = Producto(data[0]["id"], data[0]["nombre"], data[0]["descripcion"], data[0]["imagen"], data[0]["precio"], data[0]["stock"], data[0]["categoria"], data[0]["marca"])
    carro.agregar(producto=producto)

    return redirect("carrito")

def eliminar_producto(request, producto_id):
    carro=Carro(request)
    json ={
        "id" : producto_id
    }    
    response = requests.post('http://127.0.0.1:5000/api/productos/getbyid', json=json)
    data = response.json()
    
    producto = Producto(data[0]["id"], data[0]["nombre"], data[0]["descripcion"], data[0]["imagen"], data[0]["precio"], data[0]["stock"], data[0]["categoria"], data[0]["marca"])
    
    carro.eliminar(producto=producto)

    return redirect("carrito")

def  restar_producto(request, producto_id):
    carro=Carro(request)
    json ={
        "id" : producto_id
    }    
    response = requests.post('http://127.0.0.1:5000/api/productos/getbyid', json=json)
    data = response.json()
    
    producto = Producto(data[0]["id"], data[0]["nombre"], data[0]["descripcion"], data[0]["imagen"], data[0]["precio"], data[0]["stock"], data[0]["categoria"], data[0]["marca"])
    
    carro.restar_producto(producto=producto)

    return redirect("carrito")

def limpiar_carro(request, producto_id):
    carro=Carro(request)
    carro.limpiar_carro()

    return redirect("carrito")

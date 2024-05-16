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
    print(producto)
    carro.agregar(producto=producto)

    return redirect("carrito")

def eliminar_producto(request, producto_id):
    carro=Carro(request)
    json ={
        "id" : producto_id
    }    
    response = requests.post('http://127.0.0.1:5000/api/productos/getbyid', json=json)
    data = response.json()
    producto = {
        "categoria": data[0]["categoria"],
        "descripcion": data[0]["descripcion"],
        "id": data[0]["id"],
        "imagen": data[0]["imagen"],
        "marca": data[0]["marca"],
        "nombre": data[0]["nombre"],
        "precio": data[0]["precio"],
        "stock":data[0]["stock"]
    }
    carro.eliminar(producto=producto)

    return redirect("cart")

def restar_producto(request, producto_id):
    carro=Carro(request)
    json ={
        "id" : producto_id
    }    
    response = requests.post('http://127.0.0.1:5000/api/productos/getbyid', json=json)
    data = response.json()
    producto = {
        "categoria": data[0]["categoria"],
        "descripcion": data[0]["descripcion"],
        "id": data[0]["id"],
        "imagen": data[0]["imagen"],
        "marca": data[0]["marca"],
        "nombre": data[0]["nombre"],
        "precio": data[0]["precio"],
        "stock":data[0]["stock"]
    }
    carro.restar_producto(producto=producto)

    return redirect("cart")

def limpiar_carro(request, producto_id):
    carro=Carro(request)
    carro.limpiar_carro()

    return redirect("cart")

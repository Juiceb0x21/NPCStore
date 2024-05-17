from django.contrib.auth.models import User, Group
import requests


def importe_total_carro(request):
    total = 0
    if "carro" in request.session:
        for key, value in request.session["carro"].items():
            total += int(value["precio"]) * value["cantidad"]
    return {"importe_total_carro": total}


def cantidad_carro(request):
    cantidad=0
    for key, value in request.session["carro"].items():
        cantidad=cantidad+value["cantidad"]
    return {"cantidad_carro": cantidad} 
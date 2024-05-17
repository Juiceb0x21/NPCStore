from django.urls import path
from .views import *

urlpatterns = [
    	path('', index, name="index"),
        path('shop.html', productos, name= "productos"),
        path('cart.html', carrito, name = "carrito"),
        path('detail.html/<int:producto_id>/', detalleProducto, name="detalleProducto"),
        path('login.html', login, name="login"),
        path("logout/<int:producto_id>/", logout, name="logout"),
]
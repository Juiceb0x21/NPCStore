from django.urls import path
from .views import *

urlpatterns = [
    	path('', index, name="index"),
        path('shop.html', productos, name= "productos"),
        path('cart.html', carrito, name = "carrito"),
        path('detail.html/<int:producto_id>/', detalleProducto, name="detalleProducto"),
        path('login.html', login, name="login"),
        path("logout/<int:producto_id>/", logout, name="logout"),
        path('bodeguero', bodeguero, name='bodeguero'),
        path('contador', contador, name='contador'),
        path('actualizar_producto/<int:producto_id>/', actualizar_producto, name='actualizar_producto'),
        path('control_users/', control_users, name='control_users'),
        path('contact', contact, name="contact"),
        path('boleta', boleta, name="boleta"),
        path('add_producto/', add_producto, name='add_producto'),
        path('boleta/response/', boleta, name="boleta"),
        path('actualizar_rol/<int:usuario_id>/', actualizar_rol_usuario, name="actualizar_rol"),
        

        
]

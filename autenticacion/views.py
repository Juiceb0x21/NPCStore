from django.shortcuts import render, redirect
from django.contrib.auth import login
from django.contrib import messages
from django.contrib.auth.models import User
from .forms import CustomUserCreationForm
import requests

# Create your views here.
def register(request):
    if request.method == 'POST':
        response = requests.get('http://127.0.0.1:5000/api/registro')
        if response.status_code == 200:
            user_data = response.json()
            f = CustomUserCreationForm(user_data)
            if f.is_valid():
                usuario = f.save()
                messages.success(request, 'Cuenta Creada correctamente')

                login(request, usuario)

                usuario = User.objects.get(username=usuario.username)
                usuario.save()
                return redirect('home')
            else:
                messages.error(request, 'Error en la creación de la cuenta.')
        else:
            messages.error(request, 'Error al obtener datos de la API.')
    else:
        f = CustomUserCreationForm()
    return render(request, 'registro/registro.html', {'form': f})
from django.shortcuts import render, redirect
from django.contrib.auth import login
from django.contrib import messages
from django.contrib.auth.models import User
from .forms import RegistroForm
import requests
from django.core.exceptions import ValidationError
from core.views import login

# Create your views here.
def register(request):
    if request.method == 'POST':
        form = RegistroForm(request.POST)
        if form.is_valid():
            try:
                if form.save():
                    messages.success(request, 'Cuenta Creada correctamente')
                    json = {
                        'correo': form.cleaned_data['correo'], 
                        'contrasena': form.cleaned_data['contrasena']
                    }
                    response = requests.post('http://127.0.0.1:5000/api/users/login', json=json)
                    if response.status_code == 200:
                        data = response.json()
                try:
                    if data['is_connect'] == 1:
                        request.session['user_data'] = data
                        return redirect('index')
                except Exception as e:
                    print(f"Error al autenticar al usuario: {e}")
            except ValidationError as e:
                messages.error(request, str(e))
    else:
        form = RegistroForm()

    return render(request, 'registro/registro.html', {'form': form})
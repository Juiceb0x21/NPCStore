from django.shortcuts import render, redirect
from django.contrib.auth import login
from django.contrib import messages
from django.contrib.auth.models import User
from .forms import CustomUserCreationForm



# Create your views here.
def register(request):
    if request.method == 'POST':
        f = CustomUserCreationForm(request.POST)
        if f.is_valid():
            usuario = f.save()
            messages.success(request, 'Cuenta Creada correctamente')

            login(request, usuario)

            usuario = User.objects.get(username = usuario.username)
            usuario.save()

            return redirect('index')

    else:
        f = CustomUserCreationForm()

    return render(request, 'registro/registro.html', {'form': f})
from django.shortcuts import render, redirect
from .models import *
from django.contrib.auth import authenticate, login
from .forms import CustomAuthenticationForm
from .forms import *
from django.contrib.auth.models import User
from django.contrib.auth import logout


from .forms import CustomAuthenticationForm



def index(request):
    return render(request, 'core/index.html')

def login_view(request):
    if request.method == 'POST':
        form = CustomAuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = authenticate(request, username=form.cleaned_data['username'], password=form.cleaned_data['password'])
            if user is not None:
                login(request, user)
                return redirect('home') 
    else:
        form = CustomAuthenticationForm()

    return render(request, 'login.html', {'form': form})

def productos(request):
    return render(request, 'core/shop.html')

def carrito(request):
    return render(request, 'core/cart.html')

def detalleProducto(request):
    return render (request, 'core/detail.html')


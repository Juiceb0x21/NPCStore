from django import forms
from django.contrib.auth.forms import AuthenticationForm
from .forms import *

class CustomAuthenticationForm(AuthenticationForm):
    email = forms.EmailField(label='Email', widget=forms.EmailInput(attrs={'class': 'form-control'}))

class InsForm(forms.Form):
    nombre= forms.CharField(label='Nombre Completo', min_length=0, max_length=100, widget=forms.TextInput(attrs={'class': 'form-control'}))
    correo= forms.CharField(label='Correo', min_length=0, max_length=100, widget=forms.TextInput(attrs={'class': 'form-control'}))
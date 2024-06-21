from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django import forms
import requests
from django.core.exceptions import ValidationError

def validar(value):
        if value < 999999 or value > 100000000:
            raise ValidationError("Rut inválido")


class RegistroForm(forms.Form):
    rut = forms.IntegerField(label='Rut', validators=[validar])
    dv = forms.CharField(label='Dv', min_length=1, max_length=1)
    nombre = forms.CharField(label='Nombre', min_length=3, max_length=40)
    apellido = forms.CharField(label='Apellido', min_length=3, max_length=30)
    correo = forms.CharField(label='Correo', min_length=10, max_length=150)
    contrasena = forms.CharField(label='Contraseña', min_length=8, max_length=50)

    def clean(self):
        cleaned_data = super().clean()
        rut = cleaned_data.get("rut")
        correo = cleaned_data.get("correo")

        # verificaciones

        return cleaned_data
    

    def save(self, commit=True):
        json = {
            'rut': self.cleaned_data['rut'],
            'dv': self.cleaned_data['dv'],
            'nombre': self.cleaned_data['nombre'],
            'apellido': self.cleaned_data['apellido'],
            'correo': self.cleaned_data['correo'],
            'contrasena': self.cleaned_data['contrasena']
        }

        response = requests.post('http://127.0.0.1:5000/api/users/registro', json=json)

        if response.status_code == 200:
            print("Usuario registrado con éxito")
            return True
        else:
            raise ValidationError(f"Error al registrar el usuario: {response.status_code} - {response.text}")


           
        
       

from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django import forms
from django.core.exceptions import ValidationError
import requests

class CustomUserCreationForm(forms.Form):
    nombre = forms.CharField(label='Nombre', min_length=4, max_length=150, widget=forms.TextInput(attrs={'class': 'form-control'}))
    email = forms.EmailField(label='Email', widget=forms.EmailInput(attrs={'class': 'form-control'}))
    password1 = forms.CharField(label='Contraseña', widget=forms.PasswordInput(attrs={'class': 'form-control'}))
    password2 = forms.CharField(label='Confirmar Contraseña', widget=forms.PasswordInput(attrs={'class': 'form-control'}))

    def clean_email(self):
        email = self.cleaned_data['email'].lower()
        r = User.objects.filter(email=email)
        if r.count():
            raise  ValidationError("Correo ya existe")
        return email

    def clean_password2(self):
        password1 = self.cleaned_data.get('password1')
        password2 = self.cleaned_data.get('password2')

        if password1 and password2 and password1 != password2:
            raise ValidationError("Contraseñas no coinciden")

        return password2


    def save(self, commit=True):
        response = requests.post('http://127.0.0.1:5000/api/users/register')
        if response.status_code == 200:
            data = response.json()
            if data['estado'] == True:
                user = User.objects.create_user(
                    username=self.cleaned_data['nombre'],
                    email=self.cleaned_data['email'],
                    password= self.cleaned_data['password1'],
                )
            else:
                print("xd")

        return user


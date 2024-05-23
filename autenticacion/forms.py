
from django.contrib.auth.models import User
from django import forms
import requests
 
class RegistroForm(forms.Form):
    rut = forms.CharField(label='Rut', min_length=0, max_length=9)
    nombre= forms.CharField(label='Nombre', min_length=0, max_length=40)
    apellido= forms.CharField(label='Apellido', min_length=0, max_length=30)
    correo= forms.CharField(label='Correo', min_length=0, max_length=150)
    contrasena = forms.CharField(label='Contraseña', min_length=0, max_length=50)

    def clean(self):
        cleaned_data = super().clean()

        rut = cleaned_data.get('rut')
        response = requests.get(f'http://127.0.0.1:5000/api/users?rut={rut}')
        if response.status_code == 200:
            data = response.json()
            if data:
                self.add_error('rut', 'El RUT ya está registrado')

        correo = cleaned_data.get('correo')
        response = requests.get(f'http://127.0.0.1:5000/api/users?correo={correo}')
        if response.status_code == 200:
            data = response.json()
            if data:
                self.add_error('correo', 'El correo electrónico ya está registrado')
        return cleaned_data

    def save(self, commit=True):
        response = requests.post('http://127.0.0.1:5000/api/users/registro')
        if response.status_code == 200:
            data = response.json()
            if data['estado']:
                try:
                    user = User.objects.create_user(
                        username=self.cleaned_data['nombre'],
                        email=self.cleaned_data['correo'],
                        password=self.cleaned_data['contrasena']
                    )
                    return user
                except Exception as e:
                    print(f"Error al crear usuario: {e}")


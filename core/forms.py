from django import forms
from .forms import *
from crispy_forms.helper import FormHelper
from crispy_forms.layout import Layout, Submit

class loginForm(forms.Form):
    correo= forms.CharField(label='Correo', min_length=0, max_length=100)
    contrasena = forms.CharField(label='Contraseña', min_length=0, max_length=100)

    def init(self, args, **kwargs):
        super().init(args, **kwargs)
        self.helper = FormHelper()
        self.helper.layout = Layout(
            'Correo',
            'Contraseña',
            Submit('submit', 'Ingresar', css_class='btn-primary')
        )
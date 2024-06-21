from django.test import TestCase
from core.models import *
from core.forms import *
from django.urls import reverse
from autenticacion.forms import RegistroForm


class FormTest(TestCase):
    def test_form_login_valid(self):
        form_data = {
            'correo' : 'alanmoreno332@gmail.com',
            'contrasena' : 'alanmoreno332'
        }
        form = loginForm( data = form_data)
        self.assertTrue(form.is_valid())

    def test_form_login_invalid(self):
        form_data = {
            'correo' : 'alanmoreno332@gmail.com',
            'contrasena' : 'alan'
        }
        form = loginForm( data = form_data)
        self.assertFalse(form.is_valid())

    def test_form_register_valid(self):
        form_data = {
            'rut' : '21621035',
            'dv' : '2',
            'nombre' : 'Alan',
            'apellido' : 'Moreno',
            'correo' : 'alanmoreno332@gmail.com',
            'contrasena' : 'alanmoreno2004'
        }
        form = RegistroForm(data=form_data)
        self.assertTrue(form.is_valid())

    def test_form_register_invalid(self):
        form_data = {
            'rut' : '21621035',
            'dv' : '2',
            'nombre' : 'Al',
            'apellido' : 'Mo',
            'correo' : 'alanmoreno332@gmail.com',
            'contrasena' : 'alanmoreno2004'
        }
        form = RegistroForm(data=form_data)
        self.assertFalse(form.is_valid())
    
    def test_form_register_rut_invalid(self):
        form_data = {
            'rut' : '216210352',
            'dv' : '2',
            'nombre' : 'Alan',
            'apellido' : 'Moreno',
            'correo' : 'alanmoreno332@gmail.com',
            'contrasena' : 'alanmoreno2004'
        }
        form = RegistroForm(data=form_data)
        self.assertFalse(form.is_valid())
    
    
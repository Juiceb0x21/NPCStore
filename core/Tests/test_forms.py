from django.test import TestCase
from core.models import *
from core.forms import *
from django.urls import reverse


# ejemplos
class TipoEmpleadoFormTest(TestCase):

    def test_tipoempleado_form_valid(self):
        form_data = {'descripcion': 'Gerente'}
        form = TipoEmpleadoFormTest(data = form_data)
        self.assertTrue(form.is_valid())

    def test_tipoempleado_form_invalid(self):
        form_data = {'descripcion': 'Gg' * 40}
        form = TipoEmpleadoFormTest(data = form_data)
        self.assertFalse(form.is_valid())

        self.assertIn('descripcion', form.errors)

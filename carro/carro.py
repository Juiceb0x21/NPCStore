import requests

class Carro:
    def __init__(self, request):
        self.request = request
        self.session = request.session
        carro = self.session.get("carro")
        if not carro:
            carro = self.session["carro"] = {}
        self.carro = carro

    def agregar(self, producto):
        print("pasó")
        if str(producto.id) not in self.carro.keys():
            if producto.stock > 0:
                self.carro[str(producto.id)] = {
                    "producto_id": producto.id,
                    "nombre": producto.nombre,
                    "precio": str(producto.precio),
                    "precio2": int(producto.precio),
                    "cantidad": 1,
                    "imagen": producto.imagen
                }
                json ={
                    "id" : producto.id
                }
                response = requests.post('http://127.0.0.1:5000/api/productos/actstockmenos', json=json)
                data = response.json()
            else:
                pass
        else:
            for key, value in self.carro.items():
                if key == str(producto.id):
                    if producto.stock > 0:
                        value["cantidad"] += 1
                        value["precio2"] += producto.precio
                        json ={
                            "id" : producto.id
                        }
                        response = requests.post('http://127.0.0.1:5000/api/productos/actstockmenos', json=json)
                        data = response.json()
                    else:
                        pass
                    break
        self.guardar_carro()

    def guardar_carro(self):
        self.session["carro"] = self.carro
        self.session.modified = True

    def eliminar(self, producto):
        producto_id = str(producto.id)
        if producto_id in self.carro:
            print("Pasó")
            json = {
                'cantidad' : self.carro[producto_id]["cantidad"],
                'id' : producto.id
            }
            response = requests.post('http://127.0.0.1:5000/api/productos/actstockmas', json=json)
            data = response.json()
            del self.carro[producto_id]
            self.guardar_carro()
        else:
            print("no pasó")

    def restar_producto(self, producto):
        producto_id = str(producto.id)
        if producto_id in self.carro:
            for key, value in self.carro.items():
                if key == producto_id:
                    value["cantidad"] -= 1
                    value["precio2"] -= producto.precio
                    producto.stock += 1
                    json = {
                        'cantidad' : 1,
                        'id' : producto.id
                    }
                    response = requests.post('http://127.0.0.1:5000/api/productos/actstockmas', json=json)
                    data = response.json()
                    if value["cantidad"] < 1:
                        self.eliminar(producto)
                    break
            self.guardar_carro()

    def limpiar_carro(self):
        for key, value in self.carro.items():
            producto_id = value["producto_id"]
        self.carro = {}
        self.guardar_carro()

    def agregar_pedido(self):
        self.carro.items()


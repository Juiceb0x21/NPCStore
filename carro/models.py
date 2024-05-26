
class Producto():
    def __init__(self, id, nombre, descripcion, imagen, precio, stock, categoria_id, marca_id):
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
        self.imagen = imagen
        self.precio = precio
        self.stock = stock
        self.categoria_id = categoria_id
        self.marca_id = marca_id

class Pedido():
    def __init__(self, id, tipo_pago, num_orden, id_pago, monto, fecha_pedido, id_usuario, nombre_usuario, apellido_usuario, estado_pedido):
        self.id = id
        self.tipo_pago = tipo_pago
        self.num_orden = num_orden
        self.id_pago = id_pago
        self.monto = monto
        self.fecha_pedido = fecha_pedido
        self.id_usuario = id_usuario
        self.nombre_usuario = nombre_usuario
        self.apellido_usuario = apellido_usuario
        self.estado_pedido = estado_pedido

class LineaPedidos():
    def __init__(self, producto_id, pedido_id, cantidad, usuario_id):
        self.producto_id = producto_id
        self.pedido_id = pedido_id
        self.cantidad = cantidad
        self.usuario_id = usuario_id
    
    def to_JSON(self):
        return {
            'producto_id' : self.producto_id,
            'pedido_id' : self.pedido_id,
            'cantidad' : self.cantidad,
            'usuario_id' : self.usuario_id
        }
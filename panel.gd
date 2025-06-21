extends Panel

@onready var nombre_label = $NombreLabel
@onready var dialogo_label = $DialogoLabel

var velocidad_texto := 0.03
var escribiendo := false

# Método público que se llamará desde la otra escena
func mostrar_dialogo(nombre: String, texto: String) -> void:
	nombre_label.text = nombre
	dialogo_label.text = ""
	escribiendo = true
	await escribir_texto(texto)
	escribiendo = false

# Función que escribe letra por letra
func escribir_texto(texto: String) -> void:
	for letra in texto:
		dialogo_label.text += letra
		await get_tree().create_timer(velocidad_texto).timeout

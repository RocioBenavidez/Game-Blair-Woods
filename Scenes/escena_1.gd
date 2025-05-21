extends Node2D


@onready var fondo = $Fondo
@onready var nombre = $Panel/NombreLabel
@onready var texto = $Panel/DialogoLabel
@onready var temporizador = $Timer

var indice_actual: int = 0
var velocidad: float = 0.03
var escribiendo: bool = false

var lista_dialogos = [
	{
		"nombre":"Narrador",
		"texto":"El sol descendía lentamente en el horizonte, pintando el cielo con tonos rojizos que parecían advertir a Emma de lo que estaba por venir.",
		"imagen_fondo":load("res://Assets/backgrounds/Auto.png")
	},
	{
		"nombre":"Narrador",
		"texto":"Conduciendo de regreso a casa, el zumbido del motor era el único acompañante constante.",
		"imagen_fondo":load("res://Assets/backgrounds/AutoBosque.png")
	},
	{
		"nombre":"Narrador",
		"texto": " Hasta que su teléfono vibró con insistencia.",
		"imagen_fondo":load("res://Assets/backgrounds/llamadaMark.png")
	},
	{
		"nombre":"Emma",
		"texto":"¿Hola, Mark? ¿Cómo va…?",
		"imagen_fondo":load("res://Assets/backgrounds/felizManejando.png")
	},
	{
		"nombre":"Mark",
		"texto":"Amor… Nuestro hijo pa... Pasear… Bosque de Blair.",
		"imagen_fondo":load("res://Assets/backgrounds/AndandoEnAuto.png")
	},
	{
		"nombre":"Emma",
		"texto":"¿Qué dices? ¿El bosque? ¿Mark?",
		"imagen_fondo":load("res://Assets/backgrounds/PreocupadaManejando.png")
	},
	{
		"nombre":"Mark",
		"texto":"Lo perdí… se lo llevó… creo que aquí hay algo…",
		"imagen_fondo":load("res://Assets/backgrounds/PreocupadaManejando.png")
	},
	{
		"nombre": "Narrador",
		"texto": "Emma pisó el freno de golpe, su corazón martilleando como un tambor de guerra.",
		"imagen_personaje": load("res://Assets/backgrounds/EmmaConduciendo.png")
	},
	{
		"nombre": "Narrador",
		"texto": "Sin dudarlo, giró el volante hacia el pueblo vecino de Blair, con el corazón lleno de temor… y decisión.",
		"imagen_fondo": load("res://Assets/backgrounds/AutoBosque.png")
	}
]

func _ready():
	await mostrar_dialogo_actual()
	

func mostrar_dialogo_actual():
	if indice_actual >= lista_dialogos.size():
		queue_free()
		return
		
	var entrada = lista_dialogos[indice_actual]
	
	if  entrada.has("imagen_fondo") and entrada["imagen_fondo"] != null:
		await cambiar_fondo_con_fade(entrada["imagen_fondo"])
	
	nombre.text = entrada["nombre"]
	await escribir_texto(entrada["texto"])
	
	await  get_tree().create_timer(0.8).timeout
	indice_actual += 1
	mostrar_dialogo_actual()
	
func escribir_texto(texto_completo: String) -> void:
	texto.text = ""
	escribiendo = true
	
	for letra in texto_completo:
		texto.text += letra
		await  get_tree().create_timer(velocidad).timeout
		
	escribiendo = false 
	
func cambiar_fondo_con_fade(nueva_textura: Texture2D) -> void:
	var tween = create_tween()
	tween.tween_property(fondo,"modulate:a", 0.0,0.4)
	await tween.finished
	
	fondo.texture = nueva_textura
	
	var tween_in = create_tween()
	tween_in.tween_property(fondo,"modulate:a",1.0,0.4)
	await  tween_in.finished
	
func _on_timer_timeout():
	indice_actual += 1
	mostrar_dialogo_actual()

	

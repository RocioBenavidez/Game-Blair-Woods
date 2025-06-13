extends Node2D


@onready var fondo = $Fondo
@onready var nombre = $Panel/NombreLabel
@onready var texto = $Panel/DialogoLabel
@onready var texto_secundario = $Panel/DialogoSecundarioLabel
@onready var temporizador = $Timer
@onready var video_final = $Fondo/VideoFinal

var indice_actual: int = 0
var velocidad: float = 0.05
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
		"imagen_fondo": load("res://Assets/backgrounds/giraVolante.png")
	},
	{
		"nombre":"Narrador",
		"texto":"Las historias del bosque venían a ella como fragmentos de una vieja pesadilla: la bruja, la maldición, los cazadores que nunca regresaron. Una comunidad marcada por la paranoia, condenada por el miedo y la crueldad. Y ahora, su esposo había llevado a su hijo allí.",
		"video_fondo": load("res://Assets/videos/mi_video.ogv")
	}

]

func _ready():
	await mostrar_dialogo_actual()
	

func mostrar_dialogo_actual():
	if indice_actual >= lista_dialogos.size():
		queue_free() #cierra la escena
		return #sale de la funcion
		
	var entrada = lista_dialogos[indice_actual] # guarda el dialogo actual 
	await manejar_fondo(entrada)
	nombre.text = entrada["nombre"]
	await escribir_texto(entrada["texto"]) # espera a que termine de escribir todo antes de continuar
	# Si hay video, esperar a que termine ANTES de avanzar
	if tiene_video(entrada):
		await esperar_video()
	await esperar_y_continuar()

func manejar_fondo(entrada: Dictionary) -> void:
	if  entrada.has("imagen_fondo") and entrada["imagen_fondo"] != null: # si el dialogo tiene una imagen de fondo y no esta vacia
		await cambiar_fondo_con_fade(entrada["imagen_fondo"]) # espera a que termine el cambio de fondo antes de seguir
	elif tiene_video(entrada):
		reproducir_video_con_fondo(entrada["video_fondo"])
	
func esperar_y_continuar() -> void:
	await get_tree().create_timer(0.8).timeout
	indice_actual += 1
	mostrar_dialogo_actual()
	
func tiene_video(entrada: Dictionary) -> bool:
	return entrada.has("video_fondo") and entrada["video_fondo"] != null
	
func escribir_texto(texto_completo: String) -> void:
	texto.text = "" # borra el texto del dialogo
	escribiendo = true # marca que se esta escribiendo
	
	for letra in texto_completo: # recorre letra x letra del texto
		texto.text += letra
		await  get_tree().create_timer(velocidad).timeout #espera un tiempo antes de escribir la siguiente letra 
		
	escribiendo = false # termina de escribir
	
func cambiar_fondo_con_fade(nueva_textura: Texture2D) -> void:
	var tween = create_tween() #animacion para nodos
	tween.tween_property(fondo,"modulate:a", 0.0,0.4) #anima la opacidad del fondo hasta que se vuelve trasparente 
	await tween.finished #espera que termine de animar(desvanecer el fondo)
	
	fondo.texture = nueva_textura #cambia la imagen de fondo 
	
	var tween_in = create_tween() #nueva animacion
	tween_in.tween_property(fondo,"modulate:a",1.0,0.4) #hace que el fondo aparezca de apoco
	await  tween_in.finished #espera a que termine 
	
func reproducir_video_con_fondo(video_stream: VideoStream):
	fondo.texture = null
	video_final.visible = true
	video_final.stream = video_stream
	video_final.play()
	
func esperar_video() -> void:
	await video_final.finished
	video_final.visible = false
	
func _on_timer_timeout():
	indice_actual += 1
	mostrar_dialogo_actual()


	

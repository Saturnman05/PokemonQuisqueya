extends Control


var background_texture_path = "res://assets/battlebacks/battlebgabrega.png"
var value_progress_bar_jugador: int = 0
var max_progress_bar_jugador: int = 100
var jugador_label_text: String
var jugador_pokemon_nivel: int

@onready var background_image = $Background
@onready var jugador_progress_bar = $JugadorPlataforma/ProgressBar
@onready var jugador_nombre_label = $JugadorPlataforma/LabelNombre
@onready var jugador_nivel_label = $JugadorPlataforma/LabelNivel


func _ready():
	background_image.texture = load(background_texture_path)
	jugador_progress_bar.max_value = max_progress_bar_jugador
	jugador_nombre_label.text = jugador_label_text
	jugador_nivel_label.text = "Nv." + str(jugador_pokemon_nivel)


func _process(_delta):
	jugador_progress_bar.value = value_progress_bar_jugador


func _on__testsaurio_hp(pokemon_hp, pokemon_max_hp):
	value_progress_bar_jugador = pokemon_hp
	max_progress_bar_jugador = pokemon_max_hp


func _on__testsaurio_nombre_pokemon(pokemon_name):
	jugador_label_text = pokemon_name


func _on__testsaurio_nivel(pokemon_nivel):
	jugador_pokemon_nivel = pokemon_nivel

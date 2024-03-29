extends Node2D


signal hp(pokemon_hp: int, pokemon_max_hp: int)
signal nombre_pokemon(pokemon_name: String)
signal nivel(pokemon_nivel: int)

@export var pokemon_nivel: int = 100
@export var pokemon_especie: String = "Testsaurio"
@export var pokemon_max_hp: int = 100
@export var pokemon_attack: int = 25
@export var pokemon_defense: int = 10
@export var pokemon_speed: int = 10

@onready var pokemon_hp = pokemon_max_hp
@onready var pokemon_name = pokemon_especie
@onready var sprite_frente = $BattleFront
@onready var sprite_espalda = $BattleBack


func _ready():
	if self.global_position == Vector2(150, 243):
		sprite_frente.hide()
	
	if self.global_position == Vector2(380, 161):
		sprite_espalda.hide()
	
	hp.emit(pokemon_hp, pokemon_max_hp)
	nombre_pokemon.emit(pokemon_name)
	nivel.emit(pokemon_nivel)

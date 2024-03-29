extends Node


var tiles_no_disponibles: Array = []

var player_pos: Vector2:
	set(value):
		player_pos = value

var pokemon_party: Array = [null, null, null, null, null, null]
func add_pokemon_to_party(pokemon) -> void:
	for i in range(6):
		if pokemon_party[i] == null:
			pokemon_party[i] = pokemon
			break


var pokemon_pc: Array = []


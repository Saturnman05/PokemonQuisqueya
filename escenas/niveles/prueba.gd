extends Node2D


func _on_jugador_interactuar(face_direction):
	for inter in get_tree().get_nodes_in_group("Interactuables"):
		print("player pos:", Global.player_pos)
		#print("face direction:", face_direction)
		#print("npc pos:", inter.position)
		if inter.position == Global.player_pos + (32 * face_direction):
			print("Interactuar")

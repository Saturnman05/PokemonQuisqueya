extends CharacterBody2D


enum NPCMove {
	UP,
	DOWN,
	LEFT, 
	RIGHT
}

@export var walk_speed: float = 2.0
@export var nombre: String = "Npc de prueba"

const TILE_SIZE: int = 32
var initial_position: Vector2 = Vector2.ZERO

var moves: Array = [
	NPCMove.RIGHT, NPCMove.RIGHT, NPCMove.RIGHT, NPCMove.RIGHT,
	NPCMove.DOWN, NPCMove.DOWN,
	NPCMove.LEFT,
	NPCMove.RIGHT,
	NPCMove.UP, NPCMove.UP,
	NPCMove.LEFT, NPCMove.LEFT, NPCMove.LEFT, NPCMove.LEFT
	]

var index: int = 0
var current_move: NPCMove = moves[index]
var direction: Vector2 = Vector2.ZERO
var percent_moved_to_next_tile: float = 0.0
var is_moving: bool = false
var next_tile: Vector2

@onready var move_timer = $MoveTimer
@onready var check_player_timer = $CheckPlayerTimer
@onready var ray = $RayCast2D
@onready var animation_player = $AnimationPlayer


func _ready():
	direction = check_direction(current_move)
	initial_position = position


func _physics_process(delta):
	if is_moving == false:
		check_direction(current_move)
	elif direction != Vector2.ZERO:
		move_timer.start()
		move(delta)
	else:
		is_moving = false


func move(delta) -> void:
	if not is_moving: return
	
	var desired_step: Vector2 = direction * TILE_SIZE / 2
	ray.target_position = desired_step
	ray.force_raycast_update()
	if not ray.is_colliding():
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1:
			position = initial_position + (TILE_SIZE * direction)
			percent_moved_to_next_tile = 0.0
			if index + 1 == len(moves):
				index = 0
			else:
				index += 1
			current_move = moves[index]
			check_position()
			direction = check_direction(current_move)
			is_moving = false
		else:
			position = initial_position + (TILE_SIZE * direction * percent_moved_to_next_tile) 
	else:
		percent_moved_to_next_tile = 0.0
		is_moving = false


func check_position() -> void:
	# Chequeando la posición en X
	if (int(position.x) % 32) != 0:
		if direction == Vector2(1, 0):
			while (int(position.x) % 32) != 0:
				position.x += 1
		if direction == Vector2(-1, 0):
			while (int(position.x) % 32) != 0:
				position.x -= 1
	
	# Chequeando la posición en Y
	if (int(position.y) % 32) != 0:
		if direction == Vector2(0, -1):
			while(int(position.y) % 32) != 0:
				position.y -= 1
		if direction == Vector2(0, 1):
			while (int(position.y) % 32) != 0:
				position.y += 1


func check_direction(_move) -> Vector2:
	if _move == NPCMove.UP:
		direction = Vector2(0, -1)
	if _move == NPCMove.DOWN:
		direction = Vector2(0, 1)
	if _move == NPCMove.RIGHT:
		direction = Vector2(1, 0)
	if _move == NPCMove.LEFT:
		direction = Vector2(-1, 0)
	
	if initial_position != Vector2.ZERO:
		initial_position = position
		is_moving = true
	
	return direction


func check_next_direction() -> Vector2:
	var new_index = 0
	if (index + 1) < len(moves):
		new_index = index + 1
	var next_move = moves[new_index]
	
	return check_direction(next_move)


# Todavía no funciona bien
func play_walk_animation() -> void:
#	if is_moving:
#		# Animación caminando
#		if direction == Vector2(0, 1):
#			animation_player.play("walk_down")
#		elif direction == Vector2(-1, 0):
#			animation_player.play("walk_left")
#		elif direction == Vector2(1, 0):
#			animation_player.play("walk_right")
#		elif direction == Vector2(0, -1):
#			animation_player.play("walk_up")
#	else:
	# Animación Idle
	if direction == Vector2(0, 1):
		animation_player.play("idle_down")
	elif direction == Vector2(-1, 0):
		animation_player.play("idle_left")
	elif direction == Vector2(1, 0):
		animation_player.play("idle_right")
	elif direction == Vector2(0, -1):
		animation_player.play("idle_up")


func _on_move_timer_timeout():
	play_walk_animation()
	is_moving = true

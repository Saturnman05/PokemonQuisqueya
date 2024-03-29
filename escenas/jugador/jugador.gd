extends CharacterBody2D


signal interactuar(face_direction)

@export var walk_speed: float = 4.0

const TILE_SIZE: int = 32
var initial_position: Vector2 = Vector2(0, 0)
var input_direction: Vector2 = Vector2(0, 0)
var is_moving: bool = false
var percent_moved_to_next_tile: float = 0.0
var last_input_direction: Vector2 = Vector2(1, 0)
var tile_a_mover: Vector2
var can_move_there: bool = true

@onready var animation_player = $AnimationPlayer
@onready var ray = $RayCast2D
@onready var colision_jugador = $CollisionShape2D


func _ready():
	initial_position = position


func _physics_process(delta):
	Global.player_pos = position
	
	if is_moving == false:
		process_player_input()
	elif input_direction != Vector2.ZERO and can_move_there:
		last_input_direction = input_direction
		move(delta)
	else:
		is_moving = false
	
	if Input.is_action_pressed("correr"):
		walk_speed = 10
		play_run_animation()
	else:
		walk_speed = 4
		play_walk_animation()


func process_player_input() -> void:
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	if initial_position != Vector2.ZERO:
		initial_position = position
		is_moving = true


func move(delta) -> void:
	var desired_step: Vector2 = input_direction * TILE_SIZE / 2
	ray.target_position = desired_step
	ray.force_raycast_update()
	if not ray.is_colliding():
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			#check_position()
			percent_moved_to_next_tile = 0.0
			is_moving = false
		else:
			position = initial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile)
	else:
		percent_moved_to_next_tile = 0
		is_moving = false


func check_position() -> void:
	# Chequeando la posición en X
	if (int(position.x) % 32) != 0:
		if input_direction == Vector2(1, 0):
			while (int(position.x) % 32) != 0:
				position.x += 1
		if input_direction == Vector2(-1, 0):
			while (int(position.x) % 32) != 0:
				position.x -= 1
	
	# Chequeando la posición en Y
	if (int(position.y) % 32) != 0:
		if input_direction == Vector2(0, -1):
			while(int(position.y) % 32) != 0:
				position.y -= 1
		if input_direction == Vector2(0, 1):
			while (int(position.y) % 32) != 0:
				position.y += 1


func play_walk_animation() -> void:
	if input_direction == Vector2(0, 1):
		animation_player.play("down_animation")
	elif input_direction == Vector2(-1, 0):
		animation_player.play("left_animation")
	elif input_direction == Vector2(1, 0):
		animation_player.play("right_animation")
	elif input_direction == Vector2(0, -1):
		animation_player.play("up_animation")
	else:
		if last_input_direction == Vector2(0, 1):
			animation_player.play("idle_down")
		elif last_input_direction == Vector2(-1, 0):
			animation_player.play("idle_left")
		elif last_input_direction == Vector2(1, 0):
			animation_player.play("idle_right")
		elif last_input_direction == Vector2(0, -1):
			animation_player.play("idle_up")


func play_run_animation() -> void:
	if input_direction == Vector2(0, 1):
		animation_player.play("down_run_animation")
	elif input_direction == Vector2(-1, 0):
		animation_player.play("left_run_animation")
	elif input_direction == Vector2(1, 0):
		animation_player.play("right_run_animation")
	elif input_direction == Vector2(0, -1):
		animation_player.play("up_run_animation")
	else:
		if last_input_direction == Vector2(0, 1):
			animation_player.play("idle_down")
		elif last_input_direction == Vector2(-1, 0):
			animation_player.play("idle_left")
		elif last_input_direction == Vector2(1, 0):
			animation_player.play("idle_right")
		elif last_input_direction == Vector2(0, -1):
			animation_player.play("idle_up")


func _input(event):
	if event.is_action_pressed("interactuar"):
		interactuar.emit(last_input_direction)
	
#	if event.is_action_pressed("down"):
#		tile_a_mover = initial_position + Vector2(0, 1) * TILE_SIZE
#	if event.is_action_pressed("up"):
#		tile_a_mover = initial_position + Vector2(0, -1) * TILE_SIZE
#	if event.is_action_pressed("left"):
#		tile_a_mover = initial_position + Vector2(-1, 0) * TILE_SIZE
#	if event.is_action_pressed("right"):
#		tile_a_mover = initial_position + Vector2(1, 0) * TILE_SIZE
#
#	if  tile_a_mover in Global.tiles_no_disponibles:
#		can_move_there = false
#	else:
#		can_move_there = true

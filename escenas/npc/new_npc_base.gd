extends CharacterBody2D


@export var walk_speed: int = 100
@export var nombre: String = "NPC prueba"

enum NPCMove { UP, DOWN, LEFT, RIGHT }
var moves: Array = [
	NPCMove.RIGHT, NPCMove.RIGHT, NPCMove.RIGHT, NPCMove.RIGHT,
	NPCMove.DOWN, NPCMove.DOWN,
	NPCMove.LEFT,
	NPCMove.RIGHT,
	NPCMove.UP, NPCMove.UP,
	NPCMove.LEFT, NPCMove.LEFT, NPCMove.LEFT, NPCMove.LEFT
	]
var move_index = 0
var current_move: NPCMove = moves[move_index]

enum PlayerState { IDLE, TURNING, WALKING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN}
var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN

var direction: Vector2
var new_position: Vector2
var moved: bool = true
var interactuable  # Esto es para verificar en el script del jugador si es interactuable
var talk_direction: Vector2 = Vector2.ZERO

@onready var colision = $CollisionShape2D
@onready var ray = $RayCast2D
@onready var move_timer = $MoveTimer
@onready var anim_tree = $AnimationTree
@onready var playback = anim_tree.get("parameters/playback")


func _ready():
	anim_tree.active = true
	new_position = position


func _physics_process(delta):
	if position.x != colision.global_position.x - 16 or position.y != colision.global_position.y - 16:
		playback.travel("Walk")
		move(delta)
	else:
		process_move()


func process_move() -> void:
	if moved:
		if current_move == NPCMove.DOWN and colision.global_position == position + Vector2(16, 16):
			direction = Vector2(0, 1)
			check_colision()
			if not ray.is_colliding():
				colision.global_position += direction * 32
				update_new_move()
				moved = false
		elif current_move == NPCMove.UP and colision.global_position == position + Vector2(16, 16):
			direction = Vector2(0, -1)
			check_colision()
			if not ray.is_colliding():
				colision.global_position += direction * 32
				update_new_move()
				moved = false
		elif current_move == NPCMove.LEFT and colision.global_position == position + Vector2(16, 16):
			direction = Vector2(-1, 0)
			check_colision()
			if not ray.is_colliding():
				colision.global_position += direction * 32
				update_new_move()
				moved = false
		elif current_move == NPCMove.RIGHT and colision.global_position == position + Vector2(16, 16):
			direction = Vector2(1, 0)
			check_colision()
			if not ray.is_colliding():
				colision.global_position += direction * 32
				update_new_move()
				moved = false
		else:
			direction = Vector2.ZERO
	
	anim_tree.set("parameters/Idle/blend_position", direction)
	anim_tree.set("parameters/Walk/blend_position", direction)
	anim_tree.set("parameters/Turn/blend_position", direction)


func update_new_move() -> void:
	new_position = colision.global_position - Vector2(16, 16)


func move(delta):
	position = position.move_toward(new_position, walk_speed * delta)
	colision.global_position = new_position + Vector2(16, 16)
	if position == new_position:
		playback.travel("Idle")
		move_timer.start()
		change_move()


func check_colision() -> void:
	var desired_step = direction * 16
	ray.target_position = desired_step
	ray.force_raycast_update()


func change_move() -> void:
	if move_index + 1 == len(moves):
		move_index = 0
	else:
		move_index += 1
	
	current_move = moves[move_index]


func _on_move_timer_timeout():
	moved = true


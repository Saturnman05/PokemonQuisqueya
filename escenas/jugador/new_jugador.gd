extends CharacterBody2D


@export var WALK_SPEED: int = 100
@export var RUN_SPEED: int = WALK_SPEED * 3

enum PlayerState { IDLE, TURNING, WALKING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN}
var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.LEFT

var walk_speed: int
var run_speed: int
var direction: Vector2
var new_position: Vector2 = Vector2.ZERO
var moved: bool = true

@onready var colision = $CollisionShape2D
@onready var ray = $RayCast2D
@onready var anim_tree = $AnimationTree
@onready var playback = anim_tree.get("parameters/playback")


func _ready() -> void:
	anim_tree.active = true
	new_position = position


func _physics_process(delta) -> void:
	if player_state == PlayerState.TURNING:
		#colision.global_position = position + Vector2(16, 16)
		return
	elif position.x != colision.global_position.x - 16 or position.y != colision.global_position.y - 16:
		player_state = PlayerState.WALKING
		playback.travel("Walk")
		move(delta)
	else:
		process_input()
		animation_dir()
	
	if Input.is_action_pressed("correr"):
		walk_speed = RUN_SPEED
	else:
		walk_speed = WALK_SPEED


func process_input() -> void:
	if moved:
		if Input.is_action_pressed("down") and colision.global_position == position + Vector2(16, 16):
			direction = Vector2(0, 1)
			check_colision()
			if not ray.is_colliding():
				moved = false
				colision.global_position.y += 32
				update_new_position()
		elif Input.is_action_pressed("up") and colision.global_position == position + Vector2(16, 16):
			direction = Vector2(0, -1)
			check_colision()
			if not ray.is_colliding():
				moved = false
				colision.global_position.y -= 32
				update_new_position()
		elif Input.is_action_pressed("left") and colision.global_position == position + Vector2(16, 16):
			direction = Vector2(-1, 0)
			check_colision()
			if not ray.is_colliding():
				moved = false
				colision.global_position.x -= 32
				update_new_position()
		elif Input.is_action_pressed("right") and colision.global_position == position + Vector2(16, 16):
			direction = Vector2(1, 0)
			check_colision()
			if not ray.is_colliding():
				moved = false
				colision.global_position.x += 32
				update_new_position()
		else:
			direction = Vector2.ZERO
			moved = true


func update_new_position() -> void:
	new_position = colision.global_position - Vector2(16, 16)


func move(delta) -> void:
	position = position.move_toward(new_position, walk_speed * delta)
	colision.global_position = new_position + Vector2(16, 16)
	if position == new_position:
		moved = true


func check_colision() -> void:
	var desired_step = direction * 16
	ray.target_position = desired_step
	ray.force_raycast_update()


func animation_dir() -> void:
	if direction == Vector2.ZERO:
		playback.travel("Idle")
	else:
		anim_tree.set("parameters/Idle/blend_position", direction)
		anim_tree.set("parameters/Walk/blend_position", direction)
		anim_tree.set("parameters/Turn/blend_position", direction)
		
		if need_to_turn():
			player_state = PlayerState.TURNING
			playback.travel("Turn")
		else:
			moved = true


func need_to_turn() -> bool:
	var new_facing_direction
	if direction.x < 0:
		new_facing_direction = FacingDirection.LEFT
	elif direction.x > 0:
		new_facing_direction = FacingDirection.RIGHT
	elif direction.y < 0:
		new_facing_direction = FacingDirection.UP
	elif direction.y > 0:
		new_facing_direction = FacingDirection.DOWN
	
	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true
	
	facing_direction = new_facing_direction
	return false


func finished_turning() -> void:
	player_state = PlayerState.IDLE
	colision.global_position = position + Vector2(16, 16)
	if colision.global_position != position + Vector2(16, 16):
		colision.global_position = position + Vector2(16, 16)
	new_position = position


func _on_area_2d_body_entered(body) -> void:
	if "interactuable" in body:
		if body.position.x < position.x:
			print("izquierda")
			body.talk_direction = Vector2(-1, 0)
		elif body.position.x > position.x:
			print("derecha")
			body.talk_direction = Vector2(1, 0)
		elif body.position.y < position.y:
			print("arriba")
			body.talk_direction = Vector2(0, 1)
		elif body.position.y > position.y:
			print("abajo")
			body.talk_direction = Vector2(0, -1)

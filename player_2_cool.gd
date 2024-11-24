extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anime = $CollisionShape2D/AnimationPlayer
var tex
var m = preload("res://Animations/Running.png")
var i = preload("res://Animations/IdleAnimation.png")

func _ready():
	tex = $CollisionShape2D/Sprite2D

func _process(delta):
	tex.texture = m
	tex.hframes = 4
	tex.vframes = 4
	if Input.is_action_pressed("move_l_2"):
		tex.flip_h = false
		anime.play("PositiveAnimations/Moving")
	elif Input.is_action_pressed("move_r_2"):
		tex.flip_h = true
		anime.play("PositiveAnimations/Moving")
	else:
		tex.texture = i
		tex.hframes = 3
		tex.vframes = 2
		anime.play("PositiveAnimations/Idle")
	


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed("jump_2") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_l_2","move_r_2")
	if direction:
		velocity.x = direction * SPEED * -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

extends CharacterBody2D
class_name Player2

@onready var anime = $AnimationPlayer
@onready var tex = $AnimatedSprite2D
@export var cont: Resource = null
@export var stocks = 3
@export var percent = 1
var JUMP_VELOCITY = 400
var SPEED = 750
var hit = false
var hit_done = true
var jump_done = true
var jumping = false
var jumped = false 
var mem_jump_count = 0
var basicattackright_done = true
var landed = false
var normal2 = false
var normal3 = false
var move_speed = 0
var left = false
var up = false

func _ready():
	add_to_group("Player2")
			
#animations
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(cont.jump):
		tex.offset.x = 0
		jumped = true
		jump_done = false
		tex.animation = "Jump"
		anime.play("PlayerControlled/Jump")
		mem_jump_count += 1
		
	if Input.is_action_just_pressed(cont.attack_1) and jump_done: #separate into combos and prevent moving
		basicattackright_done = false
		tex.animation = "NormalAttack"
		if tex.flip_h == false:
			anime.play("PlayerControlled/BasicAttackRight")
		else:
			anime.play("PlayerControlled/BasicAttackLeft")
	
func _process(delta):
	anime.speed_scale = 1
	if jump_done:
		if basicattackright_done:
			if Input.is_action_pressed(cont.move_right):
				tex.offset.x = 0
				tex.animation = "Moving"
				tex.flip_h = false
				anime.speed_scale = move_speed
				anime.play("PlayerControlled/Move")
				
			elif Input.is_action_pressed(cont.move_left):
				tex.offset.x = 0
				tex.animation = "Moving"
				tex.flip_h = true
				anime.speed_scale = -move_speed
				anime.play("PlayerControlled/Move")
				
			elif is_on_floor():
				if not landed:
					tex.offset.x = 0
					tex.animation = "Landing"
					anime.play("PlayerControlled/Land")
				if landed:
					tex.offset.x = 0
					mem_jump_count = 0
					tex.animation = "Idle"
					anime.play("PlayerControlled/Idle")
				
			elif not is_on_floor():
				tex.offset.x = 0
				landed = false
				tex.animation = "Falling"
				anime.play("PlayerControlled/Fall")


func _physics_process(delta: float) -> void:
	if hit:
		if left:
			velocity = Vector2(500*percent, -30*percent)
			hit_done = false
			hit = false
		if not left:
			velocity = Vector2(-500*percent, -30*percent)
			hit_done = false
			hit = false
		print(velocity)
		move_and_slide()
		print(position)
		
	if not hit_done:
		if velocity.x > 0:
			velocity.x -= 10
			move_and_slide()
		elif velocity.x < 0:
			velocity.x += 10
			move_and_slide()
		else:
			hit_done = true
		
	if not is_on_floor() and not jumping and hit_done:
		velocity.y = 500

	if jumped and mem_jump_count < 2:
		if tex.frame == 3:
			velocity.y = -500
			jumping = true
			jumped = false
			
	if jumping:
		if velocity.y < 0:
			velocity.y += 10
		else:
			jumping = false

	if hit_done:
		var direction := Input.get_axis(cont.move_left, cont.move_right)
		
		if direction and basicattackright_done:
			move_speed = direction*2
			velocity.x = direction * SPEED
				
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
	move_and_slide()

func _on_animation_player_animation_finished(anim_name) -> void:
	if anim_name == "PlayerControlled/Jump":
		jump_done = true
	if anim_name == "PlayerControlled/BasicAttackRight" or anim_name == "PlayerControlled/BasicAttackLeft":
		basicattackright_done = true
		normal2 = false
		normal3 = false
	if anim_name == "PlayerControlled/Land":
		landed = true
		

func _on_hit(x,y):
	if x > position.x:
		left = false
	else:
		left = true
	if y > position.y:
		up = true
	else:
		up = false	
	hit = true
	
func _fell():
	position.x = 1000
	position.y = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player1:
		get_tree().call_group("Player1", "_on_hit", position.x, position.y)

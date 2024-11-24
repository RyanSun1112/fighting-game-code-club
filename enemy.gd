extends RigidBody2D

@onready var p = get_node("%Player")
@onready var a = $AnimatedSprite2D
@onready var an = $AnimationPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if p.position.x > position.x:
		a.animation = "Moving"
		a.flip_h = false
		an.play("PlayerControlled/Move")
		
	elif p.position.x < position.x:
		a.animation = "Moving"
		a.flip_h = true
		an.play("PlayerControlled/Move")
	
	
func _integrate_forces(state):
	
	if p.position.x > position.x:
		state.apply_force(Vector2(200,0))
	elif p.position.x < position.x:
		state.apply_force(Vector2(-200,0))
	
	
		
	
	

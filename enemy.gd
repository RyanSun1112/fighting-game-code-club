extends RigidBody2D
@onready var a = $AnimatedSprite2D
@onready var an = $AnimationPlayer
var yum = Vector2.ZERO

func _ready():
	add_to_group("Player2")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	a.animation = "Moving"
	a.flip_h = false
	an.play("PlayerControlled/Move")
	
func _integrate_forces(state):
	state.apply_force(yum)
	
		
func _on_hit():
	yum = Vector2(100,0)
	print($CollisionShape2D.position)

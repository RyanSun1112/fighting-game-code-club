extends Area2D

var p

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p = get_node("CharacterBody2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if overlaps_body(p):
		gravity = 10000
		gravity_direction = Vector2(0, -1)

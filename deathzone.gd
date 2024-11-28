extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player1:
		get_tree().call_group("Player1", "_fell")
		
	if body is Player2:
		get_tree().call_group("Player2", "_fell")
		
		

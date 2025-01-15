class_name Projectile 

extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2(1, 0).rotated(-rotation.y) * delta
	position.x += velocity.x
	position.z += velocity.y

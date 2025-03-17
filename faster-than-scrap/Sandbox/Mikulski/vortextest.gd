extends CharacterBody3D
#extends RigidBody3D
#extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug("test\n")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += delta * 3


func take_damage(damage: int) -> void:
	print_debug("dmaged")
	print_debug(damage)

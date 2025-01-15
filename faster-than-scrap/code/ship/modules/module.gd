class_name Module

extends Node3D


## Base class for all modules

@export var activation_key: Key = KEY_NONE
@export var hp: int = 100
@export var ship: Ship

## whether module should react to keyboard input (should be inactive when the game is paused)
@export var active: bool = true

var was_key_pressed: bool = false


func _process(_delta: float) -> void:
	if active:
		if was_key_pressed:
			if Input.is_key_pressed(activation_key):
				_on_key(_delta)
			else:
				was_key_pressed = false
				_on_release(_delta)
		else:
			if Input.is_key_pressed(activation_key):
				_on_key_press(_delta)
				was_key_pressed = true

# virtual functions
func _on_key_press(_delta: float) -> void:
	pass

func _on_key(_delta: float) -> void:
	pass

func _on_release(_delta: float) -> void:
	pass


func take_damage(damage: int) -> void:
	hp -= damage
	if hp <=0 :
		_on_destroy()

## destroy self, and detach children
func _on_destroy() -> void:
	_explode()
	for child in self.get_children():
		if child is Module:
			remove_child(child) # detach from node tree
			get_tree().get_root().add_child(child) # attach to scene root
			child.active = false
	queue_free() # delete self as an object

func _explode() -> void:
	# TODO create particles object,
	# which will die after some die by itself
	pass

func detachable() -> bool:
	return true

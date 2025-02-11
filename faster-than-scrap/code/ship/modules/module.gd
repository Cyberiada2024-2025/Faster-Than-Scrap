class_name Module

extends Node3D


## Base class for all modules

@export var activation_key: Key = KEY_NONE
@export var max_hp: int = 100
@export var hp: int = 100
@export var ship: Ship

@export var sprite: Sprite3D
@export var label: Label3D

@export var healthy_color: Color
@export var dead_color: Color

var was_key_pressed: bool = false

func _ready() -> void:
	if(label != null):
		label.text = OS.get_keycode_string(activation_key)
	take_damage(0)

func _process(_delta: float) -> void:
	if was_key_pressed:
		if Input.is_key_pressed(activation_key):
			_on_key(_delta)
		else:
			was_key_pressed = false
			_on_release(_delta)
	else:
		if Input.is_key_pressed(activation_key):
			_on_key_press(_delta)
			_on_key(_delta)
			was_key_pressed = true
	
	if(label != null):
		label.rotation.y = -global_rotation.y
# virtual functions

## Called on one frame, when [member Module.activation_key] has just been pressed
func _on_key_press(_delta: float) -> void:
	pass

## Called on every frame when [member Module.activation_key] is pressed
func _on_key(_delta: float) -> void:
	pass

## Called on one frame, when [member Module.activation_key] has just been released
func _on_release(_delta: float) -> void:
	pass

func take_damage(damage: int) -> void:
	hp -= damage
	sprite.modulate = lerp(dead_color, healthy_color, (float)(hp)/max_hp)
	print(hp/max_hp)
	if hp <=0 :
		_on_destroy()

## Destroy self and detach children
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

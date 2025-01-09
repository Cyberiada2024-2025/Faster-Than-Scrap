extends Node3D

class_name Module

'''
Base class for all modules
'''

@export var activation_key: Key = KEY_NONE
@export var hp: int = 100
@export var ship: Ship

@export var active: bool = true

var was_key_pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
# must be overriden, not extended!
func _on_key_press(_delta: float) -> void:
	print("JUST PRESSED")
	pass
	
func _on_key(_delta: float) -> void:
	print("PRESSING")
	pass
	
func _on_release(_delta: float) -> void:
	print("RELEASE")
	pass
	
	
func take_damage(damage:int)	-> void:
	hp -= damage
	if hp <=0 :
		_on_destroy()	
	
func _on_destroy() -> void:	
	'''will destroy also child modules'''
	# destroy all direct child modules
	for child_module in self.get_children():
		if(child_module.has_method("take_damage")):
			child_module.take_damage(INF)
	queue_free() # delete self as an object	

func _explode() -> void:
	# TODO create particles object, 
	# which will die after some die by itself
	pass

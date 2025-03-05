extends PlayerShip

@export var speed: int

var controller: ShipController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	controller = owner as ShipController  # getting a typed reference to controlled ship


# Called every frame. 'delta' ishe elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var x = 0
	var y = 0

	if Input.is_key_pressed(KEY_A):
		x = -1
	if Input.is_key_pressed(KEY_D):
		x = 1
	if Input.is_key_pressed(KEY_W):
		y = -1
	if Input.is_key_pressed(KEY_S):
		y = 1

	controller.velocity.x = x * speed 
	controller.velocity.y = 0
	controller.velocity.z = y * speed 
	controller.move_and_slide() # already takes delta into account

extends Ship

@export var speed: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	speed = 200																			
	pass # Replace with function body.

							 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var x = 0
	var y =0
	
	if(Input.is_key_pressed(KEY_A)):
		x = 1
	if(Input.is_key_pressed(KEY_D)):
		x = -1
	if(Input.is_key_pressed(KEY_W)):
		y = 1
	if(Input.is_key_pressed(KEY_S)):
		y = -1
		
	velocity.x = move_toward(velocity.x, 0, speed)
	velocity.z = move_toward(velocity.z, 0, speed)
	#velocity.x = x * speed * delta
	velocity.y = 0
	#velocity.z = y * speed * delta
	print(str(velocity) +"  ,  "+str(position))
	move_and_slide()
		

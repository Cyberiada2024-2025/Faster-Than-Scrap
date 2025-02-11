extends Area3D


const VORTEX_TIMER_PATH : String = "res://prefabs/environment/space_vortex/inside_vortex_timer.tscn"
const TIMER_NAME : String = "VortexTimer926452"
const ENLARGMENT_SPEED : float = 1.0   #units per seconds





func _process(delta: float) -> void:
	self.scale.x += delta*ENLARGMENT_SPEED
	self.scale.y += delta*ENLARGMENT_SPEED
	self.scale.z += delta*ENLARGMENT_SPEED


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("affected by vortex"):
		var timer = preload(VORTEX_TIMER_PATH).instantiate()
		timer.name = TIMER_NAME
		body.add_child(timer)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("affected by vortex"):
		for child in body.get_children():
			if child.name == TIMER_NAME:
				child.queue_free()
				break

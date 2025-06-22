class_name AnimateStateOneShot
extends StateNPC

@export var animators_root: Node
@export var condition_name: String = "condition"

var animators: Array[AnimationTree]
var frame_counter: int = 0


func _ready() -> void:
	animators.assign(animators_root.find_children("*", "AnimationTree"))


func enter(_previous_state_path: String, _data := {}) -> void:
	# start playing in each animator
	_set_param(1)
	frame_counter = 2


func _process(delta: float) -> void:
	frame_counter -= 1
	if frame_counter == 0:
		# remove the flag, the animator will continue
		_set_param(0)


func exit() -> void:
	# in case remove the flag
	_set_param(0)


func _set_param(value) -> void:
	var animators_to_remove = []

	for animator: AnimationTree in animators:
		if is_instance_valid(animator):
			animator.set("parameters/conditions/" + condition_name, value)
		else:
			animators_to_remove.append(animator)

	# remove deleleted animators
	for animator in animators_to_remove:
		animators.erase(animator)

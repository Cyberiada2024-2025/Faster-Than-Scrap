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
	for animator: AnimationTree in animators:
		animator.set("parameters/conditions/" + condition_name, 1)
	frame_counter = 2


func _process(delta: float) -> void:
	frame_counter -= 1
	if frame_counter == 0:
		# remove the flag, the animator will continue
		for animator: AnimationTree in animators:
			animator.set("parameters/conditions/" + condition_name, 0)


func exit() -> void:
	# in case remove the flag
	for animator: AnimationTree in animators:
		animator.set("parameters/conditions/" + condition_name, 0)

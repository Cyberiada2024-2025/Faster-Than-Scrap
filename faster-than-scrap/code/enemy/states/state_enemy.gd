class_name StateEnemy extends State


const IDLE = "Idle"
const AGGRESIVE = "Aggresive"
const DEFENSIVE = "Defensive"

# uncomment after prototyping
var enemy: Ship

func _ready() -> void:
	await owner.ready
	enemy = owner as Ship	# getting a typed reference to controlled ship
	assert(enemy != null, "The enemy state needs the owner to be an Enemy node")

func move_target_spotted(min_range_to_player: int, target: Ship) -> void:
	var vector_to_target = target.global_position - enemy.global_position
	var direction = vector_to_target.normalized()
	
	if vector_to_target.length() > min_range_to_player:
		enemy.velocity = direction*enemy.speed;
		enemy.move_and_slide()
	enemy.look_at(target.position)

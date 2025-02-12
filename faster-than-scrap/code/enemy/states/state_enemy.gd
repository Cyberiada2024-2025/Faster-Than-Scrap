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

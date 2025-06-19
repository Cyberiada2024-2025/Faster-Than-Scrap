class_name Damage

extends Resource

## Represents the damage given and taken in the game

enum Type { NORMAL, COLLISION, VORTEX, CONSTANT }

## The actual value of the damage (how many HP should be removed by it)
@export var value: float

@export var type: Type


func _init(damage_value: float = 0, damage_type: Type = Type.NORMAL):
	value = damage_value
	type = damage_type


func _to_string():
	return "Damage " + str(value) + " (" + str(type) + ")"


## Returns damage increased by [code]other_damage[/code].
## Does not modify the original damage.
func add(other_damage: Damage) -> Damage:
	var damage_type: Type
	if other_damage.type == type:
		damage_type = type
	else:
		damage_type = Type.NORMAL  # todo?
	return Damage.new(value + other_damage.value, damage_type)


## Returns damage multiplied by [code]other_damage[/code].
## Does not modify the original damage.
func multiply(multiplier: float) -> Damage:
	return Damage.new(value * multiplier, type)


## Returns 0 if [code]damage1[/code] and [code]damage2[/code] have equal value.
## Returns values greater than 0 if [code]damage1[/code] has greater value.
## Returns values lesser than 0 if [code]damage2[/code] has greater value.
static func compare(damage1: Damage, damage2: Damage) -> float:
	return damage1.value - damage2.value

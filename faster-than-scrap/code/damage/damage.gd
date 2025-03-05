class_name Damage

extends Resource

## Represents the damage given and taken in the game

## The actual value of the damage (how many HP should be removed by it)
@export var value: float


func _init(damage_value: float = 0):
	value = damage_value


func _to_string():
	return "Damage " + str(value)


## Returns damage increased by [code]other_damage[/code].
## Does not modify the original damage.
func add(other_damage: Damage) -> Damage:
	return Damage.new(value + other_damage.value)


## Returns damage multiplied by [code]other_damage[/code].
## Does not modify the original damage.
func multiply(multiplier: float) -> Damage:
	return Damage.new(value * multiplier)


## Returns 0 if [code]damage1[/code] and [code]damage2[/code] have equal value.
## Returns values greater than 0 if [code]damage1[/code] has greater value.
## Returns values lesser than 0 if [code]damage2[/code] has greater value.
static func compare(damage1: Damage, damage2: Damage) -> float:
	return damage1.value - damage2.value

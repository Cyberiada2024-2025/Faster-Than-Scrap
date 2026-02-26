class_name EnemySpawner
extends CapturePoint

@export var enemy_prefab: PackedScene = preload("res://prefabs/npc/enemies/fighter.tscn")
@export var spawn_range: float = 40
@export var spawn_interval: float = 5
@export var max_enemies: int = 3

# short name -> scene
@export var enemies_dict: Dictionary[String, PackedScene]
@export var help_label: RichTextLabel
@export var lide_edit: LineEdit

var _spawn_timer: float = spawn_interval
var _spawned_enemies: Array[NPC] = []


func _ready() -> void:
	_show_help()


func _spawn() -> void:
	var enemy: NPC = enemy_prefab.instantiate()
	var offset_2d = RandomUtils._random_on_edge_unit_circle() * spawn_range
	var offset_3d = Vector3(offset_2d.x, 0, offset_2d.y)
	get_tree().current_scene.add_child.call_deferred(enemy)
	enemy.global_position = global_position + offset_3d
	_spawned_enemies.append(enemy)

	enemy.ship.destroyed.connect(_remove_enemy)


func _spawn_specific(name: String, count: int) -> void:
	if name == "bj" or name == "bv" or name == "bl":
		for x in range(count):
			var bs = BossSpawner.new()
			#var bu = BossUI.new()
			add_child(bs)
			bs._spawn_boss(enemies_dict.get(name))
		#add_child(bu)
		return

	for x in range(count):
		var enemy: NPC = enemies_dict.get(name).instantiate()
		var offset_2d = RandomUtils._random_on_edge_unit_circle() * spawn_range
		var offset_3d = Vector3(offset_2d.x, 0, offset_2d.y)
		get_tree().current_scene.add_child.call_deferred(enemy)
		enemy.global_position = global_position + offset_3d
		_spawned_enemies.append(enemy)
		enemy.ship.destroyed.connect(_remove_enemy)


func _remove_enemy(enemy: Ship) -> void:
	ArrayUtils.remove_by_field(_spawned_enemies, "ship", enemy)


func _show_help() -> void:
	help_label.text = """
		a b c d f m r s tg tl ts bj bl bv '[type] [count]' 
		default count = 1
		'help' for help
		Press F3 for cheats and shop
	"""
	await get_tree().create_timer(14.51).timeout
	help_label.text = ""


# b 4
func _on_line_edit_text_submitted(new_text: String) -> void:
	var parts = new_text.strip_edges().to_lower().split(" ", false)
	if parts.size() == 0:
		return

	var command = parts[0]
	if command in enemies_dict:
		var count = 1
		if parts.size() > 1:
			count = int(parts[1])
		_spawn_specific(command, count)
	elif command == "help":
		_show_help()
	lide_edit.clear()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_ENTER:
		lide_edit.call_deferred("grab_focus")

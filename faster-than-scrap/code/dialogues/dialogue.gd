class_name Dialogue extends Node
enum Type { INFO, RADIO }
@export var text: String
@export var title: String
@export var radio_choices: Array[String]
@export var radio_results: Array[Dialogue]
@export var next_dialogue: Dialogue
@export var type: Type


func print_dialogue() -> void:
	if type == Type.INFO:
		await PopupInfo.show_popup(title, text)
		if next_dialogue != null:
			next_dialogue.print_dialogue()

	if type == Type.RADIO:
		var selection = await PopupRadio.show_popup(title, text, radio_choices)
		if radio_results != null:
			radio_results[selection].print_dialogue()

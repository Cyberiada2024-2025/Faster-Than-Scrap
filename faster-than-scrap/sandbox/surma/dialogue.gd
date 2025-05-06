class_name Dialogue extends Node
@export var text: String
@export var title: String
@export var radio_choices: Array[String]
@export var radio_results: Array[Dialogue]
@export var next_dialogue: Dialogue

enum Type { info, radio }
@export var type: Type

#func _ready() -> void:
#if type == Type.info:
#await PopupInfo.show_popup(title, text)
#if type == Type.radio:
#await PopupRadio.show_popup(title, text, radioChoices)
#if nextDialogue != null:
#nextDialogue.next_dialogue()


func print_dialogue() -> void:
	if type == Type.info:
		await PopupInfo.show_popup(title, text)
		if next_dialogue != null:
			next_dialogue.print_dialogue()

	if type == Type.radio:
		var selection = await PopupRadio.show_popup(title, text, radio_choices)
		if radio_results != null:
			radio_results[selection].print_dialogue()

class_name Dialogue extends Node
@export var text: String
@export var title: String
@export var radioChoices: Array[String]
@export var radioResults: Array[Dialogue]
@export var nextDialogue: Dialogue

enum Type { info, radio }
@export var type: Type


func _ready() -> void:
	if type == Type.info:
		await PopupInfo.show_popup(title, text)
	if type == Type.radio:
		await PopupRadio.show_popup(title, text, radioChoices)
	if nextDialogue != null:
		nextDialogue.next_dialogue()


func next_dialogue() -> void:
	if type == Type.info:
		await PopupInfo.show_popup(title, text)
	if nextDialogue != null:
		nextDialogue.next_dialogue()

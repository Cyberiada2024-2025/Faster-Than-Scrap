extends Control

var module: Module


func config(module: Module) -> void:
	var rich_text: RichTextLabel = $Panel/MarginContainer/RichTextLabel

	rich_text.text = "[b]" + module.module_name + ":[/b] "
	rich_text.text += String.num_int64(module.prize) + "$\n"

	rich_text.text += module.description

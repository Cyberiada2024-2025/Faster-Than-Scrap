extends Control

var module: Module


func config(module: Module) -> void:
	var rich_text: RichTextLabel = $MarginContainer/RichTextLabel

	rich_text.text = "[b]" + module.module_name + " :[/b] "
	rich_text.text += (
		"[b]"
		+ "[color=#be601e]"
		+ String.num_int64(module.prize)
		+ " [img={width=25} color=#be601e]res://art/fonts/cog.png[/img]"
		+ "[/color]"
		+ "[/b] "
		+ "\n"
	)

	rich_text.text += "[b]" + module.description + "[/b] "

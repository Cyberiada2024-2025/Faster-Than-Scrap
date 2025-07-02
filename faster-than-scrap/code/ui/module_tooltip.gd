extends Control

var module: Module


func config(module: Module) -> void:
	var rich_text: RichTextLabel = $MarginContainer/RichTextLabel

	rich_text.text = "[b]" + module.module_name + " :[/b] "
	rich_text.text += (
		"[b]"
		+ String.num_int64(module.prize)
		+ "[/b] "
		+ "[img={width=25} color=#cc4214]res://art/fonts/cog.png[/img]"
		+ "\n"
	)

	rich_text.text += "[b]" + module.description + "[/b] "

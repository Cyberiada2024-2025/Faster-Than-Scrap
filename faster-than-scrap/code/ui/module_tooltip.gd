extends Control

var module: Module


func config(module: Module) -> void:
	var rich_text: RichTextLabel = $MarginContainer/RichTextLabel

	rich_text.text = "[b]" + module.module_name + ":[/b] "
	rich_text.text += (
		String.num_int64(module.prize) + "[img={width=20}]res://art/fonts/cog.png[/img]
		[img={width=20}]res://art/fonts/cog2.png[/img]
		[img={width=20}]res://art/fonts/cog3.png[/img]
		[img={width=20}]res://art/fonts/cog4.png[/img]\n"
	)

	rich_text.text += module.description

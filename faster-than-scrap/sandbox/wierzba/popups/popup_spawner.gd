extends Node


func _ready():
	# show first popup
	await PopupInfo.show_popup("title/speaker", "text")

	# then second
	var selection = await PopupRadio.show_popup("title/speaker", "choose", ["1", "2", "3"])
	print("Selected: " + str(selection + 1))

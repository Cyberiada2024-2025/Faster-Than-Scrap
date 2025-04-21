extends Node


func _ready():
	# show first popup
	await PopupInfo._show_popup("User manual", "Please confirm")
	print("User manual confirmed")

	# then second
	var selection = await PopupRadio._show_popup("Radio!!", "Wybierz liczbę!", ["1", "2", "3"])
	print("Selected: " + str(selection + 1))

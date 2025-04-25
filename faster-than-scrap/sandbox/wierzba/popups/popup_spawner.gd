extends Node


func _ready():
	# show first popup
	await PopupInfo.show_popup("User manual", "Please confirm")
	print("User manual confirmed")

	# then second
	var selection = await PopupRadio.show_popup("Radio!!", "Wybierz liczbę!", ["1", "2", "3"])
	print("Selected: " + str(selection + 1))

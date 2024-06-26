extends Button

@onready var settings = %settings




func _on_pressed():
	settings.show()
	get_parent().hide()

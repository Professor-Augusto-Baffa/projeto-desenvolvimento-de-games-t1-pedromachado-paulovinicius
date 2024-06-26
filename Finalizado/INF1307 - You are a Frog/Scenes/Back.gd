extends Button

@onready var main_menu = %MainMenu
@onready var settings = %settings
 
 


func _on_pressed():
	main_menu.show()
	settings.hide()

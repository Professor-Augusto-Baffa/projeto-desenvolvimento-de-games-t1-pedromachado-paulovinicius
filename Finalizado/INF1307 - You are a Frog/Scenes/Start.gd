extends Node


@onready var main_menu = %MainMenu
@onready var Background = %Background




func _on_pressed():
	main_menu.hide()
	get_tree().change_scene_to_file("res://Scenes/Stage.tscn")
	


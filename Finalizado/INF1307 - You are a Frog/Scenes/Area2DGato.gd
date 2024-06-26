extends Area2D

var dialog_text = "Gato: Hahaha, meu dono nunca me
deixava em paz, mas desde que fugi,
estou livre para aproveitar o mundo
da forma que eu quero. ;3"

@onready var dialog_box = get_node("CanvasLayer/Panel")

func _on_body_entered(body):
	if body.is_in_group("main_character"):  # Verifica se o corpo é o personagem
		if not dialog_box.is_active:
			print("entro")
			dialog_box.show_dialog(dialog_text)

func _on_body_exited(body):
	if body.is_in_group("main_character"):  # Verifica se o corpo é o personagem
		if dialog_box.is_active:
			dialog_box.hide_dialog(dialog_text)

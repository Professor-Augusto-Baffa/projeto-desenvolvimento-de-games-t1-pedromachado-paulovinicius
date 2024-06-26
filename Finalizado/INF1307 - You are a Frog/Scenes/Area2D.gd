extends Area2D

# Sinal para notificar quando o personagem entra e sai da água
signal character_entered_water
signal character_exited_water


func _on_body_entered(body):
	if body.is_in_group("main_character"):  # Verifica se o corpo é o personagem
		emit_signal("character_entered_water", body)

func _on_body_exited(body):
	if body.is_in_group("main_character"):  # Verifica se o corpo é o personagem
		emit_signal("character_exited_water", body)

extends Area2D


func _on_attack_box_body_entered(body):
	if body.has_method('handle_hit'):
		body.handle_hit()

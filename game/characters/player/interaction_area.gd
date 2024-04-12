extends Area2D


var last_interactable_body: Node2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if last_interactable_body == null:
			return
		
		last_interactable_body.interact()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("interact"):
		last_interactable_body = body


func _on_body_exited(body: Node2D) -> void:
	if body == last_interactable_body:
		last_interactable_body = null

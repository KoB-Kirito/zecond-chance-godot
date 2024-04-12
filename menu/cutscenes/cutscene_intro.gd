extends Control


@export_file("*.tscn") var next_scene: String


func _ready() -> void:
	BGM.stop()
	%snd_news.play()
	%Timer.start()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("build") or event.is_action_pressed("interact"):
		if %ContinueButton.visible:
			go_next_level()
		else:
			show_continue_button()


func _on_snd_news_finished() -> void:
	show_continue_button()


func show_continue_button() -> void:
	if %ContinueButton.visible:
		return
	
	%ContinueButton.show()
	%ContinueButton.grab_focus()


func go_next_level() -> void:
	get_tree().change_scene_to_file(next_scene)


func _on_continue_button_pressed() -> void:
	go_next_level()


func _on_timer_timeout() -> void:
	%Noise.show()
	var tween = create_tween()
	tween.tween_property(%Player, "position", Vector2(308, 100), 20.0)

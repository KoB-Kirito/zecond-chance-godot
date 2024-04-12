extends Control


## First cutscene or level to start when pressing the start button
@export_file("*.tscn") var first_scene: String


func _ready() -> void:
	BGM.play("res://assets/audio/music/cutscene.ogg")
	
	PauseMenu.enabled = false
	PauseMenu.unpaused.connect(on_unpaused)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	# back out of credits with any key
	if %Credits.visible:
		%Credits.hide()
		return
	
	if event is InputEventMouse or not event.is_pressed():
		return
	
	# grab focus only if needed
	# a bit nicer looking when controlled with mouse imho
	for button: Button in %ButtonContainer.get_children():
		if button.has_focus():
			return
	
	%StartButton.grab_focus()


func _on_start_button_pressed() -> void:
	PauseMenu.enabled = true
	get_tree().change_scene_to_file(first_scene)


func _on_settings_button_pressed() -> void:
	%ColorRect.show()
	%ButtonContainer.hide()
	
	PauseMenu.title = "Einstellungen"
	PauseMenu.toggle()


func on_unpaused() -> void:
	# reset pause menu title
	PauseMenu.title = PauseMenu.default_title
	
	%ColorRect.hide()
	%ButtonContainer.show()
	
	#TODO: Dedicated settings menu


func _on_credits_button_pressed() -> void:
	%CreditsButton.release_focus()
	%Credits.show()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
	#TODO: Solution for browsers


func _on_credits_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		%Credits.hide()

extends CanvasLayer


signal paused
signal unpaused

var enabled: bool = true

var music_bus: int
var effect_bus: int
var voice_bus: int

var title: String:
	get:
		return %TitleLabel.text
	set(value):
		%TitleLabel.text = value

@onready var default_title: String = %TitleLabel.text


func _ready() -> void:
	hide()
	
	music_bus = AudioServer.get_bus_index("Music")
	effect_bus = AudioServer.get_bus_index("SFX")
	voice_bus = AudioServer.get_bus_index("Voices")
	
	%MusicSlider.value = AudioServer.get_bus_volume_db(music_bus)
	%EffectSlider.value = AudioServer.get_bus_volume_db(effect_bus)
	%VoiceSlider.value = AudioServer.get_bus_volume_db(voice_bus)


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, value)


func _on_effect_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(effect_bus, value)


func _on_voice_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(voice_bus, value)


func _unhandled_input(event: InputEvent) -> void:
	if not enabled and not visible:
		return
	
	if event.is_action_pressed("pause"):
		toggle()
		return
	
	if visible and not event is InputEventMouse and event.is_pressed():
		if not %MusicSlider.has_focus() and \
				not %EffectSlider.has_focus() and \
				not %VoiceSlider.has_focus():
			%MusicSlider.grab_focus()


func toggle() -> void:
	visible = !visible
	get_tree().paused = visible
	if visible:
		paused.emit()
	else:
		unpaused.emit()


func grab_focus() -> void:
	%MusicSlider.grab_focus()


# play a sample when value is changed
func _on_music_slider_drag_started() -> void:
	%snd_effects.stop()
	%snd_voices.stop()
	%snd_music.play()

func _on_effect_slider_drag_started() -> void:
	%snd_music.stop()
	%snd_voices.stop()
	%snd_effects.play()

func _on_voice_slider_drag_started() -> void:
	%snd_music.stop()
	%snd_effects.stop()
	%snd_voices.play()


# close on click anywhere outside
func _on_fade_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		toggle()

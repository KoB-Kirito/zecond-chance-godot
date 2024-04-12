extends Node


@export var game_over: AudioStream

var currently_playing: String


func _ready() -> void:
	Events.player_died.connect(on_player_died)


func on_player_died() -> void:
	%MusicPlayer.stop()
	%MusicPlayer.stream = game_over
	currently_playing = "game_over"
	%MusicPlayer.play()


func play(audio_path: String) -> void:
	# don't restart music
	if audio_path == currently_playing:
		return
	currently_playing = audio_path
	
	#TODO: Fade out, fade in
	%MusicPlayer.stop()
	%MusicPlayer.stream = load(audio_path)
	%MusicPlayer.play()


func stop() -> void:
	%MusicPlayer.stop()


func get_stream() -> AudioStream:
	return %MusicPlayer.stream

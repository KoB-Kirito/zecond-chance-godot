extends Area2D


@export_file("*.ogg") var stream: String
@export_enum("Past", "Present") var time: String = "Past"

var present: bool


func _ready() -> void:
	Events.present_started.connect(on_present_started)
	Events.player_died.connect(on_player_died)


func on_present_started() -> void:
	if time == "Past":
		queue_free()
		
	else:
		present = true


func _on_body_entered(body: Node2D) -> void:
	if time == "Present" and not present:
		return
	
	if body is Player:
		body_entered.disconnect(_on_body_entered)
		%AudioStreamPlayer.stream = load(stream)
		%AudioStreamPlayer.play()


func _on_audio_stream_player_finished() -> void:
	queue_free()


func on_player_died() -> void:
	%AudioStreamPlayer.stop()

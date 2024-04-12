extends Node2D


@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var snd_pickup: AudioStreamPlayer = $snd_pickup


func _ready() -> void:
	Events.present_started.connect(on_present_started)


func on_present_started() -> void:
	# remove if present
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		collect()


func collect() -> void:
	area.body_entered.disconnect(_on_area_2d_body_entered)
	sprite.hide()
	
	Events.wood_collected.emit()
	
	snd_pickup.play()
	await snd_pickup.finished
	queue_free()

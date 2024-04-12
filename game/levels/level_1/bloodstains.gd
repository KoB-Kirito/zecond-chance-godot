extends Node


@export var tile_map: TileMap
@export var blood_layer_id: int


func _ready() -> void:
	# hide layer on load
	tile_map.set_layer_modulate(blood_layer_id, Color.TRANSPARENT)
	
	# wait for present
	Events.present_started.connect(on_present_started)


func on_present_started() -> void:
	# make layer visible
	tile_map.set_layer_modulate(blood_layer_id, Color.WHITE)

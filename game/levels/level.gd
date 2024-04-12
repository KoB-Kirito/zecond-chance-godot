class_name Level
extends TileMap


@export var player: Player
@export var blueprint_layer: int
@export var barricade_layer: int
## Next level or cutscene
@export_file("*.tscn") var next_scene: String

var blueprint_h: TileMapPattern = tile_set.get_pattern(0)
var blueprint_v: TileMapPattern = tile_set.get_pattern(1)
var barricade_h: TileMapPattern = tile_set.get_pattern(2)
var barricade_v: TileMapPattern = tile_set.get_pattern(3)

var exit_reached_again: bool

@onready var start_position: Vector2 = player.position


func _ready() -> void:
	Events.exit_reached.connect(on_exit_reached, CONNECT_DEFERRED)
	
	BGM.play("res://assets/audio/music/past.ogg")


func on_exit_reached() -> void:
	if exit_reached_again:
		get_tree().change_scene_to_file(next_scene)
		return
	exit_reached_again = true
	
	#TODO: cutscene, fade, whatever
	
	BGM.play("res://assets/audio/music/present.ogg")
	
	player.position = start_position
	Events.present_started.emit()


func _unhandled_input(event: InputEvent) -> void:#
	# restart level
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

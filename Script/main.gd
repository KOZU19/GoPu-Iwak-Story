extends Node2D
@export var fish_scene: PackedScene
const TARGET_FISH:= 15
const GAME_TIME:= 60.0
const MAX_FISH:= 8

var caught_fish := 0
var time_left := GAME_TIME
var spawn_elapsed := 0.0

var game_over:= false
@onready var timer_label: Label = $TimerLabel
@onready var catch_label: Label = $CatchLabel
@onready var message_label: Label = $Message_label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	message_label.text = ""
	update_ui()
	for i in range(5):
		spawn_fish()
func _process(delta: float) -> void:
	if game_over:
		return
	time_left -= delta
	if time_left <= 0:
		time_left = 0
		game_over = true
		if caught_fish >= TARGET_FISH:
			message_label.text  ="you win!"
		else:
			message_label.text = "you lose"
		update_ui()
		return
	spawn_elapsed += delta
	if spawn_elapsed >= 0.8:
		spawn_elapsed= 0.0
		if get_tree().get_nodes_in_group("fish").size() < MAX_FISH:
			spawn_fish()
	update_ui()
func spawn_fish():
	if fish_scene == null:
		return
	var fish = fish_scene.instantiate()
	add_child(fish)
	fish.add_to_group("fish")
	fish.position = Vector2(randf_range(80, 1000),
	randf_range(130, 520))
	fish.caught.connect(_on_fish_caught)
func _on_fish_caught():
	if game_over:
		return
	caught_fish += 1
	update_ui()
	if caught_fish >= TARGET_FISH:
		game_over = true
		message_label.text = "you caught all the 15 fish! u got gogi"
func update_ui():
	timer_label.text = "time : %02d:%02d" %[
		int(time_left) / 60,
		int(time_left) % 60
	]
	catch_label.text = "fish: %d / %d"%[
		caught_fish, TARGET_FISH
	]

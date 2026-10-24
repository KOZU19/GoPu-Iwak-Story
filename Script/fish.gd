extends Area2D
signal caught
@export var speed: float  =180.0
var direction := Vector2.RIGHT
var pond_rect := Rect2(40, 100, 1000, 500)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_pickable = true
	direction = Vector2(randf_range(-1.0, 1.0),
	randf_range(-1.0, 1.0)).normalized()
func _process(delta):
	position += direction * speed * delta
	if position.x < pond_rect.position.x:
		direction.x = abs(direction.x)
	elif position.x > pond_rect.end.x:
		direction.x = -abs(direction.x)
	if position.y < pond_rect.position.y:
		direction.y = abs(direction.y)
	elif position.y > pond_rect.end.y:
		direction.y = -abs(direction.y)
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	caught.emit()
	queue_free()

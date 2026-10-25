extends Control
const SCOPE_RADIUS_RATIO : float= 0.36
const OUTSIDE_DARKNESS :float= 0.82
var aim_screen_position := Vector2.ZERO
var target_aim_position:  Vector2 = Vector2.ZERO
const AIM_SMOOTHNESS: float = 0.14
var dimmer: ColorRect
var shader_material : ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	dimmer = ColorRect.new()
	dimmer.name = "Dimmer"
	dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dimmer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dimmer.color = Color.WHITE
	var shader :=preload("res://Scene/scope_shader.gdshader")
	shader_material = ShaderMaterial.new()
	dimmer.material = shader_material
	shader_material.shader = shader
	shader_material.set_shader_parameter("scope_radius", SCOPE_RADIUS_RATIO)
	shader_material.set_shader_parameter("darkness", OUTSIDE_DARKNESS)
	dimmer.material = shader_material
	add_child(dimmer)
	dimmer.show_behind_parent = true
	var viewport_size :=  get_viewport_rect().size 
	aim_screen_position = viewport_size / 2.0
	visible= false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not visible:
		return
	var viewport_size := get_viewport_rect().size
	dimmer.material.set_shader_parameter("viewport_size", viewport_size)
	var center := viewport_size / 2.0
	var radius :float = min(
		viewport_size.x, viewport_size.y
	) * SCOPE_RADIUS_RATIO
	var mouse_pos := get_viewport().get_mouse_position()
	shader_material.set_shader_parameter("scope_position",
	mouse_pos / get_viewport_rect().size)
	var offset := mouse_pos - center
	
	if offset.length()>radius - 8.0:
		offset = offset.normalized() * (radius - 8.0)
	target_aim_position = center + offset

	aim_screen_position = target_aim_position
		
	queue_redraw()
		
func _draw() -> void:
	#if not visible:
		#return
	var p := aim_screen_position
	
	
	var cross_color := Color(1.0, 0.2, 0.2, 1.0)
	var gap :float= 5.0
	var line_length :float= 13.0
	draw_line(
		p + Vector2(-line_length, 0.0),
		p + Vector2(-gap, 0.0),
		cross_color, 2.0
	)
	draw_line(
		p + Vector2(gap, 0.0),
		p + Vector2(line_length, 0.0),
		cross_color, 2.0
	)	
	draw_line(
		p + Vector2(0.0, -line_length),
		p + Vector2(0.0, -gap),
		cross_color, 2.0
	)
	draw_line(
		p + Vector2(0.0, gap),
		p + Vector2(0.0, line_length),
		cross_color, 2.0
	)	
	draw_arc(
		p, 3.0, 0.0, TAU, 24, cross_color, 2.0
	)

extends Control
const SCOPE_RADIUS_RATIO := 0.36
const OUTSIDE_DARKNESS := 0.82
var aim_screen_position := Vector2.ZERO
var dimmer: ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	dimmer = ColorRect.new()
	dimmer.name = "Dimmer"
	dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dimmer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shader := Shader.new()
	shader.code = """
shader_type canvas_item;
uniform vec2 viewport_size = vec2(1152.0, 648.0);
uniform float scope_radius = 0.36;
uniform float darkness = 0.82;
void fragment(){
	vec2 p = (UV - vec2(0.5))* viewport_size 
	/ min(viewport_size.x / viewport_size.y);
	float dist = length(p);
	if (dist > scope_radius) {
		COLOR = vec4(0.0, 0.0, 0.0, darkness);
	} else{
		COLOR = vec4(0.0);
	}
}
"""
	var shader_material := ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("scope_radius", SCOPE_RADIUS_RATIO)
	shader_material.set_shader_parameter("darkness", OUTSIDE_DARKNESS)
	dimmer.material = shader_material
	add_child(dimmer)
	aim_screen_position = get_viewport_rect().size / 2.0
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
	var offset := mouse_pos - center
	
	if offset.length()>radius - 8.0:
		offset = offset.normalized() * (radius - 8.0)
		aim_screen_position = center + offset
		queue_redraw()
		
func _draw() -> void:
	if not visible:
		return
	var p := aim_screen_position
	var center := size / 2.0
	var radius :float= min(size.x, size.y) * SCOPE_RADIUS_RATIO
	
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

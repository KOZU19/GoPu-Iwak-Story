shader_type canvas_item;
render_mode unshaded;

uniform vec2 viewport_size = vec2(1152.0, 648.0);
uniform float scope_radius = 0.36;
uniform float darkness = 0.82;
uniform float blur_width =24.0;
uniform vec2 scope_position = vec2(0.5, 0.5);
void fragment(){
	vec2 centered = (UV - scope_position)*viewport_size;
	float dist = length(centered);
	float radius = min(viewport_size.x, viewport_size.y) *scope_radius;
	float edge = smoothstep(radius - blur_width, radius + blur_width, dist);
	COLOR = vec4(0.0, 0.0, 0.0,edge* darkness);
	//if (dist > scope_radius) {
		//COLOR = vec4(0.0, 0.0, 0.0, darkness);
	//} else{
		//COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	//}
}
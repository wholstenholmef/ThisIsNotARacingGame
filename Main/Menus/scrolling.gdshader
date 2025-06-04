shader_type canvas_item;

uniform float x_speed;
uniform float y_speed;

void fragment () {
	vec2 offset_vec = vec2(UV.x + TIME * x_speed, UV.y + TIME * y_speed);
	vec4 tex_color = texture(TEXTURE, offset_vec);
	COLOR.rgb = tex_color.rgb;
}
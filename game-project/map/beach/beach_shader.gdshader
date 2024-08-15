shader_type canvas_item;

uniform vec4 color : source_color = vec4(1,1,1,1);
uniform vec4 color_edge : source_color = vec4(1,1,1,1);
uniform sampler2D noise_tex;
uniform bool fade_alpha = true;

void fragment() 
{
	vec2 uv_scaled = UV;
	uv_scaled.x *= 5.0;
	uv_scaled.x = uv_scaled.x - floor(uv_scaled.x);
	
	float noise_val = texture(noise_tex, uv_scaled).r;
	vec2 uv = uv_scaled + 0.25*noise_val;
	float dist_from_bottom_edge = clamp(3.0 * (1.0 - 0.66*uv.y), 0.0, 1.0);
	COLOR = mix(color, color_edge, 1.0 - dist_from_bottom_edge);
	if(UV.y > 0.9 && fade_alpha)
	{
		COLOR.a *= (1.0 - UV.y) / (1.0 - 0.9);
	}
}

shader_type canvas_item;

uniform vec2 pixel_size = vec2(512, 512);
uniform vec4 color : source_color = vec4(1,1,1,1);
uniform vec4 color_shore : source_color = vec4(1,1,1,1);
uniform vec4 color_foam : source_color = vec4(1,1,1,1);
uniform sampler2D noise_tex;

uniform vec2 tile_size = vec2(128.0, 128.0);
uniform float falloff_dist = 32.0;
uniform float gradient_dist = 64.0;

void fragment() 
{
	vec2 scale = pixel_size / tile_size;
	vec2 uv_scaled = UV * scale;
	uv_scaled.x = uv_scaled.x - floor(uv_scaled.x);
	uv_scaled.y = uv_scaled.y - floor(uv_scaled.y);
	
	float noise_val = texture(noise_tex, uv_scaled).r;
	vec2 uv = uv_scaled + 0.25*noise_val;
	
	vec2 uv_real = UV * pixel_size;
	vec2 uv_real_noisy = (UV - 0.05 + 0.1*noise_val) * pixel_size;
	
	float time = 0.25 * TIME * (1.0 + 0.005*noise_val);
	float foam_line = time - floor(time);
	float foam_blend = 0.0;
	float threshold = 0.075;
	float dist = abs(uv.y - foam_line);
	if( dist < threshold ) { foam_blend = 1.0 - dist / threshold; }
	
	// some gradient as we near the shore
	float gradient_factor = clamp(uv_real_noisy.y / gradient_dist, 0.0, 1.0);
	vec4 col = mix(color_shore, color, gradient_factor);
	
	col = mix(col, color_foam, foam_blend);
	COLOR = col;
	
	// alpha falloff to neatly blend into area above
	if(uv_real.y < falloff_dist)
	{
		COLOR.a *= uv_real.y / falloff_dist;
	}
}
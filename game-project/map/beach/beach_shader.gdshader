shader_type canvas_item;

uniform vec2 pixel_size = vec2(512, 512);
uniform vec4 color : source_color = vec4(1,1,1,1);
uniform vec4 color_edge : source_color = vec4(1,1,1,1);
uniform sampler2D noise_tex;
uniform bool fade_alpha = true;

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
	vec2 uv_real = UV * pixel_size;
	vec2 uv_real_noisy = (UV - 0.05 + 0.1*noise_val) * pixel_size;
	
	vec2 uv = uv_scaled + 0.25*noise_val;
	float dist_from_bottom_edge = clamp((pixel_size.y - uv_real_noisy.y) / gradient_dist, 0.0, 1.0);
	COLOR = mix(color, color_edge, 1.0 - dist_from_bottom_edge);
	
	if(uv_real.y > (pixel_size.y - falloff_dist) && fade_alpha)
	{
		COLOR.a *= (pixel_size.y - uv_real.y) / falloff_dist;
	}
}

shader_type canvas_item;

uniform sampler2D noise_tex;
uniform vec4 color : source_color = vec4(1,1,1,1);
uniform float jaggy_start_threshold = 0.05;
uniform float noise_hard_cutoff_threshold = 0.3;
uniform float speed = 1.0;
uniform float noise_scale = 1.0;
uniform float seed = 0.0;
uniform bool use_screen_uv = true;

void fragment()
{
	float dist_to_edge = 0.5 - distance(UV, vec2(0.5));
	
	COLOR = color;
	if(dist_to_edge <= noise_scale * jaggy_start_threshold)
	{
		vec2 screen_uv = use_screen_uv ? (-0.5 + SCREEN_UV) : vec2(0.0);
		vec2 rand_uv = UV + (seed + 1.0) * screen_uv + (seed + 1.0) * 0.1*cos(sin(TIME * speed));
		rand_uv.x = rand_uv.x - floor(rand_uv.x);
		rand_uv.y = rand_uv.y - floor(rand_uv.y);

		float noise_val = texture(noise_tex, rand_uv).r * dist_to_edge / (noise_scale * jaggy_start_threshold);
		if(noise_val <= noise_hard_cutoff_threshold)
		{
			COLOR.a = 0.0;
		}
	}

}
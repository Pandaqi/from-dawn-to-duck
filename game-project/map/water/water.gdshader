shader_type canvas_item;

uniform vec4 color : source_color = vec4(1,1,1,1);
uniform vec4 color_shore : source_color = vec4(1,1,1,1);
uniform vec4 color_foam : source_color = vec4(1,1,1,1);
uniform sampler2D noise_tex;

void fragment() 
{
	vec2 uv_scaled = UV;
	uv_scaled.x *= 5.0; // this thing is extremely wide, so tile the x coordinates
	uv_scaled.x = uv_scaled.x - floor(uv_scaled.x);
	
	float noise_val = texture(noise_tex, uv_scaled).r;
	vec2 uv = uv_scaled + 0.25*noise_val;
	
	float time = 0.25 * TIME * (1.0 + 0.005*noise_val);
	float foam_line = time - floor(time);
	float foam_blend = 0.0;
	float threshold = 0.075;
	float dist = abs(uv.y - foam_line);
	if( dist < threshold ) { foam_blend = 1.0 - dist / threshold; }
	float gradient_dist = clamp(uv.y * 3.5, 0.0, 1.0);
	vec4 col = mix(color_shore, color, gradient_dist);
	col = mix(col, color_foam, foam_blend);
	COLOR = col;
	
	if(UV.y < 0.1)
	{
		COLOR.a *= UV.y / 0.1;
	}
}
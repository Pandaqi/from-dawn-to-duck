shader_type canvas_item;

uniform sampler2D noise_tex;
uniform float speed = 0.1;
uniform float circle_radius = 0.25;
uniform float amplitude = 0.2;
uniform vec4 color : source_color = vec4(1,0,0,1);

float circle(vec2 center, float radius, vec2 p)
{
    return length(p - center) - radius;
}

void fragment()
{
    vec4 noise = texture(noise_tex, UV - 0.25*(vec2(0.5) + SCREEN_UV)) - 0.5;
    float sdf = circle(vec2(0.5, 0.5), circle_radius, UV) + amplitude * noise.r;
	vec4 final_col = color;
	if (sdf > 0.0) { final_col.a = 0.0; }
	COLOR = final_col;
}
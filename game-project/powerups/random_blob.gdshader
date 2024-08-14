shader_type canvas_item;

uniform sampler2D noise_tex;
uniform float speed = 0.1;
uniform float circle_radius = 0.25;
uniform float amplitude = 0.2;

float circle(vec2 center, float radius, vec2 p)
{
    return length(p - center) - radius;
}

void fragment()
{
    vec4 noise = texture(noise_tex, UV - 0.25*(vec2(0.5) + SCREEN_UV)) - 0.5;
    float sdf = circle(vec2(0.5, 0.5), circle_radius, UV) + amplitude * noise.r;
	float alpha = 1.0;
	if (sdf > 0.0) { alpha = 0.0; }
	COLOR = vec4(1.0, 0.5, 0.5, alpha);
}
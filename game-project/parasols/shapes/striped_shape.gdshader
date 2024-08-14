shader_type canvas_item;

uniform float scale = 5.0;
uniform vec4 color1 : source_color = vec4(1,1,1,1);
uniform vec4 color2 : source_color = vec4(1,0,0,1);
uniform float alpha = 1.0;

void fragment()
{
	int uv_band = int(floor(UV.x * scale)) % 2;
	if(uv_band == 0) { COLOR = color1; }
	else { COLOR = color2; }
	COLOR.a = alpha;
}

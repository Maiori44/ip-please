vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
	float v = 0.5 * (sin(texture_coords.y * 3.14159 / 1 * love_ScreenSize.y + 1) + 1.0);
	color.rgb -= -color.rgb * (pow(v, 0.1) - 1.0);
	texture_coords = texture_coords * 2.0 - vec2(1.0);
	texture_coords += (texture_coords.yx * texture_coords.yx) * texture_coords * vec2(0.003, 0.003250);
	float mask = (1.0 - smoothstep(0.98, 1.0, abs(texture_coords.x)))
				* (1.0 - smoothstep(0.98, 1.0, abs(texture_coords.y)));
	texture_coords = (texture_coords + vec2(1.0)) / 2.0;
	if (texture_coords.x < 0.0 || texture_coords.y < 0.0 || texture_coords.x > 1.0 ||texture_coords.y > 1.0) {
        return vec4(0.0, 0.0, 0.0, 1.0);
	}
	return Texel(texture, texture_coords) * color;
}
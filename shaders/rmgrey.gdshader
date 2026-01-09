shader_type canvas_item;

// Click this color box in the Inspector and use the eyedropper
// to pick the EXACT grey from your sprite
uniform vec4 target_color : source_color = vec4(0.28, 0.28, 0.28, 1.0);

// Adjust this slider to include more or less similar shades of grey
uniform float threshold : hint_range(0.0, 1.0) = 0.1;

void fragment() {
	vec4 color = texture(TEXTURE, UV);

	// Calculate how different the current pixel is from our target grey
	float difference = distance(color.rgb, target_color.rgb);

	// If the difference is small enough (it matches the grey), make it invisible
	if (difference < threshold){
		color.a = 0.0;
	}

	COLOR = color;
}
shader_type canvas_item;

// In relative units now (0-1)
uniform float zoom = 0.1; // Start with a small value to test!
uniform float sharpness = 2.0;

// (1, 0) for horizontal only, (0, 1) for vertical only
uniform vec2 direction = vec2(1.0, 0.0);

// 0: Repeats, 1: Clamps, 2: Clips
uniform int wrapping_mode : hint_range(0, 2) = 1;

void fragment() {
    // FIX 1: Use UV (0 to 1 mapping of the sprite) instead of SCREEN_UV
    vec2 uv = UV; 
    vec2 ndir = normalize(direction);
    
    // Calculate the distortion
    float fac1 = abs(dot(uv - 0.5, normalize(ndir.yx))) * 2.0;
    float fac2 = -dot(uv - 0.5, normalize(ndir)) * 2.0;
    
    // Calculate new coordinate
    vec2 new_uv = uv + pow(fac1, sharpness) * fac2 * zoom * ndir;
    
    // FIX 2: Handle wrapping logic with standard if/else for safety
    if (wrapping_mode == 2) { // Clip
        if (new_uv.x < 0.0 || new_uv.x > 1.0 || new_uv.y < 0.0 || new_uv.y > 1.0) {
            COLOR = vec4(0.0); // Transparent
        } else {
            // FIX 3: Read from TEXTURE (the sprite) not SCREEN_TEXTURE
            COLOR = texture(TEXTURE, new_uv);
        }
    } else {
        if (wrapping_mode == 0) { // Repeat
             new_uv = fract(new_uv);
        } else { // Clamp (Mode 1)
             new_uv = clamp(new_uv, vec2(0.0), vec2(1.0));
        }
        // FIX 3: Read from TEXTURE
        COLOR = texture(TEXTURE, new_uv); 
    }
}
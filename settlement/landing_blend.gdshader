shader_type canvas_item;
uniform vec2 feet;
uniform vec2 viewport_size;
uniform float previous_room = 1.0;

void fragment() {
 vec4 old = texture(TEXTURE, UV);
 vec2 d = (UV * viewport_size - feet + vec2(0.0, 26.0)) / vec2(31.0, 49.0);
 float room = smoothstep(0.95, 1.55, length(d));
 // Keep the live dwarf, input prompts, and HUD readable during the dissolve.
 float hud = smoothstep(75.0, 105.0, UV.y * viewport_size.y);
 COLOR = vec4(old.rgb, old.a * room * hud * previous_room);
}

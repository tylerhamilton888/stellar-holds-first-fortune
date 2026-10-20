shader_type canvas_item;
render_mode unshaded;
uniform vec4 skin_tint:source_color=vec4(0.95,0.84,0.74,1.0);
uniform vec4 cloth_tint:source_color=vec4(0.25,0.49,0.51,1.0);
void fragment(){
 vec4 c=texture(TEXTURE,UV);
 float lightness=dot(c.rgb,vec3(0.30,0.55,0.15));
 // Warm skin clusters are mapped to a coordinated fair-complexion ramp.
 if(c.r>0.40 && c.r>c.g*1.12 && c.g>c.b*1.12){
  float shade=clamp((lightness-0.20)/0.58,0.0,1.0);
  vec3 low=skin_tint.rgb*vec3(0.56,0.39,0.36);
  c.rgb=mix(low,skin_tint.rgb,shade);
 }
 COLOR=c;
}

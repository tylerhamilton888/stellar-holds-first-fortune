shader_type canvas_item;
uniform vec2 grid = vec2(768.0,256.0);
uniform vec4 haze : source_color = vec4(0.19,0.27,0.32,0.22);
void fragment(){
 vec2 pixel=(floor(UV*grid)+0.5)/grid;
 vec4 tex=texture(TEXTURE,pixel);
 float grey=dot(tex.rgb,vec3(.25,.6,.15));
 vec3 calm=mix(tex.rgb,vec3(grey),.19);
 calm=(calm-vec3(.42))*.80+vec3(.42);
 COLOR=vec4(mix(calm,haze.rgb,haze.a),tex.a);
}

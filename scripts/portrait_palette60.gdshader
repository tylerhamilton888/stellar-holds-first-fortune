shader_type canvas_item;
render_mode unshaded;

// Resolve the reserved source pigments BEFORE filtering, as whole_frames.gd does.
// This avoids violet fringes and keeps every saved colour live without CPU painting.
uniform vec4 hair_colour : source_color;
uniform vec4 cloth_colour : source_color;
uniform vec4 skin_colour : source_color;
uniform vec4 metal_colour : source_color;
uniform bool change_metal = false;

vec3 hsv(vec3 c) {
 vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
 vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
 vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
 float d = q.x - min(q.w, q.y);
 return vec3(abs(q.z + (q.w-q.y)/(6.0*d+1.0e-10)), d/(q.x+1.0e-10), q.x);
}
vec3 rgb(vec3 c) {
 vec3 p = abs(fract(c.xxx + vec3(0.0, 2.0/3.0, 1.0/3.0))*6.0-3.0);
 return c.z * mix(vec3(1.0), clamp(p-1.0, 0.0, 1.0), c.y);
}
vec3 dye(vec3 c, vec3 target, vec3 source) {
 vec3 a=hsv(c); vec3 b=hsv(target); vec3 s=hsv(source);
 return rgb(vec3(fract(a.x+b.x-s.x), clamp(a.y*b.y/max(.1,s.y),0.0,1.0), clamp(a.z*b.z/max(.1,s.z),0.0,1.0)));
}
vec4 resolve(vec4 c) {
 if(c.a<=0.0) return vec4(0.0);
 vec3 a=hsv(c.rgb);
 if(c.r>c.g && c.b>c.g) {
  float pigment=min(c.r-c.g,c.b-c.g);
  float coverage=clamp(2.0*(c.b-c.g)/max(c.r-c.g,1.0/255.0),0.0,1.0)*clamp(pigment*64.0,0.0,1.0);
  vec3 h=hsv(hair_colour.rgb);
  vec3 painted=rgb(vec3(h.x,h.y*clamp(a.y/.32,.65,1.15),clamp(h.z*a.z/.58,0.0,1.0)));
  c.rgb=mix(vec3(c.r,c.g,min(c.b,c.g)),painted,coverage);
  c.g=max(c.g,min(c.r,c.b));
 } else if(a.x>.46 && a.x<.67 && a.y>.20) {
  c.rgb=dye(c.rgb,cloth_colour.rgb,vec3(53.0,100.0,119.0)/255.0);
 } else if(a.x>.015 && a.x<.10 && a.z>.62 && a.y>.15 && a.y<.64) {
  c.rgb=dye(c.rgb,skin_colour.rgb,vec3(243.0,214.0,188.0)/255.0);
 } else if(change_metal && a.x>.105 && a.x<.17 && a.y>.45 && a.z>.4) {
  c.rgb=dye(c.rgb,metal_colour.rgb,vec3(216.0,166.0,81.0)/255.0);
 }
 return c;
}
bool is_hair(vec4 c) { return c.a>0.0 && c.r>c.g && c.b>c.g; }
void fragment() {
 vec2 size=vec2(textureSize(TEXTURE,0));
 vec2 pos=UV*size-.5;
 ivec2 base=ivec2(floor(pos));
 ivec2 last=ivec2(size)-ivec2(1);
 vec2 weight=fract(pos);
 vec4 ra=texelFetch(TEXTURE,clamp(base,ivec2(0),last),0);
 vec4 rb=texelFetch(TEXTURE,clamp(base+ivec2(1,0),ivec2(0),last),0);
 vec4 rc=texelFetch(TEXTURE,clamp(base+ivec2(0,1),ivec2(0),last),0);
 vec4 rd=texelFetch(TEXTURE,clamp(base+ivec2(1),ivec2(0),last),0);
 vec4 a=resolve(ra);vec4 b=resolve(rb);vec4 c=resolve(rc);vec4 d=resolve(rd);
 // Interpolate premultiplied colour to keep transparent edges clean.
 a.rgb*=a.a; b.rgb*=b.a; c.rgb*=c.a; d.rgb*=d.a;
 vec4 result=mix(mix(a,b,weight.x),mix(c,d,weight.x),weight.y);
 if(result.a>0.0) result.rgb/=result.a;
 // Cool Raven hair blended with warm skin can recreate a mauve fringe.
 // Constrain only pixels that actually sample source hair; leave clothes alone.
 if(is_hair(ra)||is_hair(rb)||is_hair(rc)||is_hair(rd)) result.g=max(result.g,min(result.r,result.b));
 COLOR=result;
}

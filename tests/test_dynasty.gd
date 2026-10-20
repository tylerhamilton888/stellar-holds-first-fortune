extends SceneTree
var failures=0
func check(ok:bool,message:String):
 if not ok:failures+=1;push_error(message)
func _initialize():call_deferred("run")
func run():
 var legacy=HoldAppearance.normalized({"name":"Moira Ash Forge"})
 check(legacy.first_name=="Moira" and legacy.family_name=="Ash Forge","Legacy names retain compound surnames")
 var lord=HoldAppearance.npc_profile("eirik",123)
 check(lord.first_name=="Eirik" and lord.family_name=="Granitecrown" and lord.title=="Lord","Titles stay separate from given names")
 var s=HoldState.new();s.reset(123);s.appearance=legacy;s.ensure_dynasty()
 var original=s.dynasty.duplicate(true)
 s.appearance.first_name="Eira";s.appearance.family_name="Wrong";s.ensure_dynasty()
 check(s.dynasty==original and s.appearance.name=="Eira Ash Forge","Given-name changes preserve dynasty identity")
 var g=Geology.new();g.generate(123);s.save_world(g,"hub",Vector2(150,410))
 var restored=HoldState.new();restored.load_world(Geology.new())
 check(restored.dynasty==original and restored.appearance.first_name=="Eira","House and personal identity persist independently")
 var f=FileAccess.open(HoldState.SAVE,FileAccess.READ);var d=JSON.parse_string(f.get_as_text());f.close()
 d.erase("dynasty");d.appearance={"name":"Astrid Copperbraid"}
 f=FileAccess.open(HoldState.SAVE,FileAccess.WRITE);f.store_string(JSON.stringify(d));f.close()
 restored.load_world(Geology.new())
 check(restored.dynasty.family_name=="Copperbraid" and restored.appearance.first_name=="Astrid","Legacy saves establish the correct house")
 print("DYNASTY: %d FAILED" % failures);quit(1 if failures else 0)

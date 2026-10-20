class_name HoldCharacterDesigns
extends RefCounted
# A design owns ALL of its animation sources. New states must be reviewed against
# its normal reference, not selected independently for a similar-looking beard.
const REVISION=39
const NORMAL_MALE=["actors-v11/male", "actors-v17/braided-normal", "actors-v18/male2-normal", "actors-v18/male3-normal", "actors-v18/male4-normal"]
const NORMAL_FEMALE=["actors-v11/female", "actors-v18/female1-normal", "actors-v18/female2-normal", "actors-v18/female3-normal", "actors-v19/female4-normal"]
const ARMED_MALE=["classic","braided","pair1","pair2","pair3"]
const ARMED_FEMALE=["classic","pair1","pair2","pair3","pair4"]
static var images:Dictionary={}
static func id(profile:Dictionary)->String:
 return ("female" if int(profile.gender)==1 else "male")+str(clampi(int(profile.get("sculpt",0)),0,4))
static func path(profile:Dictionary,mode:String)->String:
 var index=clampi(int(profile.get("sculpt",0)),0,4)
 if mode=="normal":return "res://assets/"+(NORMAL_FEMALE if profile.gender else NORMAL_MALE)[index]+".png"
 assert(mode in ["combat","walk","guard"])
 var pair=(ARMED_FEMALE if profile.gender else ARMED_MALE)[index]
 if pair=="classic" and mode in ["combat","guard"]:return "res://assets/actors-v19/classic-"+mode+"-clean.png"
 return "res://assets/actors-v19/"+pair+"-"+mode+("-refined" if pair in ["classic","pair1","pair2","pair4"] else "")+".png"
static func image_for(profile:Dictionary,mode:String)->Image:
 var asset=path(profile,mode)
 if not images.has(asset):images[asset]=load(asset).get_image()
 return images[asset]

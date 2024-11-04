extends CharacterBody3D

@export var player_move_speed = 5.0

#main guitar player script.

#read and parse the music xml file useing godot XML parser to get the number of total quarter note beats (inlcuding rests) in the song, tempo,
#notes (inlcuding their length*take length as a fraction of quarternote length and convert to seconds*, 
#pitch *convert this to guitar string and fret, if accidental sharp or flat convert to regular notes*, 
#and position in the song the start time and end time in seconds from song start), 
#add dynamics support. 

#parsed parts should include musicXML dynamics, pitch(inlcudes note and octave), measure maybe? (again probly good for looking ahead?)
#duration (not sure about what this means...) and type of beat (quarter, eighth, etc...),
#notations maybe? (tell you if the notes are tied to others or not... should be useful for looking ahead
#the only notes that need to be looked ahead at are probably checking for chords, eighths or quicker until you get to really fast tempos)

#audio could use the output midi file instead of generated music worst case. but it would be piano music...
#


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#left_lower_arm_iktarget.set_lower_arm_target(left_lower_arm_gtarget)
	#left_hand_iktarget.set_hand_target(left_hand_gtarget)
	left_index_iktarget.set_finger_target(left_index_gtarget)
	left_middle_iktaret.set_finger_target(left_middle_gtaret)
	left_ring_iktarget.set_finger_target(left_ring_gtarget)
	left_pinky_iktarget.set_finger_target(left_pinky_gtarget)
	pass # Replace with function body.

#@onready var left_lower_arm_iktarget = $"Armature/Skeleton3D/LCollar_Attach/LUpperArm_Attach/Target_LLowerArm"
#@onready var left_hand_iktarget = $"Armature/Skeleton3D/LCollar_Attach/LUpperArm_Attach/LLowerArm_Attach/Target_LHand"
@onready var left_index_iktarget = $"Armature/Skeleton3D/LCollar_Attach/LUpperArm_Attach/LLowerArm_Attach/LHand_Attach/Target_LIndex3"
@onready var left_middle_iktaret = $"Armature/Skeleton3D/LCollar_Attach/LUpperArm_Attach/LLowerArm_Attach/LHand_Attach/Target_LMiddle3"
@onready var left_ring_iktarget = $"Armature/Skeleton3D/LCollar_Attach/LUpperArm_Attach/LLowerArm_Attach/LHand_Attach/Target_LRing3"
@onready var left_pinky_iktarget = $"Armature/Skeleton3D/LCollar_Attach/LUpperArm_Attach/LLowerArm_Attach/LHand_Attach/Target_LPinky3"

#@onready var left_lower_arm_gtarget = $"Guitar/LowerArm_Target/Target_F10"
#@onready var left_hand_gtarget = $"Guitar/LHand_Target/Target_F10"
@onready var left_index_gtarget = $"Guitar/Hover_Target_S6/Target_F10"
@onready var left_middle_gtaret = $"Guitar/Hover_Target_S5/Target_F10"
@onready var left_ring_gtarget = $Guitar/Hover_Target_S4/Target_F11
@onready var left_pinky_gtarget = $Guitar/Hover_Target_S3/Target_F10

# Called every frame. 'delta' is the elapsed time since the previous frame.
#so i think i am going to get the notes here, and send the notes to the fingers here as i step through the song.
#I will also need to make about 10 animations for the frets (focus more on the upper fret ones with more space between) 
#and i will select the animation based on the smallest distance from the middle string on each fret to the average 
#note position for each strum. each finger will then select it's note based on minimum distance traveled or on inital hand placement.
#strums of the right hand will also be initialized here based on the notes passed to the left hand.
func _process(delta: float) -> void:
	pass

func get_closest_fret_animation():
	#get the base animation which is closest to the average note to be played
	pass

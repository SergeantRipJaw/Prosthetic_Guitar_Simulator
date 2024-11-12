extends Node3D

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
	# Set left hand IK targets to corresponding guitar targets
	get_left_ik_target(Finger.INDEX).set_finger_target(get_left_target(Finger.INDEX, 6, 10, true)) # example for string 6, fret 10
	get_left_ik_target(Finger.MIDDLE).set_finger_target(get_left_target(Finger.MIDDLE, 5, 10, true)) # example for string 5, fret 10
	get_left_ik_target(Finger.RING).set_finger_target(get_left_target(Finger.RING, 4, 11, true)) # example for string 4, fret 11
	get_left_ik_target(Finger.PINKY).set_finger_target(get_left_target(Finger.PINKY, 3, 11, true)) # example for string 3, fret 11

	# Set right hand IK targets to corresponding guitar targets (string only)
	get_right_ik_target(Finger.INDEX).set_finger_target(get_right_target(Finger.INDEX, 5, true)) # example for string 5
	get_right_ik_target(Finger.MIDDLE).set_finger_target(get_right_target(Finger.MIDDLE, 4, true)) # example for string 4
	get_right_ik_target(Finger.RING).set_finger_target(get_right_target(Finger.RING, 3, true)) # example for string 3
	get_right_ik_target(Finger.PINKY).set_finger_target(get_right_target(Finger.PINKY, 2, true)) # example for string 2
	get_right_ik_target(Finger.THUMB).set_finger_target(get_right_target(Finger.THUMB, 6, true)) # example for string 6
	
	# Connect signals for each string and fret collider to their respective handlers
	for i in righthand_string_colliders.size():
		righthand_string_colliders[i].connect("body_shape_entered", _on_right_finger_pick.bind(righthand_string_colliders[i]))

	for i in lefthand_string_colliders.size():
		lefthand_string_colliders[i].connect("body_shape_entered", _on_left_finger_press.bind(lefthand_string_colliders[i]))
		lefthand_string_colliders[i].connect("body_shape_exited", _on_left_finger_release.bind(lefthand_string_colliders[i]))
	
	for i in fret_colliders.size():
		fret_colliders[i].connect("body_shape_entered", _on_fret_collison.bind(fret_colliders[i]))
		fret_colliders[i].connect("body_shape_exited", _on_fret_release.bind(fret_colliders[i]))

func _process(delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#so i think i am going to get the notes here, and send the notes to the fingers here as i step through the song.
#I will also need to make about 10 animations for the frets (focus more on the upper fret ones with more space between) 
#and i will select the animation based on the smallest distance from the middle string on each fret to the average 
#note position for each strum. each finger will then select it's note based on minimum distance traveled or on inital hand placement.
#strums of the right hand will also be initialized here based on the notes passed to the left hand.

func get_closest_fret_animation():
	#get the base animation which is closest to the average note to be played
	pass

# Base paths for left and right hands
@onready var left_finger_iktarget = $"Armature/Skeleton3D/LCollar_Attach/LUpperArm_Attach/LLowerArm_Attach/LHand_Attach/Target"
@onready var right_finger_iktarget = $"Armature/Skeleton3D/RCollar_Attach/RUpperArm_Attach/RLowerArm_Attach/RHand_Attach/Target"

@onready var left_finger_hover_gtarget = $"Guitar/LFingers/Hover"
@onready var left_finger_target_gtarget = $"Guitar/LFingers/Target"

@onready var right_finger_hover_gtarget = $"Guitar/RFingers/Hover"
@onready var right_finger_target_gtarget = $"Guitar/RFingers/Target"

# Constants for easy indexing
enum Finger { THUMB, INDEX, MIDDLE, RING, PINKY }

# Functions to get IK finger targets
func get_left_ik_target(finger) -> Node:
	return left_finger_iktarget.get_child(int(finger))

func get_right_ik_target(finger) -> Node:
	return right_finger_iktarget.get_child(int(finger))

#functions to get the guitar finger targets
func get_left_target(finger: Finger, string_num: int, fret_num: int, hover: bool = false) -> Node:
	var target_root =  left_finger_hover_gtarget if hover else left_finger_target_gtarget
	return target_root.get_child(string_num - 1).get_child(fret_num - 1)

func get_right_target(finger: Finger, string_num: int, hover: bool = false) -> Node:
	var target_root =  right_finger_hover_gtarget if hover else right_finger_target_gtarget
	return target_root.get_child(string_num - 1)

@onready var guitar = $"./Guitar"
@onready var guitar_sounds = $"./Guitar/GuitarSounds"
@onready var lefthand_string_colliders = guitar.get_child(1).get_child(1).get_children()
@onready var righthand_string_colliders = guitar.get_child(1).get_child(0).get_children()
@onready var fret_colliders = guitar.get_child(2).get_children()

#function to get the average position of the notes that the player must play at the same time. useful for positioning the hand closest to notes
func avg_note_position(note_positions: Array):
	var avg_note_position = Vector3()
	for note_position in note_positions:
		avg_note_position += note_position
	return avg_note_position

#define dicts to keep finger: string (or fret) pairs for right hand checks
var lhand_dict = {}

func _on_right_finger_pick(_body_rid: RID, _finger_collider_node: Node3D, _body_shape_index: int, _local_shape_index: int, string_collider_node):
	#print("got right finger signal!")
	#print(string_collider_node.name)
	#print(_finger_collider_node.name)
	for finger in lhand_dict.keys():
		#check for errors where the finger has only a fret or only a string etc...
		if !(lhand_dict[finger].has("string") && lhand_dict[finger].has("fret")):
			if !(lhand_dict[finger].has("string")):
				push_warning(str("Finger: ", finger, " Doesn't have a stored string but is still in the lhand_dict!"))
			if !(lhand_dict[finger].has("fret")):
				push_warning(str("Finger: ", finger, " Doesn't have a stored fret but is still in the lhand_dict!"))
			continue #the finger doesn't have a string or fret collision, shouldn't be needed tho because it removes uncoliding fingers.
		
		#check for modified notes with the left fingers
		if lhand_dict[finger]["string"] == string_collider_node.name && lhand_dict[finger].has("fret"):
			
			#Also check if the fret is a higher number in the case of the same string being pressed down with two fingers!
			var finger_string_dict = {} #check dict
			var finger_press_collision = false
			for finger_ in lhand_dict.keys():
				if !lhand_dict[finger_].has("string"):
					#check to make sure it has string element, it should but due to collisions buggin out it might not
					push_warning("Skipping collision check due to no string element in dictionary.")
					continue #if not, jump to the next finger, effectively ignoring bugged one
				if finger_string_dict.has(lhand_dict[finger_]["string"]): #means there is two left hand fingers pressing the same string
					#do check to find which fret is greater on the string, and the greater one, put in the dict
					finger_press_collision = true
					var present_finger = finger_string_dict[lhand_dict[finger_]["string"]] #returns the finger in the check dictionary
					var checking_finger = finger_ #returns the finger we are iterating through
					print("present_finger" + present_finger)
					print("checking_finger" + checking_finger)
					# now check which one is a greater fret value to keep
					if present_finger < checking_finger:
						# checking finger fret value is a larger fret so replace present finger
						finger_string_dict[lhand_dict[finger_]["string"]] = checking_finger
				else: # populate the check dictionary when no collision is detected
					#puts the string as the key, and the finger_ as the value
					finger_string_dict[lhand_dict[finger_]["string"]] = finger_
			
			if finger_press_collision:
				#see which fingers collided, and which ones are still in the check dict,
				#if the finger value is not still in the check dict, don't play the note
				var string_key = finger_string_dict.find_key(str(finger))
				print(string_key)
				if (string_key != null): #key is found in the check dict for the associated finger value
					#play note
					print(finger_string_dict)
					guitar_sounds.play_note(string_collider_node.name, lhand_dict[finger_string_dict[string_key]]["fret"]) #play the highest note finger in the string
					return
				else:
					#don't play note because it is lower fret than another and was overwritten and continue looping through other fingers
					continue
			#the note will be modified before play based on the left hand
			guitar_sounds.play_note(string_collider_node.name, lhand_dict[finger]["fret"])
			return
	#if you got through and there wasn't a left hand string that matched, play basic note
	guitar_sounds.play_note(string_collider_node.name, "")
	return
	
func _on_left_finger_press(_body_rid: RID, finger_collider_node: Node3D, _body_shape_index: int, _local_shape_index: int, string_collider_node):
	print("\ngot left string press signal!")
	print(string_collider_node.name)
	print(finger_collider_node.name)
	if !lhand_dict.has(finger_collider_node.name):
		lhand_dict[finger_collider_node.name] = {}
	lhand_dict[finger_collider_node.name]["string"] = string_collider_node.name
	return
	
func _on_left_finger_release(_body_rid: RID, finger_collider_node: Node3D, _body_shape_index: int, _local_shape_index: int, _string_collider_node):
	print("\ngot left string release signal!")
	if(lhand_dict.has(finger_collider_node.name)):
		lhand_dict[finger_collider_node.name].erase("string")
		if lhand_dict[finger_collider_node.name].is_empty(): #check if it's the last one
			lhand_dict.erase(finger_collider_node.name)
	return 
	
func _on_fret_collison(_body_rid: RID, finger_collider_node: Node3D, _body_shape_index: int, _local_shape_index: int, fret_collider_node):
	print("\ngot fret press signal!")
	print(fret_collider_node.name)
	print(finger_collider_node.name)
	if !lhand_dict.has(finger_collider_node.name):
		lhand_dict[finger_collider_node.name] = {}
	lhand_dict[finger_collider_node.name]["fret"] = fret_collider_node.name
	return
	
func _on_fret_release(_body_rid: RID, finger_collider_node: Node3D, _body_shape_index: int, _local_shape_index: int, _fret_collider_node):
	print("\ngot fret release signal!")
	if(lhand_dict.has(finger_collider_node.name)):
		lhand_dict[finger_collider_node.name].erase("fret")
		if lhand_dict[finger_collider_node.name].is_empty(): #check if it's the last one
			lhand_dict.erase(finger_collider_node.name)
	return 

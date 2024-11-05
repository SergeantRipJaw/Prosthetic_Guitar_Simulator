extends Node


func test_XML_parse(songData: Dictionary):
	print("\n\n**********TEST***********\n")
	#print("Song Data Elements: ")
	#print(songData.keys())

	#if songData["m1,n0,beat-unit"].has("data"):
		#print(songData["m1,n0,beat-unit"]["data"])
	#print(songData["m1,n0,measure"].keys())

	#inital note data

	#divisions per note_type
	var note_length_div = songData["-m1,+n0,divisions"]["data"]
	#is it a quarter-note, half-note, etc...
	var note_type = songData["-m1,+n0,beat-unit"]["data"]
	#how many of the note type occurs in one minute.
	var bpm = songData["-m1,+n0,per-minute"]["data"]
	#list of the time signature, ex: [4,4]
	var timesig = [songData["-m1,+n0,beats"]["data"],songData["-m1,+n0,beat-type"]["data"]]
	#the clef the song starts playing in ex: G
	#var clef = songData["-m1,+n0,sign"]["data"] #G cleff is treble cleff, and most common. honestly shouldn't need to worry about this as step and octave should still tell everything you need.
	#print(songData["num_measures"])
	#print(songData["-m1,+n0,num_notes"])
	#print(songData["-m16,+n0,num_notes"])
	
	#measure booleans
	var attributes = false #if attributes are detected
	var direction = false #if direction elements are detected
	for element in songData.keys():
		
		#all elements that are measure and note specific should be extracted here in order.
		if element.contains("measure"): #start of a new measure
			pass
		if element.contains("note"): #NOTE it will also access num_notes!
			attributes = false #don't enter attributes checker again for this measure
			direction = false #same as above
			if !songData[element].is_empty() && songData[element].has("dynamics"): #check for dynamics in the note attributes
				#print(songData[element]["dynamics"])
				pass
			if !element.contains("num_notes"):
				#print(element)
				pass
		if attributes || element.contains("attributes"):
			attributes = true #check these until getting to the notes portion
			if element.contains("divisions"): #divisions per note_type
				#TODO
				pass
			#attributes -> key elements
			if element.contains("fifths"): #don't need rn
				pass
			if element.contains("mode"): # "major" or "minor" scale not really needed i don't think
				pass
			#attributes -> time signature elements ex: 3:4 time 3 is beats, 4 is beat-type
			if element.contains("beats"): 
				#TODO
				pass
			if element.contains("beat-type"):
				#TODO
				pass
			#attributes -> clef elements
			if element.contains("sign"): # the clef that the measure is in ex: "F" aka bass clef or "G" aka treble cleff
				#TODO
				pass
			if element.contains("line"): #don't need rn
				pass
		if direction || element.contains("direction"):
			direction = true #check these until getting to the notes portion
			if element.contains("beat-unit"): # ex: "quarter" to get the type of note that is a standard beat in the measure
				#TODO
				pass
			#attributes -> key elements
			if element.contains("per-minute"): #number of beats per minute, tempo
				#TODO
				pass
		if element.contains("chord"): #This should be checked for second when reading measures! will have the n# of the current note
			#<chord/> element tells you that the current pitch is played at the same time as the previous pitch and that they will be sustained for the same amount of time
			#print(element)
			pass
		if element.contains("backup"): #This should be checked for first when reading measures! will have the same n# as the previous note
			#<backup><duration>30240</duration><backup/> tells you how far back in the measure to backup, 
			#and can be used for entering notes that will be played at the same time as other notes with different sustain lengths
			#if there is a backup in the measure, there will also be a <voice>1</voice> or <voice>2</voice> element inside note which can help too
			#print(element)
			pass
		
		if element.contains("ocatve"):
			#middle c is on octave 4 on treble clef (G)!
			#print(element)
			#print(songData[element])
			pass
		if element.contains("pitch"):
			#middle c is on octave 4 on treble clef (G)!
			#print(element)
			#print(songData[element])
			pass
		if element.contains("alter"):
			#inside <pitch> <alter>1</alter> indicates an accidental 1 note up ex: if it was F, it will become F# if -1 it would go down.
			#remember, between e and f, and b and c, there are not intermediary notes! ex: an f flat would be e! or a b# would be c!
			#print(element)
			#print(songData[element])
			pass
		if element.contains("num_notes"):
			#it is the end of the measure, so set the end_of_measure flag true.
			#call animate hand?
			#play_measure()
			pass

func calc_divisions_per_second(note_length_div, note_type, bpm, timesig: Array):
	#divisions per note_type
	#var note_length_div = songData["-m1,+n0,divisions"]["data"]
	
	#is it a quarter-note, half-note, etc...
	#var note_type = songData["-m1,+n0,beat-unit"]["data"]
	
	#how many of the note type occurs in one minute.
	#var bpm = songData["-m1,+n0,per-minute"]["data"]
	
	#list of the time signature, ex: [4,4]
	#var timesig = [songData["-m1,+n0,beats"]["data"],songData["-m1,+n0,beat-type"]["data"]]
	pass
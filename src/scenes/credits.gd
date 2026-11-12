extends Control

const CREDIT_FILE = "res://credits/credits.json" ## CREDITS FILE
const PEOPLE_FILE = "res://credits/people.json" ## PPL FILE

## ! TO DO:
## ADD SOME ERROR CHECKING

## create credits text
func _ready() -> void: 
	var entry_template = $Credits_scroll_container/VBoxContainer/Entry # ENTRY
	var person_template = $Credits_scroll_container/VBoxContainer/Person # PERSON
	var separator_template = $Credits_scroll_container/VBoxContainer/Separator # SEPARATOR
	var big_separator_template = $Credits_scroll_container/VBoxContainer/BigSeparator # BIG SEPARATOR
	
	var ppl = {} # pre made people labels
	
	var people_file = FileAccess.open(PEOPLE_FILE, FileAccess.READ) # open file
	var people_file_content = people_file.get_as_text() # read it
	people_file.close() # close it
	
	var people_json = JSON.parse_string(people_file_content) # parse json
	if not people_json is Dictionary: printerr("ERROR: FAILED PARSING PEOPLE JSON"); return # if errors, return
	
	for person in people_json: # for every person:
		var person_data = people_json[person] # get data ( icon, color, display name)
		var person_label = person_template.duplicate() # dupe empty template
		person_label.text = "[img=25]"+person_data["icon"]+"[/img] [color="+person_data["color"]+"]"+person_data["display_name"]+"[/color]" # set text
		
		ppl[person] = person_label # add it to ppl dict
	
	
	var credit_file = FileAccess.open(CREDIT_FILE, FileAccess.READ) # open credit file
	var credit_file_content = credit_file.get_as_text() # read it
	credit_file.close() # close it
	
	var credits_json = JSON.parse_string(credit_file_content) # parse json
	if not credits_json is Dictionary: printerr("ERROR: FAILED PARSING CREDITS JSON"); return # return if error
	
	
	var start_sep = big_separator_template.duplicate() # dupe starting separator
	big_separator_template.get_parent().add_child(start_sep) 
	start_sep.visible = true
	
	for entry in credits_json: # for every entry EX: "special thanks", "artists" etc etc
		var label : RichTextLabel = entry_template.duplicate() # create entry ( big text )
		label.text = str(entry) # give it a text
		label.name = str(entry) # give it a name
		entry_template.get_parent().add_child(label) # had to use get_parent().add_child() bcuz of weird ordering (prob will fix it later if needed)
		label.visible = true # make it visible

		for person: Dictionary in credits_json[entry]: # for every entry EX: "scp foundation", "godot game engine", "bluescreen_yt", "you" etc etc
			var ID = person["id"] as String # id ex: scp, godot
			
			var person_label: RichTextLabel = ppl[ID].duplicate() # duplicate template
			

			if person.has("additional"): # if additional notes detected add em
				person_label.text += " - " + person["additional"]
			
			person_template.get_parent().add_child(person_label) # add it to tree
			person_label.visible = true # make it visible
		
		var sep = separator_template.duplicate() # dupe separation
		separator_template.get_parent().add_child(sep) # add it to tree
		sep.visible = true # make it visible
	
	var end_sep = big_separator_template.duplicate() # ending separator
	big_separator_template.get_parent().add_child(end_sep)
	end_sep.visible = true


func _process(delta: float) -> void:
	var new_scroll = $Credits_scroll_container.scroll_horizontal+(delta*60) # scrolling
	$Credits_scroll_container.set_v_scroll( $Credits_scroll_container.get_v_scroll()+new_scroll )
	

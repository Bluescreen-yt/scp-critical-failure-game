extends Control

const CREDIT_FILE = "res://credits/credits.json" ## CREDITS FILE
const PEOPLE_FILE = "res://credits/people.json" ## PPL FILE

## ! TO DO:
## ADD SOME ERROR CHECKING

## create credits text
func _ready() -> void: 
	var entry_template = $Credits_scroll_container/VBoxContainer/Entry ## ENTRY
	var person_template = $Credits_scroll_container/VBoxContainer/Person ## PERSON
	var separator_template = $Credits_scroll_container/VBoxContainer/Separator ## SEPARATOR
	var big_separator_template = $Credits_scroll_container/VBoxContainer/BigSeparator ## BIG SEPARATOR
	
	var ppl = {} ## pre made people labels
	
	var people_file = FileAccess.open(PEOPLE_FILE, FileAccess.READ)
	var people_file_content = people_file.get_as_text()
	people_file.close()
	
	var people_json = JSON.parse_string(people_file_content)
	if not people_json is Dictionary: return
	
	for person in people_json:
		var person_data = people_json[person]
		var person_label = person_template.duplicate()
		person_label.text = "[img=25]"+person_data["icon"]+"[/img] [color="+person_data["color"]+"]"+person_data["display_name"]
		
		ppl[person] = person_label
	
	
	var credit_file = FileAccess.open(CREDIT_FILE, FileAccess.READ)
	var credit_file_content = credit_file.get_as_text()
	credit_file.close()
	
	var credits_json = JSON.parse_string(credit_file_content)
	if not credits_json is Dictionary: return
	
	
	var start_sep = big_separator_template.duplicate()
	big_separator_template.get_parent().add_child(start_sep) 
	start_sep.visible = true
	
	for entry in credits_json: ## for every entry EX: "special thanks", "artists" etc etc
		var label : RichTextLabel = entry_template.duplicate()
		label.text = str(entry)
		label.name = str(entry)
		entry_template.get_parent().add_child(label) # had to use get_parent().add_child() bcuz of weird ordering (prob will fix it later if needed)
		label.visible = true

		for person in credits_json[entry]: ## for every entry EX: "scp foundation", "godot game engine", "bluescreen_yt", "you" etc etc
			var person_label : RichTextLabel = ppl[person].duplicate()
			person_template.get_parent().add_child(person_label)
			person_label.visible = true
		
		var sep = separator_template.duplicate()
		separator_template.get_parent().add_child(sep) 
		sep.visible = true
	
	var end_sep = big_separator_template.duplicate()
	big_separator_template.get_parent().add_child(end_sep) 
	end_sep.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_scroll = $Credits_scroll_container.scroll_horizontal+(delta*60)
	$Credits_scroll_container.set_v_scroll( $Credits_scroll_container.get_v_scroll()+new_scroll )
	

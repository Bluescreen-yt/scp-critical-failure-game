@tool
@icon("res://dev_textures/speaker.png") 
class_name ProgressiveAudioStreamPlayer
extends AudioStreamPlayer
## simple class for progressive audio ( music that has multiple stages )

signal reached_end_of_current_clip ## emited when reaching end of clip
 
@export var current_idx := 0 ## index of current playing clip

@export var clips: Array[ProgressiveAudioMark]: ## array of clips
	set(value): # warnings stuff
		clips = value
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings :PackedStringArray = [] # warnings stuff
	if clips.is_empty(): warnings.append("please add at least single clip")
	
	return warnings


## smoothly transition to next mark / clip
func set_current_clip_idx(idx: int):
	current_idx = clamp(idx, 0, len(clips)-1)

## forcefully transition to next mark / clip
func force_set_current_clip_idx(idx: int):
	current_idx = clamp(idx, 0, len(clips)-1)
	self.seek(clips[idx].mark_start)


func _process(delta: float) -> void:
	if not self.playing or clips.is_empty(): # if not playing or if there is no clips: skip
		return
	
	var pos = self.get_playback_position() # get current position
	var current_clip = clips[current_idx]
	
	if pos>=current_clip.mark_end: # if reached end of current clip
		reached_end_of_current_clip.emit() # emit signal
		self.seek(current_clip.mark_start) # return to clip start

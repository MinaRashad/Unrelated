extends Control

@export var conversation_id:String = "Test"
@export var letter_delay:float = 0.1

var json_text = FileAccess.get_file_as_string("res://Data/dialogues.json")
var json_dict = JSON.parse_string(json_text)

var data = json_dict[conversation_id]

var speaker = data['speaker']
var conv = data['conv']
var conv_size = len(conv)
var conv_piece_idx = 0
var char_idx = 0
var conv_piece = conv[conv_piece_idx]
var conv_piece_size = len(conv_piece)


func _ready():
	$name.text = '[color=#aaa]' + speaker + '[/color]'
	$body.visible_characters = 0
	$body.text = conv_piece
	

func _process(delta):
	# here we will handle pressing the action and cancel
	if Input.is_action_just_pressed("action"):
		# if we press action while the text is not done yet, show all the piece
		if char_idx < conv_piece_size:
			char_idx = conv_piece_size-1
			$body.visible_characters = char_idx

		else:
			# If not we need to change to the next piece 
			if conv_piece_idx < conv_size-1:
				char_idx = 0
				conv_piece_idx +=1
				conv_piece = conv[conv_piece_idx]
				conv_piece_size = len(conv_piece)
				
				# update body
				$body.visible_characters = 0
				$body.text = conv_piece
				
				#hide arrow
				$"continue-arrow".hide()
			else:
				self.hide()

func _on_timer_timeout():
	# if char idx is less than the size then we need to increase it by one
	if char_idx < conv_piece_size:
		char_idx += 1
		$body.visible_characters = char_idx
		$click.play()
	else:
		if not $"continue-arrow".visible:
			$"continue-arrow".visible = true
	
	
func Set_diaglgue(conversation_id):
	data = json_dict[conversation_id]
	speaker = data['speaker']
	conv = data['conv']
	conv_size = len(conv)
	conv_piece_idx = 0
	char_idx = 0
	conv_piece = conv[conv_piece_idx]
	conv_piece_size = len(conv_piece)

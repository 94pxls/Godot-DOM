extends Object

var DomNode = get_script()
var tag_name := ''
var style := {
	'size': Vector2(300,-1),
	'margin': Rect2(5, 7, 5, 7),
	'background_color': Color(1,1,1), 
	'border': {
		'color': Color(0,0,0),
		'width': 1,
	},
	'padding': Rect2(5,5,5,5)
}
var properties := {}
var text := ''
var children := []
var font : Font

const TAG_NAME_KEY = 0

func _init(array_to_parse, _font = null):
	font = _font
	parse(array_to_parse)

func parse(array_to_parse):
	print(array_to_parse)
	# Verify if the array has enough items to parse
	# <img src='res://asdasdasd.png' />
	assert(
		array_to_parse.size() >= 2 &&
		array_to_parse.size() <= 3
	)
	# Verify if first item is a string and has a valid name
	assert(
		array_to_parse[TAG_NAME_KEY] is String && 
		array_to_parse[TAG_NAME_KEY].length() > 0
	)
	
	tag_name = array_to_parse[TAG_NAME_KEY]

	if array_to_parse[1] is Dictionary:
		parse_properties(array_to_parse[1])
	else:
		if array_to_parse.size() <= 2:
			check_child_or_string(array_to_parse[1])
		else:
			# should have ended the object here
			assert(false)
	if array_to_parse.size() > 2:
		check_child_or_string(array_to_parse[2])

func parse_properties(props):
	if props.has('style'):
		assert(props['style'] is Dictionary)
		style = props['style']
		props.erase('style')
	properties = props

func parse_children(children_array):
	for child in children_array:
		var childNode = DomNode.new(child)
		childNode.font = font
		children.append(childNode)

func check_child_or_string(param_to_check):
	if param_to_check is String:
		text = param_to_check
	elif param_to_check is Array:
		parse_children(param_to_check)

func _to_string():
	return '<' + tag_name + ' ' + JSON.print(properties) + '>' + _text_or_children() + '</' + tag_name + '>'

func _text_or_children():
	if text:
		return text
	else:
		var result := ''
		for child in children:
			result += child._to_string()
		return result


func calculate_children_height() -> float:
	var result := 0.0
	for child in children:
		result += child.get_self_height()
	return result

func calculate_children_vertical_margin():
	var result := 0.0
	for child in children:
		result += child.get_self_vertical_margin()
	return result

func get_self_vertical_margin() -> float:
	if style.has('margin'):
		assert(style['margin'] is Rect2, 'The margin property must be a Rect2')
		return style['margin'].y + style['margin'].height
	return 0.0

func get_self_height() -> float:
	var result := 0.0
	if style.has('size'):
		assert(style['size'] is Vector2, 'The size property must be a Vector2')
		if style['size'].y > -1:
			return float(style['size'].y)
	if style.has('padding'):
		assert(style['padding'] is Rect2)
		result += style['padding'].position.y + style['padding'].size.y
	
	if text:
		assert(font, 'Font must be defined to draw text')
		result += font.get_wordwrap_string_size(text, get_self_width()).y

	result += calculate_children_height()

	return result

func get_self_width() -> float:
	if style.has('size'):
		assert(style['size'] is Vector2)
		return style['size'].x
	return 0.0

func draw(context, offset := Vector2(0,0), size_boundaries := Vector2(0,0)):
	offset += style['margin'].position
	print('draw')

	print('get_self_height()', get_self_height())
	print('get_self_width()', get_self_width())

	if style.has('background_color'):
		assert(style['background_color'] is Color)
		print("style.has('background_color')")
		context.draw_rect(
			Rect2(offset, Vector2(get_self_width(), get_self_height())),
			style['background_color'],
			true
		)
	if style.has('border'):
		context.draw_rect(
			Rect2(offset,Vector2(get_self_width(), get_self_height())),
			style['border']['color'],
			false,
			float(style['border']['width'])
		)
	if text:
		assert(font, 'Font must be defined to draw text')
		# TODO: make a better way to get the text position
		context.draw_string(font, offset + style['padding'].position, text, Color(0,0,0,1), get_self_width() )

	for child in children:
		child.draw(context, offset + style['padding'].position, size_boundaries)

tool
extends Node2D

var DomNode = load('res://scripts/dom_node.gd')
var tree = null

export(bool) var render_in_editor := false setget _set_render_in_editor


func _ready():
	init_tree()

func init_tree():
	tree = DomNode.new([
		'root', {'id': 'teste'}, [
			['box', 'asdjkladjalksjdalksdj'],
			['text', 'asdasdasd ad laksdj klasjd']
		]
	], Control.new().get_font("font"))

func _draw():
	tree.draw(self, position)


func build(_build_tree):
	pass

func _set_render_in_editor(boolean):
	render_in_editor = boolean
	if !tree:
		init_tree()
	if tree:
		tree.draw(self, position)

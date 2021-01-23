# Godot DOM
This project aims to emulate html like rendering behavior and workflow,
this is still a really early project and early in its development,
Don't use this for anything, but feel free to study it.

## What I got so far

Well, a mix between too much and not enough, this code runs and becomes the following image:

```gd
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
```

![Screenshot](https://github.com/94pxls/Godot-Dom/blob/master/github_assets/screenshot.png?raw=true)
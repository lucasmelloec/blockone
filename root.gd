extends Node


onready var gridmap = $GridMap


# func _ready():
# 	for x in range(11):
# 		for z in range(11):
# 			if x == 0 and z == 0:
# 				continue
# 			var newgridmap = gridmap.duplicate()
# 			newgridmap.translate(Vector3((x) * 32, 0, (z) * 32))
# 			add_child(newgridmap)

# 			var newgridmap2 = gridmap.duplicate()
# 			newgridmap2.translate(Vector3(-(x) * 32, 0, -(z) * 32))
# 			add_child(newgridmap2)

# 			var newgridmap3 = gridmap.duplicate()
# 			newgridmap3.translate(Vector3(-(x) * 32, 0, (z) * 32))
# 			add_child(newgridmap3)

# 			var newgridmap4 = gridmap.duplicate()
# 			newgridmap4.translate(Vector3((x) * 32, 0, -(z) * 32))
# 			add_child(newgridmap4)

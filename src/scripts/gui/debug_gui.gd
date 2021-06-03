extends Control


onready var fps_label := $VBoxContainer/FpsLabel
onready var memory_label := $VBoxContainer/MemoryLabel
onready var object_label := $VBoxContainer/ObjectLabel
onready var render_objects_label := $VBoxContainer/RenderObjectsLabel
onready var render_vertices_label := $VBoxContainer/RenderVerticesLabel
onready var draw_calls_label := $VBoxContainer/DrawCallsLabel
onready var video_memory_label := $VBoxContainer/VideoMemoryLabel


func _process(_delta):
	var memory := OS.get_static_memory_usage() / (1024.0*1024.0)
	var fps := Performance.get_monitor(Performance.TIME_FPS)
	var object_count := Performance.get_monitor(Performance.OBJECT_COUNT)
	var render_objects := Performance.get_monitor(Performance.RENDER_OBJECTS_IN_FRAME)
	var render_vertices := Performance.get_monitor(Performance.RENDER_VERTICES_IN_FRAME)
	var draw_calls := Performance.get_monitor(Performance.RENDER_DRAW_CALLS_IN_FRAME)
	var video_memory := Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / (1024*1024)
	
	fps_label.text = "FPS: %d" % fps
	memory_label.text = "Memory: %d MB" % memory
	object_label.text = "Object Count: %d" % object_count
	render_objects_label.text = "Render Objects: %d" % render_objects
	render_vertices_label.text = "Render Vertices: %d" % render_vertices
	draw_calls_label.text = "Draw Calls: %d" % draw_calls
	video_memory_label.text = "Video Memory: %d MB" % video_memory

func _input(event):
	if event.is_action_pressed("debug"):
		visible = not visible
		set_process(visible)

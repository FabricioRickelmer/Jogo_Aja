extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
#Para alterar a quantidade e sumir os itens após ele ser colocado, usamos:
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Aja"):
		print("Pegou a pocao")
		Global.pocao=Global.pocao+1
		queue_free()
		
		

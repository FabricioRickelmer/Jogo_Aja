extends Area2D

@export var velocidade: float = 400.0
@export var dano: int = 1 
var direcao: Vector2 = Vector2.ZERO
var e_do_inimigo: bool = true 

@onready var sprite = get_node_or_null("Sprite_Osso")

func _ready():
	# 1. CONECTA OS SINAIS AUTOMATICAMENTE
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	# 2. Configura as máscaras de colisão
	collision_layer = 0
	collision_mask = 0
	
	set_collision_mask_value(1, true) # Bate no cenário
	
	if e_do_inimigo:
		set_collision_mask_value(4, true) # Bate na Aja
	else:
		set_collision_mask_value(5, true) # Bate nos Inimigos

func configurar_visual(nova_texture: Texture2D):
	if sprite:
		sprite.texture = nova_texture

func _process(delta: float) -> void:
	if direcao != Vector2.ZERO:
		position += direcao * velocidade * delta

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		if area.health_component:
			area.health_component.receber_dano(dano)
		destruir()

func _on_body_entered(body: Node2D) -> void:
	if body is StaticBody2D or body is TileMapLayer:
		destruir()

func destruir():
	queue_free()

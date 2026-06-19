extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

func _ready():
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	if area is HitboxComponent:
		if health_component:
			health_component.receber_dano(area.damage)
			if area.get_parent().has_method("destruir"):
				area.get_parent().destruir()

extends Control

@onready var centro_dos_botoes = $CenterContainer
@onready var fundo_transparente = $ColorRect

func _ready():
	# TRAVA DE SEGURANÇA 1: Garante que o nó PAI esteja sempre visível.
	# Se o pai estiver invisível, os filhos nunca vão aparecer!
	self.show() 
	
	# Esconde apenas os itens do menu no início
	centro_dos_botoes.hide()
	fundo_transparente.hide()

# TRAVA DE SEGURANÇA 2: Usamos _unhandled_input para garantir que
# nenhum outro botão da interface "roube" o clique do ESC antes do menu.
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		print("---> O teclado gritou: ESC!")
		toggle_pause()

func toggle_pause():
	var novo_estado = not get_tree().paused
	get_tree().paused = novo_estado
	
	# Essa mensagem vai aparecer no seu terminal dizendo o estado real do jogo
	print("---> O jogo pausou? ", get_tree().paused)
	
	# Mostra ou esconde os elementos visuais
	centro_dos_botoes.visible = novo_estado
	fundo_transparente.visible = novo_estado

# --- FUNÇÕES DOS BOTÕES ---
func _on_botao_salvar_pressed():
	print("Progresso da Aja salvo com sucesso!")

func _on_botao_menu_pressed():
	get_tree().paused = false
	print("Voltando para o menu principal...")

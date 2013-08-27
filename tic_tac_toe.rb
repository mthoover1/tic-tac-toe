require './interface'
require './board'
require './computer_player'
require './game_controller'

interface = Interface.new
board = Board.new
computer = ComputerPlayer.new(board)
game = GameController.new(board, interface, computer)

game.play

# puts interface.clear_screen
# puts board

# until board.won? || board.tied?
# 	move = 0
# 	until interface.input_valid?(move) && board.tile_open?(move)
# 		puts interface.prompt_human
# 		move = interface.get_input
# 	end
# 	board.update(move, "X")

# 	puts interface.clear_screen
# 	puts board

# 	break if board.won? || board.tied?

# 	sleep(0.1)
# 	board.update(computer.random_move, "O")

# 	puts interface.clear_screen
# 	puts board
# end

# puts interface.display_results(board)

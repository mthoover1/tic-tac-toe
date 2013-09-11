require './lib/interface'
require './lib/board'
require './lib/computer_player'
require './lib/game_controller'

interface = Interface.new

puts interface.clear_screen
puts interface.pick_board_size
board_size = interface.get_input

board = Board.new(board_size)
computer = ComputerPlayer.new(board)
game = GameController.new(board, interface, computer)

game.play

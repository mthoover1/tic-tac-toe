class GameController
	def initialize(board, interface, computer)
		@board = board
		@interface = interface
		@computer = computer
	end

	def play
		@board.update(5, "O")  # ------- MAKE THIS RANDOM ------ #
		show_board
		until @board.won? || @board.tied?
			human_move
			show_board
			break if @board.won? || @board.tied?
			computer_move
			show_board
		end
		puts @interface.display_results(@board)
	end

	def show_board
		puts @interface.clear_screen
		puts @board
	end

	def human_move
		move = 0
		until @interface.input_valid?(move) && @board.tile_open?(move)
			puts @interface.prompt_human
			move = @interface.get_input
		end
		@board.update(move, "X")
	end

	def computer_move
		sleep(0.5)
		@board.update(@computer.move, "O")
	end
end

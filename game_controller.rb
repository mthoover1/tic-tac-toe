class GameController
	attr_accessor :next_move  # for computer next move test

	def initialize(board, interface, computer)
		@board = board
		@interface = interface
		@computer = computer
		@next_move = coin_toss
	end

	def play
		show_board

		until @board.won? || @board.tied?
			move
			update_next_move
			show_board
		end

		puts @interface.display_results(@board)
	end

	def coin_toss
		["H","C"].sample
	end

	def show_board
		puts @interface.clear_screen
		puts @interface.instructions
		puts @board
	end

	def move
		human_move if @next_move == "H"
		computer_move if @next_move == "C"
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
		sleep(0.5) if @board.move_count > 0
		@board.update(@computer.move, "O")
	end

	def update_next_move
		if @next_move == "C"
			@next_move = "H"
		elsif @next_move == "H"
			@next_move = "C"
		end
	end
end

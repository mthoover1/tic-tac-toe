class GameController
	attr_reader :next_player

	def initialize(board, interface, computer)
		@board = board
		@interface = interface
		@computer = computer
		@next_player = coin_toss
	end

	def play
		# get_board_size

		show_board   ### PUT THIS IN THE LOOP? (show_board JUST IN LOOP WOULD BE IDEAL)

		until @board.won? || @board.tied? || @board.future_cats_game?
			move
			update_next_player
			show_board
		end

		puts @interface.display_results(@board)
	end

	def coin_toss
		["H","C"].sample
	end

	# def get_board_size
	# 	puts @interface.clear_screen

	# 	size = 0
	# 	until size == 3 || size == 4
	# 		puts @interface.pick_board_size
	# 		size = @interface.get_input
	# 	end

	# 	puts size
	# 	sleep (1.0)
	# end

	def show_board
		puts @interface.clear_screen
		puts @interface.instructions(@board.size)
		puts @board
	end

	def move
		human_move if @next_player == "H"
		computer_move if @next_player == "C"
	end

	def human_move
		move = 0
		until @interface.input_valid?(move, @board.size) && @board.tile_open?(move)
			puts @interface.prompt_human
			move = @interface.get_input
		end
		@board.update(move, "X")
	end

	def computer_move
		sleep(0.5) if @board.move_count > 0
		@board.update(@computer.move, "O")
	end

	def update_next_player
		@next_player == "C" ? @next_player = "H" : @next_player = "C"
	end
end
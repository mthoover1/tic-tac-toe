class GameController
	attr_reader :next_player

	HUMAN = "X"
	COMPUTER = "O"

	def initialize(board, interface, computer)
		@board = board
		@interface = interface
		@computer = computer
		@next_player = coin_toss
	end

	def play
		# get_board_size

		show_board

		until @board.won? || @board.tied? || @board.future_cats_game?
			move
			update_next_player
			show_board
		end

		puts @interface.display_results(@board, HUMAN, COMPUTER)
	end

	def coin_toss
		[HUMAN,COMPUTER].sample
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
		puts @interface.tile_number_diagram(@board.size)
		puts @board
	end

	def move
		human_move if @next_player == HUMAN
		computer_move if @next_player == COMPUTER
	end

	def human_move
		move = 0
		until @interface.input_valid?(move, @board.size) && @board.tile_open?(move)
			puts @interface.prompt_human
			move = @interface.get_input
		end
		@board.update(move, HUMAN)
	end

	def computer_move
		sleep(0.5) if @board.move_count > 0
		@board.update(@computer.move, COMPUTER)
	end

	def update_next_player
		@next_player == COMPUTER ? @next_player = HUMAN : @next_player = COMPUTER
	end
end

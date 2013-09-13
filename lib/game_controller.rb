class GameController
	attr_reader :next_player, :board, :computer

	HUMAN = "X"
	COMPUTER = "O"

	def initialize(interface, board = nil, computer = nil)
		@interface = interface
		@board = board
		@computer = computer
		@next_player = coin_toss
		@player1 = nil
		@player2 = nil
		# @next_player = @player1
	end

	def play
		create_board if @board == nil
		create_computer_player if @computer == nil

		show_board

		until @board.won? || @board.tied? || @board.future_cats_game?
			move
			update_next_player
			show_board
		end

		puts @interface.display_results(@board, HUMAN, COMPUTER)
	end

	def create_board
		puts @interface.clear_screen
		puts @interface.pick_board_size
		board_size = @interface.get_input

		@board = Board.new(board_size)
	end

	def create_computer_player
		@computer = ComputerPlayer.new(@board)
	end

	def coin_toss
		[HUMAN,COMPUTER].sample
	end

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
		until @board.tile_open?(move)
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

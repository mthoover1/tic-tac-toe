class GameController
	attr_reader :next_player, :board, :computer, :player1, :player2

	SYMBOL1 = "X"
	SYMBOL2 = "O"

	def initialize(interface, board = nil, player1 = nil, player2 = nil)
		@interface = interface
		@board = board
		@player1 = player1
		@player2 = player2
		@next_player = @player1
	end

	def play
		create_board if @board == nil
		coin_toss

		show_board

		until @board.won? || @board.tied? || @board.future_cats_game?
			@next_player.move
			update_next_player
			show_board
		end

		puts @interface.display_results(@board, SYMBOL1, SYMBOL2)
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
		coin = ["heads","tails"].sample

		if coin == "heads"
			@player1 = HumanPlayer.new(@board, SYMBOL1, @interface)
			@player2 = ComputerPlayer.new(@board, SYMBOL2)
		else
			@player1 = ComputerPlayer.new(@board, SYMBOL1)
			@player2 = HumanPlayer.new(@board, SYMBOL2, @interface)
		end

		# @player1 = ComputerPlayer.new(@board, SYMBOL1)
		# @player2 = ComputerPlayer.new(@board, SYMBOL2)

		@next_player = @player1
	end

	def show_board
		puts @interface.clear_screen
		puts @interface.tile_number_diagram(@board.size)
		puts @board
	end

	def update_next_player
		@next_player == @player1 ? @next_player = @player2 : @next_player = @player1
	end
end

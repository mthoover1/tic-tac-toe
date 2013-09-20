class HumanPlayer
	attr_reader :board

	def initialize(board, symbol = "X", interface)
		@board = board
		@symbol = symbol
		@interface = interface
	end

	def move
		move = 0
		until @board.tile_open?(move)
			puts @interface.prompt_human
			move = @interface.get_input
		end
		@board.update(move, @symbol)
	end
end

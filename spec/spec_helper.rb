module SpecHelper
	def self.make_moves(board, moves)
	  moves.join.split("").each_with_index do |move, index|
	    if move != "-"
	      board.update_tile(index+1, move)
	    end
	  end
	end
end

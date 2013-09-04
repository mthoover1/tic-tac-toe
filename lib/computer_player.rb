class ComputerPlayer
	def initialize(board)
		@board = board
	end

	def move
		try_to_win ||
		try_to_block ||
		strategic_move ||
		hopeful_move ||
		center_move ||
		random_move
	end

	def try_to_win
		look_for_opening("O")
	end

	def try_to_block
		look_for_opening("X")
	end

	def look_for_opening(letter)
		tiles = @board.tiles

		@board.winning_possibilities.each do |combo|
			possibility = []

			combo.each do |location|
				possibility << tiles[location]
			end

			if possibility.count("-") == 1 && possibility.include?(letter) && possibility.uniq.length == 2
				combo_index = possibility.index("-")
				return combo[combo_index] + 1
			end
		end
		nil
	end

	def strategic_move
		tiles = @board.tiles

		if @board.size == 3
			# HUMAN FIRST
			if @board.move_count == 1
				return @board.tile_open?(5) ? 5 : 1     #take center if open, else take top-left

			elsif @board.move_count == 3
				if tiles[4] == "X" && tiles[8] == "X"
					return [3,7].sample
				elsif (tiles[0] == "X" && tiles[8] == "X") || (tiles[2] == "X" && tiles[6] == "X")
					return [1,3,5,7].sample + 1
				elsif tiles[3] == "X" && tiles[2] == "X" # HUMAN PLAYS EDGE AND A FAR CORNER (computer plays corner in between)
					return 1
				elsif tiles[3] == "X" && tiles[8] == "X"
					return 7
				elsif tiles[1] == "X" && tiles[6] == "X"
					return 1
				elsif tiles[1] == "X" && tiles[8] == "X"
					return 3
				elsif tiles[5] == "X" && tiles[0] == "X"
					return 3
				elsif tiles[5] == "X" && tiles[6] == "X"
					return 9
				elsif tiles[7] == "X" && tiles[0] == "X"
					return 7
				elsif tiles[7] == "X" && tiles[2] == "X"
					return 9
				end
			# COMPUTER FIRST
			elsif @board.move_count == 2
				if tiles[1] == "X"     # HUMAN PLAYS EDGE
					return [7,9].sample
				elsif tiles[3] == "X"
					return [3,9].sample
				elsif tiles[5] == "X"
					return [1,7].sample
				elsif tiles[7] == "X"
					return [1,3].sample
				elsif tiles[0] == "X"  # HUMAN PLAYS CORNER
					return 9
				elsif tiles[2] == "X"
					return 7
				elsif tiles[6] == "X"
					return 3
				elsif tiles[8] == "X"
					return 1
				end
			elsif @board.move_count == 4   # HUMAN PLAYS CORNER AND SPECIFIC EDGE
				if tiles[0] == "X" && tiles[5] == "X"
					return 7
				elsif tiles[0] == "X" && tiles[7] == "X"
					return 3
				elsif tiles[2] == "X" && tiles[3] == "X"
					return 9
				elsif tiles[2] == "X" && tiles[7] == "X"
					return 1
				elsif tiles[6] == "X" && tiles[5] == "X"
					return 1
				elsif tiles[6] == "X" && tiles[1] == "X"
					return 9
				elsif tiles[8] == "X" && tiles[1] == "X"
					return 7
				elsif tiles[8] == "X" && tiles[3] == "X"
					return 3
				end
			end
		end

		if @board.size == 4
			if @board.move_count == 0 || @board.move_count == 1
				move = [1,4,13,16].sample
				until tiles[move-1] == "-"
					move = [1,4,13,16].sample
				end
				return move
			end
		end
		nil
	end

	def hopeful_move
		best_o_count = 0
		best_combo = []
		best_combo_index = 0

		@board.winning_possibilities.shuffle.each do |combo|  # PUT "O" IN A POSSIBLE WINNING ROW
			combo = combo.shuffle
			possibility = []

			combo.each do |location|
				possibility << @board.tiles[location]
			end

			if possibility.include?("O") && possibility.include?("-") && !possibility.include?("X")
				o_count = possibility.count("O")
				if o_count > best_o_count
					best_o_count = o_count
					best_combo = combo
					best_combo_index = possibility.index("-")
				end
			end
		end

		return best_combo[best_combo_index] + 1 if best_o_count > 0
		nil
	end

	def center_move
		if @board.size.odd?
			center = (@board.size / 2 * @board.size) + (@board.size / 2 + 1)
			return center if @board.tile_open?(center)
		end
	end

	def random_move
		tile_number = rand(@board.size**2) + 1
		until @board.tile_open?(tile_number)
			tile_number = rand(@board.size**2) + 1
		end
		tile_number
	end
end

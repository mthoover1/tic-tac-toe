class ComputerPlayer
	def initialize(board)
		@board = board
	end

	def move
		try_to_win ||
		try_to_block ||
		try_to_future_win ||
		try_to_future_block ||
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
		@board.winning_possibilities.each do |combo|
			possibility = build_possibility(combo, @board.tiles)

			if one_move_away?(possibility, letter)
				combo_index = possibility.index("-")
				return combo[combo_index] + 1
			end
		end
		nil
	end

	def try_to_future_block
		look_for_future_opening("X")
	end

	def try_to_future_win
		look_for_future_opening("O")
	end

	def look_for_future_opening(letter)
		@board.tiles.chars.each_with_index do |tile, index|
			test_tiles = @board.tiles.dup

			if tile == "-"
				win_chance_count = 0
				test_tiles[index] = letter

				@board.winning_possibilities.each do |combo|
					possibility = build_possibility(combo, test_tiles)

					win_chance_count += 1 if one_move_away?(possibility, letter)
				end

				return (index+1) if win_chance_count > 1
			end
		end
		nil
	end

	def build_possibility(combo, tiles)
		possibility = []
		combo.each do |location|
			possibility << tiles[location]
		end
		possibility
	end

	def one_move_away?(possibility, letter)
		possibility.count("-") == 1 && possibility.include?(letter) && possibility.uniq.length == 2
	end

	def strategic_move
		return three_by_three_strategic_move if @board.size == 3
		return four_by_four_strategic_move	if @board.size == 4
		return big_board_strategic_move if @board.size > 4 && @board.size.even?
	end

	def three_by_three_strategic_move
		return three_by_three_after_one_move if @board.move_count == 1
		return three_by_three_after_two_moves if @board.move_count == 2
		return three_by_three_after_three_moves if @board.move_count == 3
		return three_by_three_after_four_moves if @board.move_count == 4
	end

	def three_by_three_after_one_move
		return @board.tile_open?(5) ? 5 : 1    #take center if open, else take top-left
	end

	def three_by_three_after_two_moves
		tiles = @board.tiles
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
	end

	def three_by_three_after_three_moves
		tiles = @board.tiles
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
	end

	def three_by_three_after_four_moves
		tiles = @board.tiles
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

	def four_by_four_strategic_move
		if @board.move_count == 0 || @board.move_count == 1
			move = @board.corner_tile_numbers.sample
			until @board.tiles[move-1] == "-"
				move = @board.corner_tile_numbers.sample
			end
			return move
		end
	end

	def big_board_strategic_move
		if @board.move_count == 0 || @board.move_count == 1
			center_tiles = @board.generate_center_tile_numbers
			move = center_tiles.sample
			until @board.tiles[move-1] == "-"
				move = center_tiles.sample
			end
			return move
		end
	end

	def hopeful_move
		best_o_count = 0
		best_combo = []
		best_combo_index = 0

		@board.winning_possibilities.shuffle.each do |combo|  # PUT "O" IN A POSSIBLE WINNING ROW
			combo = combo.shuffle
			possibility = build_possibility(combo, @board.tiles)

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

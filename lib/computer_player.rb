class ComputerPlayer
	attr_reader :board, :symbol

	def initialize(board, symbol = "O")
		@board = board
		@symbol = symbol
		@opponent_symbol = set_opponent_symbol
	end

	def set_opponent_symbol
		@symbol == "X" ? @opponent_symbol = "O" : @opponent_symbol = "X"
	end

	def move
		Kernel.sleep(0.5) if @board.move_count > 0

		move = try_to_win ||
					 try_to_block ||
					 strategic_move ||
					 try_to_setup_win_on_next_move ||
					 try_to_block_move_that_leads_to_loss ||
					 # try_to_future_future_win ||
					 hopeful_move ||
					 center_move ||
					 random_move

		@board.update(move, @symbol)
	end

	def try_to_win
		look_for_opening(symbol)
	end

	def try_to_block
		look_for_opening(@opponent_symbol)
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

	def try_to_block_move_that_leads_to_loss
		# look_for_future_opening(@opponent_symbol)
		best_tile_location = nil
		best_win_chance_count = 0
		best_nearby_o_count = 0

		@board.tiles.chars.each_with_index do |tile, tile_location|
			test_tiles = @board.tiles.dup

			if tile == "-"
				win_chance_count = 0
				nearby_o_count = 0

				test_tiles[tile_location] = @opponent_symbol

				@board.winning_possibilities.each do |combo|
					possibility = build_possibility(combo, test_tiles)

					win_chance_count += 1 if one_move_away?(possibility, @opponent_symbol)
				end

				test_tiles[tile_location] = "-"

				if win_chance_count >= best_win_chance_count
					@board.winning_possibilities.each do |combo|
						if combo.include?(tile_location)
							possibility = build_possibility(combo, test_tiles)

							nearby_o_count += 1 if possibility.include?(symbol) && !possibility.include?(@opponent_symbol)
						end
					end
				end

				if win_chance_count >= 2 && nearby_o_count >= best_nearby_o_count
					best_win_chance_count = win_chance_count
					best_nearby_o_count = nearby_o_count
					best_tile_location = tile_location
				end
			end
		end
		return (best_tile_location+1) if best_win_chance_count >= 2
	end

	def try_to_setup_win_on_next_move(tiles = @board.tiles)
		# look_for_future_opening(symbol)

		best_tile_location = nil
		best_win_chance_count = 0
		best_nearby_x_count = 0

		tiles.chars.each_with_index do |tile, tile_location|
			test_tiles = tiles.dup

			if tile == "-"
				win_chance_count = 0
				nearby_x_count = 0

				test_tiles[tile_location] = symbol

				@board.winning_possibilities.each do |combo|
					possibility = build_possibility(combo, test_tiles)

					win_chance_count += 1 if one_move_away?(possibility, symbol)
				end

				test_tiles[tile_location] = "-"

				if win_chance_count >= best_win_chance_count
					@board.winning_possibilities.each do |combo|
						if combo.include?(tile_location)
							possibility = build_possibility(combo, test_tiles)

							nearby_x_count += 1 if possibility.include?(@opponent_symbol) && !possibility.include?(symbol)
						end
					end
				end

				if win_chance_count >= 2 && nearby_x_count >= best_nearby_x_count
					best_win_chance_count = win_chance_count
					best_nearby_x_count = nearby_x_count
					best_tile_location = tile_location
				end
			end
		end
		return (best_tile_location+1) if best_win_chance_count >= 2
	end

	def look_for_future_opening(letter)
		@board.tiles.chars.each_with_index do |tile, index|
			test_tiles = @board.tiles.dup

			if tile == "-"
				test_tiles[index] = letter

				@board.winning_possibilities.each do |combo|
					possibility = build_possibility(combo, test_tiles)

					win_chance_count += 1 if one_move_away?(possibility, letter)
				end

				return (index+1) if win_chance_count >= 2
			end
		end
		nil
	end

	# def try_to_future_future_win
	# 	@board.tiles.chars.each_with_index do |tile1, index1|
	# 		test_tiles = @board.tiles.dup

	# 		if tile1 == "-"
	# 			test_tiles[index1] = symbol

	# 			test_tiles.chars.each_with_index do |tile2, index2|
	# 				test2_tiles = test_tiles.dup

	# 				if tile2 == "-"
	# 					win_chance_count = 0
	# 					test2_tiles[index2] = symbol

	# 					@board.winning_possibilities.each do |combo|
	# 						if combo.include?(index2)
	# 							possibility = build_possibility(combo, test2_tiles)
	# 							puts "index1 #{index1} - index2 #{index2} - combo #{combo} - possibility #{possibility}" if one_move_away?(possibility, symbol)

	# 							win_chance_count += 1 if one_move_away?(possibility, symbol)
	# 						end
	# 					end
	# 				return (index1+1) if win_chance_count >= 4
	# 				end
	# 			end

	# 		end
	# 	end
	# 	nil
	# end

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
		if tiles[1] == @opponent_symbol     # OPPONENT PLAYS EDGE
			return [7,9].sample
		elsif tiles[3] == @opponent_symbol
			return [3,9].sample
		elsif tiles[5] == @opponent_symbol
			return [1,7].sample
		elsif tiles[7] == @opponent_symbol
			return [1,3].sample
		elsif tiles[0] == @opponent_symbol  # OPPONENT PLAYS CORNER
			return 9
		elsif tiles[2] == @opponent_symbol
			return 7
		elsif tiles[6] == @opponent_symbol
			return 3
		elsif tiles[8] == @opponent_symbol
			return 1
		end
	end

	def three_by_three_after_three_moves
		tiles = @board.tiles
		if tiles[4] == @opponent_symbol && tiles[8] == @opponent_symbol
			return [3,7].sample
		elsif (tiles[0] == @opponent_symbol && tiles[8] == @opponent_symbol) || (tiles[2] == @opponent_symbol && tiles[6] == @opponent_symbol)
			return [1,3,5,7].sample + 1
		elsif tiles[3] == @opponent_symbol && tiles[2] == @opponent_symbol # OPPONENT PLAYS EDGE AND A FAR CORNER (computer plays corner in between)
			return 1
		elsif tiles[3] == @opponent_symbol && tiles[8] == @opponent_symbol
			return 7
		elsif tiles[1] == @opponent_symbol && tiles[6] == @opponent_symbol
			return 1
		elsif tiles[1] == @opponent_symbol && tiles[8] == @opponent_symbol
			return 3
		elsif tiles[5] == @opponent_symbol && tiles[0] == @opponent_symbol
			return 3
		elsif tiles[5] == @opponent_symbol && tiles[6] == @opponent_symbol
			return 9
		elsif tiles[7] == @opponent_symbol && tiles[0] == @opponent_symbol
			return 7
		elsif tiles[7] == @opponent_symbol && tiles[2] == @opponent_symbol
			return 9
		end
	end

	def three_by_three_after_four_moves
		tiles = @board.tiles
		if tiles[0] == @opponent_symbol && tiles[5] == @opponent_symbol
			return 7
		elsif tiles[0] == @opponent_symbol && tiles[7] == @opponent_symbol
			return 3
		elsif tiles[2] == @opponent_symbol && tiles[3] == @opponent_symbol
			return 9
		elsif tiles[2] == @opponent_symbol && tiles[7] == @opponent_symbol
			return 1
		elsif tiles[6] == @opponent_symbol && tiles[5] == @opponent_symbol
			return 1
		elsif tiles[6] == @opponent_symbol && tiles[1] == @opponent_symbol
			return 9
		elsif tiles[8] == @opponent_symbol && tiles[1] == @opponent_symbol
			return 7
		elsif tiles[8] == @opponent_symbol && tiles[3] == @opponent_symbol
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

		@board.winning_possibilities.shuffle.each do |combo|  # PUT symbol IN A POSSIBLE WINNING ROW
			combo = combo.reverse if [0,1].sample == 1
			possibility = build_possibility(combo, @board.tiles)

			if possibility.include?(symbol) && possibility.include?("-") && !possibility.include?(@opponent_symbol)
				o_count = possibility.count(symbol)

				if o_count > best_o_count
					best_o_count = o_count
					best_combo = combo

					o_index = possibility.index(symbol)

					if possibility[o_index+1] == "-"
						best_combo_index = o_index+1
					elsif possibility[o_index-1] == "-" && o_index > 0
						best_combo_index = o_index-1
					elsif possibility[o_index+2] == "-"
						best_combo_index = o_index+2
					end
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

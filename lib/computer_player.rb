class ComputerPlayer
	attr_reader :board, :symbol

	def initialize(board, symbol = nil)
		@board = board
		@symbol = symbol || @board.symbol2
		@opponent_symbol = set_opponent_symbol
	end

	def set_opponent_symbol
		@symbol == @board.symbol1 ? @opponent_symbol = @board.symbol2 : @opponent_symbol = @board.symbol1
	end

	def get_move
		try_to_win ||
		try_to_block ||
		# strategic_move ||
		try_to_setup_win_on_next_move ||
		try_to_block_move_that_leads_to_loss ||
		hopeful_move ||
		center_move ||
		random_move
	end

	def try_to_win
		look_for_opening(@symbol)
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

	def try_to_setup_win_on_next_move
		find_move_that_leads_to_end_game(@symbol, @opponent_symbol)
	end

	def try_to_block_move_that_leads_to_loss
		find_move_that_leads_to_end_game(@opponent_symbol, @symbol)
	end

	def find_move_that_leads_to_end_game(target_symbol, other_symbol)
		best_tile_location = nil
		best_win_chance_count = 0
		best_nearby_count = 0

		@board.tiles.chars.each_with_index do |tile, tile_location|
			next if tile != "-"

			win_chance_count = calculate_number_of_win_chances(target_symbol, tile_location)
			nearby_count = calculate_number_of_nearby(win_chance_count, best_win_chance_count, tile_location, target_symbol, other_symbol)

			if win_chance_count >= 2 && nearby_count >= best_nearby_count
				best_win_chance_count = win_chance_count
				best_nearby_count = nearby_count
				best_tile_location = tile_location
			end
		end
		return (best_tile_location + 1) if best_win_chance_count >= 2
	end

	def calculate_number_of_win_chances(target_symbol, tile_location)
		win_chance_count = 0
		test_tiles = @board.tiles.dup
		test_tiles[tile_location] = target_symbol

		@board.winning_possibilities.each do |combo|
			possibility = build_possibility(combo, test_tiles)
			win_chance_count += 1 if one_move_away?(possibility, target_symbol)
		end

		win_chance_count
	end

	def calculate_number_of_nearby(win_chance_count, best_win_chance_count, tile_location, target_symbol, other_symbol)
		return 0 if win_chance_count < best_win_chance_count

		nearby_count = 0

		@board.winning_possibilities.select{|combo| combo.include?(tile_location)}.each do |combo|
			possibility = build_possibility(combo, @board.tiles)
			nearby_count += 1 if possibility.include?(other_symbol) && !possibility.include?(target_symbol)
		end

		nearby_count
	end

	def build_possibility(combo, tiles)
		combo.map{|location| tiles[location]}
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
		return center_move || 1
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

		scenarios = [[0,5,7],[0,7,3],[2,3,9],[2,7,1],[6,5,1],[6,1,9],[8,1,7],[8,3,3]]

		scenarios.each do |scenario|
			if tiles[scenario[0]] == @opponent_symbol && tiles[scenario[1]] == @opponent_symbol
				return scenario[2]
			end
		end

		# if tiles[0] == @opponent_symbol && tiles[5] == @opponent_symbol
		# 	return 7
		# elsif tiles[0] == @opponent_symbol && tiles[7] == @opponent_symbol
		# 	return 3
		# elsif tiles[2] == @opponent_symbol && tiles[3] == @opponent_symbol
		# 	return 9
		# elsif tiles[2] == @opponent_symbol && tiles[7] == @opponent_symbol
		# 	return 1
		# elsif tiles[6] == @opponent_symbol && tiles[5] == @opponent_symbol
		# 	return 1
		# elsif tiles[6] == @opponent_symbol && tiles[1] == @opponent_symbol
		# 	return 9
		# elsif tiles[8] == @opponent_symbol && tiles[1] == @opponent_symbol
		# 	return 7
		# elsif tiles[8] == @opponent_symbol && tiles[3] == @opponent_symbol
		# 	return 3
		# end
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

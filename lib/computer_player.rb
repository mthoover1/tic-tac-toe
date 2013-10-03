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
		check_safety(try_to_setup_win_on_next_move) ||
		check_safety(try_to_block_move_that_leads_to_loss) ||
		check_safety(hopeful_move) ||
		check_safety(center_move) ||
		safe_move ||
		random_move
	end

	def try_to_win
		look_for_opening(@symbol)
	end

	def try_to_block
		look_for_opening(@opponent_symbol)
	end

	def look_for_opening(letter, tiles = @board.tiles)
		@board.winning_possibilities.each do |combo|
			possibility = build_possibility(combo, tiles)

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

	def find_move_that_leads_to_end_game(target_symbol, other_symbol, tiles = @board.tiles)
		best_tile_location = nil
		best_win_chance_count = 0
		best_nearby_count = 0

		tiles.chars.each_with_index do |tile, tile_location|
			next if tile != "-"

			win_chance_count = calculate_number_of_win_chances(target_symbol, tile_location, tiles)
			nearby_count = calculate_number_of_nearby(win_chance_count, best_win_chance_count, tile_location, target_symbol, other_symbol, tiles)

			if win_chance_count >= 2 && nearby_count >= best_nearby_count
				best_win_chance_count = win_chance_count
				best_nearby_count = nearby_count
				best_tile_location = tile_location
			end
		end
		return (best_tile_location + 1) if best_win_chance_count >= 2
	end

	def calculate_number_of_win_chances(target_symbol, tile_location, tiles)
		win_chance_count = 0
		test_tiles = tiles.dup
		test_tiles[tile_location] = target_symbol

		@board.winning_possibilities.each do |combo|
			possibility = build_possibility(combo, test_tiles)
			win_chance_count += 1 if one_move_away?(possibility, target_symbol)
		end

		win_chance_count
	end

	def calculate_number_of_nearby(win_chance_count, best_win_chance_count, tile_location, target_symbol, other_symbol, tiles)
		return 0 if win_chance_count < best_win_chance_count

		nearby_count = 0

		@board.winning_possibilities.select{|combo| combo.include?(tile_location)}.each do |combo|
			possibility = build_possibility(combo, tiles)
			nearby_count += 1 if possibility.include?(other_symbol) && !possibility.include?(target_symbol)
		end

		nearby_count
	end

	def is_move_safe?(tile_number)
		return false if tile_number == nil
		return false if look_for_opening(@opponent_symbol) && look_for_opening(@opponent_symbol) != tile_number

		test_tiles = @board.tiles.dup
		test_tiles[tile_number - 1] = @symbol

		next_opponent_tile_number = find_move_that_leads_to_end_game(@opponent_symbol, @symbol, test_tiles)
		next_computer_tile_number = look_for_opening(@symbol, test_tiles)

		return false if next_opponent_tile_number == next_computer_tile_number && next_opponent_tile_number != nil

		return true
	end

	def check_safety(move_type)
		move = move_type
		return move if is_move_safe?(move)
		return nil
	end

	def build_possibility(combo, tiles)
		combo.map{|location| tiles[location]}
	end

	def one_move_away?(possibility, letter)
		possibility.count("-") == 1 && possibility.include?(letter) && possibility.uniq.length == 2
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

	def safe_move
		best_possible_win_count = 0
		best_tile_location = nil

		@board.tiles.chars.each_with_index do |tile, i|
			next if tile != "-"
			possible_win_count = 0

			@board.winning_possibilities.select{|combo| combo.include?(i)}.each do |combo|
				possibility = build_possibility(combo, @board.tiles)
				possible_win_count += 1 if !possibility.include?(@opponent_symbol)
			end

			if possible_win_count >= best_possible_win_count && is_move_safe?(i + 1)
				best_possible_win_count = possible_win_count
				best_tile_location = i
			end
		end

		return (best_tile_location + 1)
	end

	def random_move
		tile_number = rand(@board.size**2) + 1
		until @board.tile_open?(tile_number)
			tile_number = rand(@board.size**2) + 1
		end
		tile_number
	end
end

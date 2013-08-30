class ComputerPlayer
	def initialize(board)
		@board = board
	end

	CORNERS = [0,2,6,8]
	EDGES = [1,3,5,7]
	WINNING_POSSIBILITIES = [ [0,1,2],
														[3,4,5],
														[6,7,8],
														[0,3,6],
														[1,4,7],
														[2,5,8],
														[0,4,8],
														[2,4,6]  ]

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
		WINNING_POSSIBILITIES.each do |combo|
			combo = combo.shuffle
			if @board.tiles[combo[0]] == letter && @board.tiles[combo[1]] == letter && @board.tiles[combo[2]] == "-"
				return combo[2] + 1
			elsif @board.tiles[combo[0]] == letter && @board.tiles[combo[1]] == "-" && @board.tiles[combo[2]] == letter
				return combo[1] + 1
			elsif @board.tiles[combo[0]] == "-" && @board.tiles[combo[1]] == letter && @board.tiles[combo[2]] == letter
				return combo[0] + 1
			end
		end
		nil
	end

	def strategic_move
		tiles = @board.tiles

		# HUMAN FIRST
		if @board.move_count == 1
			return 1 if tiles[4] == "X"
			return 5
		elsif @board.move_count == 3
			if tiles[4] == "X" && tiles[8] == "X"
				return [3,7].sample
			elsif (tiles[0] == "X" && tiles[8] == "X") || (tiles[2] == "X" && tiles[6] == "X")
				return EDGES.sample + 1
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
		nil
	end

	def hopeful_move
		WINNING_POSSIBILITIES.shuffle.each do |combo|  # PUT "O" IN A POSSIBLE WINNING ROW
			combo_contents = []
			combo.each do |location|
				combo_contents << @board.tiles[location]
			end

			if combo_contents.include?("O") && combo_contents.include?("-") && !combo_contents.include?("X")
				empty_index = combo_contents.index("-")
				return combo[empty_index] + 1
			end
		end
		nil
	end

	def center_move
		return 5 if @board.tile_open?(5)
	end

	def random_move
		tile_number = rand(9) + 1
		until @board.tile_open?(tile_number)
			tile_number = rand(9) + 1
		end
		tile_number
	end
end

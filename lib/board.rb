class Board
	attr_reader :tiles, :move_count, :last_player, :size, :winning_possibilities, :corner_tile_numbers

	# Computer is O, Human is X

	def initialize(size)
		@size = size
		@tiles = build_board(size)
		@last_player = ""
		@move_count = 0
		@winning_possibilities = generate_winning_possibilities(size)
		@corner_tile_numbers = generate_corner_tile_numbers(size)
	end

	def build_board(size)
		"-"*(size**2)
	end

	def generate_winning_possibilities(size)
		generate_horizontals(size) + generate_verticals(size) + generate_diagonals(size)
	end

	def generate_horizontals(size)
		return generate_big_board_horizontals(size) if size > 4

 		horizontals = []

		size.times do |i|
			start = size * i
			combo = []
			size.times do |index|
				combo << start + index
			end
			horizontals << combo
		end

		horizontals
	end

	def generate_verticals(size)
		return generate_big_board_verticals(size) if size > 4

		verticals = []

		size.times do |i|
			start = i
			combo = []
			size.times do |index|
				combo << start + size*index
			end
			verticals << combo
		end

		verticals
	end

	def generate_diagonals(size)
		return generate_big_board_diagonals(size) if size > 4

		diagonals = []

		diagonal = []	      #diagonal 1
		size.times do |i|
			diagonal << (size + 1) * i
		end
		diagonals << diagonal

		diagonal = []	      #diagonal 2
		size.times do |i|
			diagonal << (size * (i+1)) - (i + 1)
		end
		diagonals << diagonal

		diagonals
	end

	def generate_big_board_horizontals(size)
		horizontals = []

		size.times do |row_index|
			(size-3).times do |combo_count|
				start = size*row_index + combo_count
				combo = []
				4.times do |i|
					combo << start + i
				end
				horizontals << combo
			end
		end

		horizontals
	end

	def generate_big_board_verticals(size)
		verticals = []

		size.times do |column_index|
			(size-3).times do |combo_count|
				start = column_index + size*combo_count
				combo = []
				4.times do |i|
					combo << start + size*i
				end
				verticals << combo
			end
		end

		verticals
	end

	def generate_big_board_diagonals(size)
		tile_set = (0..(size**2 - 1)).to_a
		diagonals = []

		tile_set.each do |tile|
			if tile % size <= (size-4) && tile < size**2 - size*3
				combo = []
				4.times do |i|
					combo << tile + i*(size+1)
				end
				diagonals << combo
			end
		end

		tile_set.each do |tile|
			if tile % size >= 3 && tile <= size**2 - size*3
				combo = []
				4.times do |i|
					combo << tile + i*(size-1)
				end
				diagonals << combo
			end
		end

		diagonals
	end

	def generate_corner_tile_numbers(size)
		[1, size, size**2 - (size - 1), size**2]
	end

	def generate_center_tile_numbers
		mid_point = @size**2/2
		[(mid_point - @size/2), (mid_point - @size/2 + 1), (mid_point + @size/2), (mid_point + @size/2 + 1)]
	end

	def to_s
		formatted = tiles.split("").join(" ")

		index = @size*2 - 1

		size.times do
			formatted[index] = "\n"
			index += @size*2
		end

		formatted << "\n"
	end

	def tile_open?(tile_number)
		tiles[tile_number - 1] == "-"
	end

	def update(tile_number, player)
		tiles[tile_number - 1] = player
		@move_count += 1
		@last_player = player
	end

	def future_cats_game?
		@winning_possibilities.each do |combo|
			possibility = []

			combo.each do |location|
				possibility << tiles[location]
			end

			return false if possibility.include?("-") && [1,2].include?(possibility.uniq.length)
		end
		true
	end

	def full?
		!tiles.include?("-")
	end

	def won?
		@winning_possibilities.each do |combo|
			if ["X","O"].include?(tiles[combo[0]])
				possibility = []

				combo.each do |location|
					possibility << tiles[location]
				end

				if possibility.uniq.length == 1
					return true
				end
			end
		end
		false
	end

	def tied?
		full? && !won?
	end
end

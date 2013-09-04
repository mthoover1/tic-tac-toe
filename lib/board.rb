class Board
	attr_reader :tiles, :move_count, :last_player, :size, :winning_possibilities

	# Computer is O, Human is X

	def initialize(size)
		@size = size
		@tiles = build_board(size)
		@last_player = ""
		@move_count = 0
		@winning_possibilities = generate_winning_possibilities(size)
	end

	def build_board(size)
		"-"*(size**2)
	end

	def generate_winning_possibilities(size)
		generate_horizontals(size) + generate_verticals(size) + generate_diagonals(size)
	end

	def generate_horizontals(size)
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

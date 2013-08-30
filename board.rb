class Board
	attr_reader :tiles, :move_count, :last_player

	# Computer is O, Human is X

	def initialize
		@tiles = "---------"
		@move_count = 0
		@last_player = ""
	end

	def to_s
		pretty_board = tiles.split("").join(" ")                  #space out letters
		[5,11,17,18].each { |index| pretty_board[index] = "\n"}   #insert new lines
		pretty_board
	end

	def tile_open?(tile_number)
		tiles[tile_number - 1] == "-"
	end

	def update(tile_number, player)
		tiles[tile_number - 1] = player
		@move_count += 1
		@last_player = player
	end

	WINNING_POSSIBILITIES = [ [0,1,2],
														[3,4,5],
														[6,7,8],
														[0,3,6],
														[1,4,7],
														[2,5,8],
														[0,4,8],
														[2,4,6]  ]

	def full?
		!tiles.include?("-")
	end

	def won?
		WINNING_POSSIBILITIES.each do |combo|
			if ["X","O"].include?(tiles[combo[0]])
				if tiles[combo[0]] == tiles[combo[1]] && tiles[combo[0]] == tiles[combo[2]]
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

class Interface
	def clear_screen
		"\e[H\e[2J\n"
	end

	def instructions(size)
		total = size ** 2
		output_string = ""

		total.times do |i|
			number = i + 1

			if number % size == 0
				output_string << "#{number}\n"
			elsif number < 10
				output_string << "#{number}  "
			elsif number >= 10
				output_string << "#{number} "
			end
		end

		output_string << "\n"
	end

	def pick_board_size
		"Enter board width:\n"
	end

	def prompt_human
		"Enter your next move:"
	end

	def get_input
		input = gets.chomp
		input.to_i
	end

	def input_valid?(input, size)
		input >= 1 && input <= (size**2)
	end

	def display_results(board, human, computer)
		return "Cat's Game" if board.tied?
		if board.won?
			return "Human Wins!!" if board.last_player == human
			return "Computer Wins" if board.last_player == computer
		end
		return "Cat's Game (Saving You Time)" if board.future_cats_game?
	end
end

class Board
  attr_accessor :tiles, :move_count, :last_player, :size, :winning_possibilities, :corner_tile_numbers, :win_length

  SYMBOL1 = "X"
  SYMBOL2 = "O"

  def initialize(size)
    @size = size
    @tiles = build_board(size)
    @win_length = generate_win_length(size)
    @last_player = ""
    @move_count = 0
    @winning_possibilities = generate_winning_possibilities(size)
    @corner_tile_numbers = generate_corner_tile_numbers(size)
  end

  def build_board(size)
    "-"*(size**2)
  end

  def generate_win_length(size)
    if size == 3
      3
    elsif size >= 4
      4
    end
  end

  def generate_winning_possibilities(size)
    generate_horizontals(size) + generate_verticals(size) + generate_diagonals(size)
  end

  def generate_horizontals(size)
    if size == 3
      win_length = 3
    elsif size >= 4
      win_length = 4
    end

    horizontals = []

    size.times do |row_index|
      (size - (win_length-1)).times do |combo_count|
        start = size*row_index + combo_count
        combo = []
        win_length.times do |i|
          combo << start + i
        end
        horizontals << combo
      end
    end

    horizontals
  end

  def generate_verticals(size)
    if size == 3
      win_length = 3
    elsif size >= 4
      win_length = 4
    end

    verticals = []

    size.times do |column_index|
      (size - (win_length-1)).times do |combo_count|
        start = column_index + size*combo_count
        combo = []
        win_length.times do |i|
          combo << start + size*i
        end
        verticals << combo
      end
    end

    verticals
  end

  def generate_diagonals(size)
    tile_set = (0..(size**2 - 1)).to_a
    diagonals = []

    tile_set.each do |tile|
      row = tile / size
      column = tile % size
      combo = []

      if row + win_length <= size && column + win_length <= size
        win_length.times do |i|
          combo << tile + (size+1)*i
        end
        diagonals << combo

      elsif row + win_length <= size && column - win_length >= -1
        win_length.times do |i|
          combo << tile + (size-1)*i
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
    tiles[tile_number - 1] == "-" if tile_number >= 1
  end

  def update(tile_number, player)
    tiles[tile_number - 1] = player
    @move_count += 1
    @last_player = player
  end

  def count_moves
    @tiles.count("^-")
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
      if !["-"].include?(tiles[combo[0]])
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

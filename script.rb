require 'pry-byebug'

class Node
  attr_accessor :position, :parent

  def initialize(position, parent = nil)
    @position = position
    @parent = parent
  end
end

class Board < Node

  def initialize(piece, position)
    @board = create_board
    @piece = piece
    @position = position
  end

  def create_board
    arr = []
    num1 = 0
    num2 = 0
    
    while num1 != 8
      arr[num1] = []
      while num2 != 8
        arr[num1].push([num1, num2])
        num2 += 1
      end

      num2 = 0
      num1 += 1
    end
    arr
  end

  def display_board
    num = 0
    while num != 8
      p @board[num]
      num+=1
    end
  end

  def build_list
    num = 0
    hash = {}
    num2 = 0

    while num != 8
      @board[num].each do|item| 
        arr = potential_moves(item)
        hash[item] = arr
      end
      num += 1
    end
    hash
  end

  def output_list
    list = build_list

    list.each {|key, value| puts "#{key}: #{value}"}
  end

  def knight_moves(desired_position)
    list = build_list
    @root = Node.new(@position)
    queue = [ @root ]
    visited = [ ]

    return puts "That position isn't on the board" if desired_position[0] < 0 || desired_position[0] > 7 || desired_position[1] < 0 || desired_position[1] > 7

    while queue.length > 0 do
      visited << queue[0].position
      current_node = queue.shift

      list[current_node.position].each do |item|
        if visited.include?(item)
          next
        elsif item == desired_position
          return build_tree(current_node, desired_position)
        else
          queue.push(Node.new(item, current_node))
        end
      end
    end
  end

  def build_tree(current_node, desired_position)
    arr = [desired_position]

    until current_node == @root
      arr.unshift(current_node.position)
      current_node = current_node.parent
    end

    arr.unshift(@root.position)
    p arr
  end

  def potential_moves(knight_position)
    one = [knight_position[0] + 2,knight_position[1] + 1]
    two = [knight_position[0] + 2,knight_position[1] - 1]
    three = [knight_position[0] -2,knight_position[1] + 1]
    four = [knight_position[0] - 2,knight_position[1] - 1]
    five = [knight_position[0] + 1,knight_position[1] + 2]
    six = [knight_position[0] + 1,knight_position[1] - 2]
    seven = [knight_position[0] - 1,knight_position[1] + 2]
    eight =  [knight_position[0] - 1,knight_position[1] - 2]

    arr = [one, two, three, four, five, six, seven, eight]

    arr.each_with_index.reverse_each do |item, index| 
      
      if item[0] < 0 || item[0] > 7 || item[1] < 0 || item[1] > 7
        arr.delete_at(index)
      elsif arr == []
        return 
      end
    end 
  end
end

game = Board.new("knight", [3,3])
game.display_board
game.knight_moves([8,9])
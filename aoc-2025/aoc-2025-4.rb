# Advent of Code 2025, day 4
# https://adventofcode.com/2025/day/4
# Using ruby 3.4.7
# $ ruby aoc-2025-4.rb

INPUT_PATH = "inputs/aoc-2025-4.txt"

def count_adjacent_rolls(lines, line_idx, char_idx)
    count = 0

    # Iterate the 8 directions
    for dx in -1..1
        for dy in -1..1
            if dx == 0 && dy == 0
                next
            end

            new_line_idx = line_idx + dx
            new_char_idx = char_idx + dy

            # Skip if out of bounds
            if new_line_idx < 0 ||
                new_line_idx >= lines.length ||
                new_char_idx < 0 ||
                new_char_idx >= lines[new_line_idx].length

                next
            end

            if lines[new_line_idx][new_char_idx] == '@'
                count += 1
            end
        end
    end

    return count
end

# Returns lines after removing accessible rolls and the number removed
def remove_accessible_rolls(lines)
    new_lines = lines.map(&:dup)
    num_removed = 0

    for line_idx in 0..(lines.length - 1)
        for char_idx in 0..(lines[line_idx].length - 1)
            if lines[line_idx][char_idx] == '@' &&
                count_adjacent_rolls(lines, line_idx, char_idx) < 4

                new_lines[line_idx][char_idx] = '.'
                num_removed += 1
            end
        end
    end

    return new_lines, num_removed
end

begin
    lines = IO.readlines(INPUT_PATH)
    lines = lines.map { |x| x.strip }

    lines, num_removed = remove_accessible_rolls(lines)

    puts num_removed # 1437

    # Remove rolls until none are accessible
    total_removed = num_removed
    while num_removed > 0
        lines, num_removed = remove_accessible_rolls(lines)
        total_removed += num_removed
    end

    puts total_removed # 8765
rescue Errno::ENOENT
    puts "Error: file '#{INPUT_PATH}' not found"
end

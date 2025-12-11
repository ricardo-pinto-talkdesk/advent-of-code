# Advent of Code 2025, day 3
# https://adventofcode.com/2025/day/3
# Using ruby 3.4.7
# $ ruby aoc_2025_3.rb

INPUT_PATH = "inputs/aoc_2025_3.txt"

def get_max_char(str)
    if str.length == 0
        return nil
    end

    idx_of_max = 0

    for i in 0..(str.length - 1)
        if str[i] == '9'
            return i, str[i]
        end

        if str[i] > str[idx_of_max]
            idx_of_max = i
        end
    end

    return idx_of_max, str[idx_of_max]
end

def get_max_voltage_part1(line)
    if line.length == 0
        return 0
    end

    if line.length == 1
        return line.to_i
    end

    # Find max char but don't check last char
    max_char_idx, max_char = get_max_char(line[0..-2])

    # Find max char after the one already found
    max_char_after_idx, max_char_after = get_max_char(line[(max_char_idx + 1)..])

    # Concat chars and return as int
    return "#{max_char}#{max_char_after}".to_i
end

def get_max_voltage_part2(line)
    if line.length == 0
        return 0
    end

    if line.length <= 12
        return line.to_i
    end

    new_str = ""
    prev_idx = -1

    for tail_len in 11.downto(0)
        max_char_idx, max_char = get_max_char(line[(prev_idx + 1)..(-tail_len - 1)])
        new_str += max_char
        prev_idx += max_char_idx + 1
        fail "Expected equal chars but got different" if max_char != line[prev_idx]
    end

    return new_str.to_i
end

begin
    lines = IO.readlines(INPUT_PATH)
    sum1 = 0
    sum2 = 0

    lines.each do |line|
        line = line.strip
        sum1 += get_max_voltage_part1(line)
        sum2 += get_max_voltage_part2(line)
    end

    puts sum1 # 17694
    puts sum2 # 175659236361660
rescue Errno::ENOENT
    puts "Error: file '#{INPUT_PATH}' not found"
end

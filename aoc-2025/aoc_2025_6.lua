-- Advent of Code 2025, day 6
-- https://adventofcode.com/2025/day/6
-- Using Lua 5.4.8
-- $ lua aoc_2025_6.lua

INPUT_PATH = "inputs/aoc_2025_6.txt"

local function reduce(numbers, op)
    if op == '+' then
        local res = 0

        for i, num in ipairs(numbers) do
            res = res + tonumber(num)
        end

        return res
    elseif op == '*' then
        local res = 1

        for i, num in ipairs(numbers) do
            res = res * tonumber(num)
        end

        return res
    else
        error("Invalid operator")
    end
end

local function concat_digit_of_each_num(numbers, digit_idx)
    local res = ""

    for num_idx, num in ipairs(numbers) do
        local num_str = tostring(num)

        -- Concat digit char to result string 'res'
        if #num_str >= digit_idx then
            local char = string.sub(num_str, digit_idx, digit_idx)

            if char ~= ' ' then
                res = res .. char
            end
        end
    end

    return tonumber(res)
end

local function main()
    local lines = {} -- List of strings
    local max_line_length = 0

    -- Fill 'lines'
    for line in io.lines(INPUT_PATH) do
        line = line:gsub('%s+$', '') -- Trim right side
        table.insert(lines, line)
        max_line_length = math.max(max_line_length, #line)
    end

    local last_line = lines[#lines]

    -- List of { numbers, max_orders_magnitude, op }
    -- which are respectively a list of strings, an int and a string
    local columns = {}

    -- Fill columns.op
    for op in string.gmatch(last_line, "[%*%+]") do
        assert(op == '+' or op == '*', "Invalid operator")
        table.insert(columns, {op = op})
    end

    -- Fill columns.max_orders_magnitude
    columns[#columns].max_orders_magnitude = max_line_length - #last_line + 1
    local col_idx = 1
    for white_spaces_string in string.gmatch(last_line, "[^%+%*]+") do
        columns[col_idx].max_orders_magnitude = #white_spaces_string
        col_idx = col_idx + 1
    end

    -- Fill columns.numbers
    local op_char_idx_in_line = 1
    for col_idx, col in ipairs(columns) do
         col.numbers = {}

         for line_idx = 1, #lines - 1 do
            local num_str = string.sub(
                lines[line_idx],
                op_char_idx_in_line,
                op_char_idx_in_line + col.max_orders_magnitude - 1
            )

            table.insert(col.numbers, num_str)
         end

         op_char_idx_in_line = op_char_idx_in_line + col.max_orders_magnitude + 1
    end

    -- Fix 'numbers' field of last elem of 'columns' by appending empty string padding
    for num_idx, num_str in ipairs(columns[#columns].numbers) do
        local padding_needed = columns[#columns].max_orders_magnitude - #num_str
        if padding_needed > 0 then
            columns[#columns].numbers[num_idx] = num_str .. string.rep(" ", padding_needed)
        end
    end

    local answer1 = 0 -- Part 1 answer
    local answer2 = 0 -- Part 2 answer

    for col_idx, col in ipairs(columns) do
        answer1 = answer1 + reduce(col.numbers, col.op)

        local new_numbers = {}

        for digit_idx = 1, col.max_orders_magnitude do
            table.insert(new_numbers, concat_digit_of_each_num(col.numbers, digit_idx))
        end

        answer2 = answer2 + reduce(new_numbers, col.op)
    end

    print(answer1) -- 6172481852142
    print(answer2) -- 10188206723429
end

main()

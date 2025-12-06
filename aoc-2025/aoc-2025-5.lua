-- Advent of Code 2025, day 5
-- https://adventofcode.com/2025/day/5
-- Using Lua 5.4.8
-- $ lua aoc-2025-5.lua

INPUT_PATH = "inputs/aoc-2025-5.txt"

local function bool_to_int(b)
  return b and 1 or 0
end

-- ranges_map maps min to max
local function insert_range(ranges_map, min, max)
    if not ranges_map[min] then
        ranges_map[min] = max
    else
        ranges_map[min] = math.max(ranges_map[min], max)
    end
end

-- ranges_map maps min to max
local function in_any_range(ranges_map, value)
    for min, max in pairs(ranges_map) do
        if value >= min and value <= max then
            return true
        end
    end

    return false
end

local function main()
    local fresh_ranges = {} -- Maps min to max
    local fresh_count = 0 -- Part 1 answer

    for line in io.lines(INPUT_PATH) do
        line = line:match("^%s*(.-)%s*$") -- Trim

        local min_str, max_str = line:match("(%d+)-(%d+)") -- e.g. "50-60"

        if min_str and max_str then
            local min, max = tonumber(min_str), tonumber(max_str)
            insert_range(fresh_ranges, min, max)
            goto continue
        end

        local num_str = line:match("(%d+)") -- Just an integer

        if num_str then
            local num = tonumber(num_str)
            fresh_count = fresh_count + bool_to_int(in_any_range(fresh_ranges, num))
        end

        ::continue::
    end

    -- Get keys
    local minimums = {}
    for min, max in pairs(fresh_ranges) do
        table.insert(minimums, min)
    end

    -- Sort keys
    table.sort(minimums)

    local num_unique_ids = 0 -- Part 2 answer
    local prev_max = nil

    -- Iterate ranges (sorted by the lower bound)
    for i, min in ipairs(minimums) do
        local max = fresh_ranges[min]

        -- First range special case
        if not prev_max then
            num_unique_ids = max - min + 1
            prev_max = max
            goto continue
        end

        -- Example: if first range is 20-30 and second one is 25-35, we update 25 to be 31
        min = math.max(min, prev_max + 1)

        -- Example: if the second range is 25-28 instead of 25-35,
        -- then the max() above makes it 31-28 which is invalid so skip it
        if max >= min then
            num_unique_ids = num_unique_ids + max - min + 1
        end

        -- If second range is 25-28, prev_max is kept at 30
        -- If second range is 25-35, prev_max is updated to 35
        prev_max = math.max(prev_max, max)
        ::continue::
    end

    print(fresh_count) -- 505
    print(num_unique_ids) -- 344423158480189
end

main()

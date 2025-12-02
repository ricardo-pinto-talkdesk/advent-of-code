// Advent of Code 2025, day 2
// https://adventofcode.com/2025/day/2
// Using zig 0.15.2
// $ zig run aoc-2025-2.zig -O ReleaseFast

const std = @import("std");

const INPUT_PATH: []const u8 = "aoc-2025-2.txt";

pub fn main() !void {
    // Init allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    // Read file
    const cwd = std.fs.cwd();
    const fileContents = try cwd.readFileAlloc(alloc, INPUT_PATH, 10 * 1024 * 1024);
    defer alloc.free(fileContents);

    var ranges = std.mem.splitScalar(u8, fileContents, ',');
    var sum1: u64 = 0;
    var sum2: u64 = 0;

    while (ranges.next()) |rangeStr| {
        var split = std.mem.splitScalar(u8, rangeStr, '-');
        var current: u64 = try std.fmt.parseInt(u64, split.next() orelse continue, 10);
        const max: u64 = try std.fmt.parseInt(u64, split.next() orelse continue, 10);

        // Iterate range
        while (current <= max) {
            try processNumber(current, &sum1, &sum2);
            current += 1;
        }
    }

    std.debug.print("{}\n", .{sum1}); // 24043483400
    std.debug.print("{}\n", .{sum2}); // 38262920235
}

pub fn processNumber(n: u64, sum1: *u64, sum2: *u64) !void {
    var strBuffer: [64]u8 = undefined;
    const digitsArr: []u8 = try std.fmt.bufPrint(&strBuffer, "{d}", .{n}); // ASCII bytes
    const midIdx: usize = @divTrunc(digitsArr.len, 2);

    // First half of number string = second half?
    // Never true for odd number of digits
    if (std.mem.eql(u8, digitsArr[0..midIdx], digitsArr[midIdx..])) {
        sum1.* += n;
    }

    // Example: 12 -> [1, 2, 3, 4, 6, 12]
    var divisorsBuffer: [64]u64 = undefined;
    const divisors: []u64 = divisorsBuffer[0..getDivisorsReturningCount(&divisorsBuffer, digitsArr.len)];

    // Iterate divisors since only slices with that length
    // can repeat throughout the whole number as string
    // For example in 666777666777, 3 is a divisor of 12 and slice of length 3 repeats
    for (divisors) |divisor| {
        if (repeats(u8, digitsArr, divisor)) {
            sum2.* += n;
            break;
        }
    }
}

// Fills buffer with the divisors of n and returns count
pub fn getDivisorsReturningCount(buffer: []u64, n: u64) usize {
    if (n == 0) {
        return 0;
    }

    var count: usize = 0;

    var i: u64 = 1;
    while (i * i <= n) : (i += 1) {
        if (n % i == 0) {
            std.debug.assert(count < buffer.len);
            buffer[count] = i;
            count += 1;

            const complement: u64 = n / i;
            if (complement != i) {
                std.debug.assert(count < buffer.len);
                buffer[count] = complement;
                count += 1;
            }

            std.debug.assert(count <= buffer.len);
        }
    }

    return count;
}

// Do the first 'sliceLen' elements repeat until the end of the array 'arr'?
pub fn repeats(comptime T: type, arr: []const T, sliceLen: usize) bool {
    if (sliceLen == 0 or sliceLen >= arr.len or @mod(arr.len, sliceLen) != 0) {
        return false;
    }

    // Iterate slices of length sliceLen and compare to the first slice
    // startIdx is always the start index of a slice with length sliceLen
    var startIdx: usize = sliceLen;
    while (startIdx + sliceLen <= arr.len) {
        if (!std.mem.eql(T, arr[startIdx..(startIdx + sliceLen)], arr[0..sliceLen])) {
            return false;
        }

        startIdx += sliceLen;
    }

    return true;
}

// Advent of Code 2025, day 1
// https://adventofcode.com/2025/day/1
// Using zig 0.15.2
// $ zig run aoc-2025-1.zig -O ReleaseFast

const std = @import("std");

const INPUT_PATH: []const u8 = "inputs/aoc-2025-1.txt";

pub fn main() !void {
    // Init allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    // Read file
    const cwd = std.fs.cwd();
    const fileContents = try cwd.readFileAlloc(alloc, INPUT_PATH, 10 * 1024 * 1024);
    defer alloc.free(fileContents);

    var dial: i32 = 50;
    var exactZeros: u32 = 0;
    var crossedZeros: u32 = 0;

    var lines = std.mem.tokenizeAny(u8, fileContents, "\r\n");
    while (lines.next()) |line| {
        //std.debug.print("{s}\n", .{line});

        const prevDial: i32 = dial;
        var unclampedDial: i32 = dial;
        const rotation: i32 = try std.fmt.parseInt(i32, line[1..], 10);

        if (line[0] == 'L') {
            unclampedDial -= @mod(rotation, 100);
        } else if (line[0] == 'R') {
            unclampedDial += @mod(rotation, 100);
        } else {
            @panic("Invalid first character in line");
        }

        // Negative example: -55 mod 100 = -155 mod 100 = 45
        dial = @mod(unclampedDial, 100);

        exactZeros += @intFromBool(dial == 0);

        // Count the first zero crossing if any
        crossedZeros += @intFromBool((prevDial != 0 and unclampedDial < 0) or unclampedDial > 100);

        // Count the other zero crossings
        crossedZeros += @intCast(@divTrunc(rotation, 100));
    }

    std.debug.print("{}\n", .{exactZeros}); // 1086
    std.debug.print("{}\n", .{exactZeros + crossedZeros}); // 6268
}

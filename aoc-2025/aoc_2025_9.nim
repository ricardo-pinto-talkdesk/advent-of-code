# Advent of Code 2025, day 9
# https://adventofcode.com/2025/day/9
# Using Nim 2.2.6
# $ nim compile --run -d:release aoc_2025_9.nim

import std/strutils
import std/sequtils

const INPUT_PATH = "inputs/aoc_2025_9.txt"

type Position = (int64, int64)

# Example "10,20"
proc strToPosition(str: string): Position =
  let split: seq[string] = str.split(',')
  return (split[0].parseInt.int64, split[1].parseInt.int64)

proc main() =
  let rectCorners: seq[Position] = toSeq(lines(INPUT_PATH)).mapIt(strToPosition(it))
  var maxArea: uint64 = 0

  for i in 0 .. high(rectCorners):
    for j in (i + 1) .. high(rectCorners):
      let (pos1, pos2) = (rectCorners[i], rectCorners[j])

      let w: uint64 = uint64(abs(pos2[0] - pos1[0])) + 1
      let h: uint64 = uint64(abs(pos2[1] - pos1[1])) + 1

      maxArea = max(maxArea, w * h)

  echo(maxArea) # 4786902990

when isMainModule:
  main()

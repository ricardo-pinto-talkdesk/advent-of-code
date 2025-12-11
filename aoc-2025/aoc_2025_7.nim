# Advent of Code 2025, day 7
# https://adventofcode.com/2025/day/7
# Using Nim 2.2.6
# $ nim compile --run -d:release --deepcopy:on aoc_2025_7.nim

import std/strutils
import std/sequtils

const INPUT_PATH = "inputs/aoc_2025_7.txt"

proc readLinesStripped(): seq[string] =
  var myLines: seq[string] = @[]

  for line in lines(INPUT_PATH):
    myLines.add(line.strip())

  return myLines

proc countTimelines(
    lines: seq[string], rayLineIdx: int, rayCharIdx: int, cache: var seq[seq[int64]]
): uint64 =
  assert rayLineIdx >= 0 and rayLineIdx < len(lines)
  assert rayCharIdx >= 0 and rayCharIdx < len(lines[rayLineIdx])

  # Use cache if possible
  if cache[rayLineIdx][rayCharIdx] >= 0:
    return cast[uint64](cache[rayLineIdx][rayCharIdx])

  # Find first splitter that this ray will hit
  var lineIdxOfSplitter: int = -1
  for lineIdx in (rayLineIdx + 1) .. high(lines):
    if lines[lineIdx][rayCharIdx] == '^':
      lineIdxOfSplitter = lineIdx
      break

  # Base case
  # If no splitter hit, then no more timelines, just this one
  if lineIdxOfSplitter < 0:
    cache[rayLineIdx][rayCharIdx] = 1
    return 1

  var timelines: uint64 = 0

  if rayCharIdx - 1 >= 0:
    timelines += countTimelines(lines, lineIdxOfSplitter, rayCharIdx - 1, cache)

  if rayCharIdx + 1 < len(lines[lineIdxOfSplitter]):
    timelines += countTimelines(lines, lineIdxOfSplitter, rayCharIdx + 1, cache)

  cache[rayLineIdx][rayCharIdx] = cast[int64](timelines)
  return timelines

proc main() =
  let originalLines: seq[string] = readLinesStripped()
  var newLines: seq[string] = deepCopy(originalLines)

  # Compute part 1 answer
  # Iterate lines except last one, and update the line below
  var splits: uint32 = 0
  for lineIdx in 0 .. (high(newLines) - 1):
    for charIdx in 0 .. high(newLines[lineIdx]):
      let currChar: char = newLines[lineIdx][charIdx]
      let charBelow: char = newLines[lineIdx + 1][charIdx]

      if currChar != 'S' and currChar != '|':
        continue

      if charBelow != '^':
        newLines[lineIdx + 1][charIdx] = '|'
        continue

      splits += 1

      if charIdx - 1 >= 0:
        newLines[lineIdx + 1][charIdx - 1] = '|'

      if charIdx + 1 < len(newLines[lineIdx + 1]):
        newLines[lineIdx + 1][charIdx + 1] = '|'

  # 1717
  echo(splits)

  # Init timelines cache with -1 for each char (not calculated yet)
  var timelinesCache: seq[seq[int64]] =
    originalLines.mapIt(newSeqWith(len(it), int64(-1)))

  # 231507396180012
  echo(countTimelines(originalLines, 0, originalLines[0].find('S'), timelinesCache))

when isMainModule:
  main()

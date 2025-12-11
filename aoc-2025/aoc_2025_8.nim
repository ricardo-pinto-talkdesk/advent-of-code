# Advent of Code 2025, day 8
# https://adventofcode.com/2025/day/8
# Using Nim 2.2.6
# $ nim compile --run -d:release aoc_2025_8.nim

import std/strutils
import std/sequtils
import std/math
import std/sets
import std/algorithm

const INPUT_PATH = "inputs/aoc_2025_8.txt"
const PART_1_NUM_CONNECTIONS: uint = 1000

type Position = (int64, int64, int64)

# Example "10,20,30"
proc strToPosition(str: string): Position =
  let split: seq[string] = str.split(',')
  return (split[0].parseInt.int64, split[1].parseInt.int64, split[2].parseInt.int64)

proc getCircuitIdx(circuits: seq[HashSet[Position]], pos: Position): int =
  for i in 0 .. high(circuits):
    if pos in circuits[i]:
      return i

  return -1

proc main() =
  let positions: seq[Position] = toSeq(lines(INPUT_PATH)).mapIt(strToPosition(it))

  var distances =
    newSeqOfCap[(Position, Position, float)](len(positions) * len(positions))

  var circuits: seq[HashSet[Position]] = positions.mapIt(toHashSet([it]))

  # Fill distances
  for i in 0 .. high(positions):
    for j in (i + 1) .. high(positions):
      let (pos1, pos2) = (positions[i], positions[j])

      let a: int64 = pos1[0] - pos2[0]
      let b: int64 = pos1[1] - pos2[1]
      let c: int64 = pos1[2] - pos2[2]

      let dist: float = sqrt(float(a * a + b * b + c * c))
      distances.add((pos1, pos2, dist))

  # Sort distances ascending
  distances.sort(
    proc(p1, p2: (Position, Position, float)): int =
      if p1[2] < p2[2]:
        -1
      elif p1[2] > p2[2]:
        1
      else:
        0
  )

  # Part 1
  # Make N connections and build circuits
  for (pos1, pos2, dist) in distances[0 .. PART_1_NUM_CONNECTIONS]:
    let circuitIdx1: int = getCircuitIdx(circuits, pos1)
    let circuitIdx2: int = getCircuitIdx(circuits, pos2)

    assert(circuitIdx1 >= 0 and circuitIdx2 >= 0)

    if circuitIdx1 == circuitIdx2:
      continue

    for pos in circuits[circuitIdx2]:
      circuits[circuitIdx1].incl(pos)

    circuits.delete(circuitIdx2)

  # Sort circuits by length descending
  circuits.sort(
    proc(c1, c2: HashSet[Position]): int =
      if len(c1) > len(c2):
        -1
      elif len(c1) < len(c2):
        1
      else:
        0
  )

  # 140008
  echo(len(circuits[0]) * len(circuits[1]) * len(circuits[2]))

  # Part 2
  # Make connections until just 1 circuit
  for (pos1, pos2, dist) in distances[(PART_1_NUM_CONNECTIONS + 1) .. ^1]:
    let circuitIdx1: int = getCircuitIdx(circuits, pos1)
    let circuitIdx2: int = getCircuitIdx(circuits, pos2)

    assert(circuitIdx1 >= 0 and circuitIdx2 >= 0)

    if circuitIdx1 == circuitIdx2:
      continue

    for pos in circuits[circuitIdx2]:
      circuits[circuitIdx1].incl(pos)

    circuits.delete(circuitIdx2)

    if len(circuits) <= 1:
      # 9253260633
      echo(pos1[0] * pos2[0])
      break

when isMainModule:
  main()

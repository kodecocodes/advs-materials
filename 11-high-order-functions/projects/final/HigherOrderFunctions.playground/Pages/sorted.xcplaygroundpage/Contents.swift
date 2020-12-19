/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2020.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

let words = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]

let stringOrderedWords = words.sorted()
print(stringOrderedWords)

struct Score {
  var wins = 0, draws = 0, losses = 0
  var goalsScored = 0, goalsReceived = 0

  init() {}

  init(goalsScored: Int, goalsReceived: Int) {
    self.goalsScored = goalsScored
    self.goalsReceived = goalsReceived

    if goalsScored == goalsReceived {
      draws = 1
    } else if goalsScored > goalsReceived {
      wins = 1
    } else {
      losses = 1
    }
  }
}

var teamScores = [
  Score(goalsScored: 1, goalsReceived: 0),
  Score(goalsScored: 2, goalsReceived: 1),
  Score(goalsScored: 0, goalsReceived: 0),
  Score(goalsScored: 1, goalsReceived: 3),
  Score(goalsScored: 2, goalsReceived: 2),
  Score(goalsScored: 3, goalsReceived: 0),
  Score(goalsScored: 4, goalsReceived: 3)
]

func areMatchesSorted(first: Score, second: Score) -> Bool {
  if first.wins != second.wins {
    return first.wins > second.wins
  } else if first.draws != second.draws {
    return first.draws > second.draws
  } else {
    let firstDifference = first.goalsScored - first.goalsReceived
    let secondDifference = second.goalsScored - second.goalsReceived

    if firstDifference == secondDifference {
      return first.goalsScored > second.goalsScored
    } else {
      return firstDifference > secondDifference
    }
  }
}

let sortedMatches = teamScores.sorted(by: areMatchesSorted(first:second:))
print(sortedMatches)

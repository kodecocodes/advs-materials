/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2021.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

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

extension Score {
  static func +(left: Score, right: Score) -> Score {
    var newScore = Score()

    newScore.wins = left.wins + right.wins
    newScore.losses = left.losses + right.losses
    newScore.draws = left.draws + right.draws
    newScore.goalsScored = left.goalsScored + right.goalsScored
    newScore.goalsReceived = left.goalsReceived + right.goalsReceived

    return newScore
  }
}

let firstSeasonScores = teamScores.reduce(Score(), +)
print(firstSeasonScores)

var secondSeasonMatches = [
  Score(goalsScored: 5, goalsReceived: 3),
  Score(goalsScored: 1, goalsReceived: 1),
  Score(goalsScored: 0, goalsReceived: 2),
  Score(goalsScored: 2, goalsReceived: 0),
  Score(goalsScored: 2, goalsReceived: 2),
  Score(goalsScored: 3, goalsReceived: 2),
  Score(goalsScored: 2, goalsReceived: 3)
]

let totalScores = secondSeasonMatches.reduce(firstSeasonScores, +)
print(totalScores)

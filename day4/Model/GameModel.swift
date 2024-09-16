//
//  GameModel.swift
//  day4
//
//  Created by Doeun Kwon on 2024-09-15.
//

import UIKit

enum GameStatus {
    case win
    case loss
    case proceed
}

class GameModel {
    
    var isConcealed: Bool = false
    var matchItems = [MatchItem]()
    var prevItem: MatchItem?
    var currentStatus: GameStatus = .proceed
    var currentCount: Int = 0
    var currentStreak: Int = 0
    var bestStreak: Int = 0
    
    private let emojiList: [String] = ["👨🏿‍🚒", "👩🏻‍🌾", "👷🏼‍♀️", "👩🏾‍🔬", "👨🏼‍🏭", "👩🏽‍🎤"]
    private let colorList: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
    
    func generateData() {
        clearState()
        matchItems = []
        isConcealed = false
        for i in 0..<emojiList.count {
            let item1 = MatchItem(emoji: emojiList[i], color: colorList[i].withAlphaComponent(0.4))
            let item2 = MatchItem(emoji: emojiList[i], color: colorList[i].withAlphaComponent(0.4))
            matchItems.append(item1)
            matchItems.append(item2)
        }
        matchItems.shuffle()
    }
    
    func toggleVisibility() {
        clearState()
        if isConcealed {
            /// Reveal actions
            isConcealed = false
            for item in matchItems {
                item.isConcealed = false
            }
        } else {
            /// Conceal actions
            isConcealed = true
            for item in matchItems {
                item.isConcealed = true
            }
        }
    }
    
    func continueGame(_ currentCard: MatchItem) -> GameStatus {
        if let firstCard = prevItem {
            if currentCard.emoji == firstCard.emoji {
                prevItem = nil
                currentCount += 1
                if currentCount == matchItems.count {
                    currentStreak += 1
                    bestStreak = max(bestStreak, currentStreak)
                    currentStatus = .win
                } else {
                    currentStatus = .proceed
                }
            } else {
                currentStreak = 0
                currentStatus = .loss
            }
        } else {
            prevItem = currentCard
            currentCount += 1
            currentStatus = .proceed
        }
        return currentStatus
    }
    
    func clearState() {
        prevItem = nil
        currentStatus = .proceed
        currentCount = 0
    }
    
}

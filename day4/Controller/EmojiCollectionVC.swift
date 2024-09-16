//
//  EmojiCollectionVC.swift
//  day4
//
//  Created by Doeun Kwon on 2024-09-15.
//

import UIKit

protocol EmojiCollectionVCDelegate {
    func changeToRedBackground()
    func changeToGreenBackground()
    func restartGame()
    func hideButton()
}

class EmojiCollectionVC: UICollectionViewController {
    
    let cellPerRow: CGFloat = 3.0
    let lineSpacing: CGFloat = 5.0
    let itemSpacing: CGFloat = 5.0
    
    var gameModel: GameModel?
    
    var delegate: EmojiCollectionVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameModel?.matchItems.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        delegate?.hideButton()
        guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else { fatalError("Could not dequeue EmojiCell") }
        
        guard let gameModel = gameModel else {
            fatalError("gameModel does not exist.")
        }
        
        let matchItem = gameModel.matchItems[indexPath.row]
        
        emojiCell.setBackgroundColor(matchItem.isConcealed ? .myGray : matchItem.color)
        emojiCell.emojiView.text = matchItem.isConcealed ? "❔" : matchItem.emoji
        
        return emojiCell
        
    }
    
    func setGameModel(_ gameModel: GameModel) {
        self.gameModel = gameModel
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
        
        guard let validGameModel = gameModel else { fatalError("Game model does not exist!") }
        
        let selectedItem = validGameModel.matchItems[indexPath.item]
        selectedItem.isConcealed = !selectedItem.isConcealed
        
        let gameStatus = validGameModel.continueGame(selectedItem)
        
        if gameStatus == .loss {
            delegate?.changeToRedBackground()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.delegate?.restartGame()
            }
        } else if gameStatus == .win {
            delegate?.changeToGreenBackground()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.delegate?.restartGame()
            }
        }
        
        collectionView.reloadItems(at: [indexPath])
        
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension EmojiCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width / cellPerRow) - (((itemSpacing * (cellPerRow - 1)) / cellPerRow) + 0.1)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
}

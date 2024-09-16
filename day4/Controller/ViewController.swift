//
//  ViewController.swift
//  day4
//
//  Created by Doeun Kwon on 2024-09-15.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    let gameModel = GameModel()
    
    lazy var startButton: (vc: UIViewController, view: UIView) = {
        let startButtonView = StartButtonView(getAction: setCollectionData)
        let startButtonVC = UIHostingController(rootView: startButtonView)
        startButtonVC.view.backgroundColor = .clear
        let view = startButtonVC.view ?? UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return (vc: startButtonVC, view: view)
    }()
    
    let streakLabel: UILabel = {
        let view = UILabel()
        view.text = Strings.streakCount + "0"
        view.font = UIFont.systemFont(ofSize: 40, weight: .bold).rounded()
        view.textColor = .myGray
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let bestLabel: UILabel = {
        let view = UILabel()
        view.text = Strings.bestCount + "0"
        view.font = UIFont.systemFont(ofSize: 40, weight: .bold).rounded()
        view.textColor = .myGray
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let emojiCollection: (vc: EmojiCollectionVC, view: UICollectionView) = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let vc = EmojiCollectionVC(collectionViewLayout: layout)
        guard let view = vc.collectionView else {
            fatalError("EmojiCollectionVC does not have a property called 'collectionView'.")
        }
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return (vc: vc, view: view)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        let emojiCollectionVC = emojiCollection.vc
        let emojiCollectionView = emojiCollection.view
        emojiCollectionVC.delegate = self
        
        emojiCollectionView.isUserInteractionEnabled = false
        
        let startButtonVC = startButton.vc
        let startButtonView = startButton.view
        
        addChild(emojiCollectionVC)
        emojiCollectionVC.didMove(toParent: self)
        
        addChild(startButtonVC)
        startButtonVC.didMove(toParent: self)
        
        let labelStackView = UIStackView(arrangedSubviews: [bestLabel, streakLabel])
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fillEqually
        labelStackView.alignment = .center
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emojiCollectionView)
        view.addSubview(startButtonView)
        view.addSubview(labelStackView)
        
        
        emojiCollectionVC.setGameModel(gameModel)
        
        /// Set auto layout constraints
        NSLayoutConstraint.activate([
            
            startButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButtonView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            labelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emojiCollectionView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 40),
            emojiCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        
        ])
    }
    
    private func setCollectionData() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
        feedbackGenerator.impactOccurred()
        gameModel.generateData()
        emojiCollection.view.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.flipCards()
        }
    }
    
    private func flipCards() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
        feedbackGenerator.impactOccurred()
        gameModel.toggleVisibility()
        emojiCollection.view.reloadData()
        emojiCollection.view.isUserInteractionEnabled = true
    }
    
    private func updateLabels() {
        streakLabel.text = Strings.streakCount + String(gameModel.currentStreak)
        bestLabel.text = Strings.bestCount + String(gameModel.bestStreak)
    }

}

// MARK: - EmojiCollectionVCDelegate

extension ViewController: EmojiCollectionVCDelegate {
    
    func restartGame() {
        emojiCollection.view.isUserInteractionEnabled = false
        view.backgroundColor = .systemBackground
        gameModel.clearState()
        setCollectionData()
        streakLabel.textColor = .myGray
        bestLabel.textColor = .myGray
    }
    
    func changeToRedBackground() {
        emojiCollection.view.isUserInteractionEnabled = false
        view.backgroundColor = .red.withAlphaComponent(0.3)
        updateLabels()
        streakLabel.textColor = .red
        bestLabel.textColor = .red.withAlphaComponent(0.3)
    }
    
    func changeToGreenBackground() {
        emojiCollection.view.isUserInteractionEnabled = false
        view.backgroundColor = .green.withAlphaComponent(0.3)
        updateLabels()
        streakLabel.textColor = .green
        if gameModel.bestStreak == gameModel.currentStreak {
            bestLabel.textColor = .green
        } else {
            bestLabel.textColor = .green.withAlphaComponent(0.3)
        }
    }
    
    func hideButton() {
        startButton.view.isHidden = true
        streakLabel.isHidden = false
        bestLabel.isHidden = false
    }
}

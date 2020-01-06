//
//  ViewController.swift
//  SudokuSoluver
//
//  Created by Edward O'Neill on 12/16/19.
//  Copyright © 2019 Edward O'Neill. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    var collection = [UICollectionViewCell]()
    var titles = [UITextView]()
    var questionList: [SudokuQA] = []
    var randomQuestion: [SudokuQA] = []
    var cellCount = 1
    var emptySpots = 0
    var row: [Int: Int] = [:]
    var column: [Int: Int] = [:]
    var box: [Int: Int] = [:]
    var currentRowLocation: [Int: Int] = [:]
    var currentColumnLocation: [Int: Int] = [:]
    var rowPossibility: [Int: Set<Int>] = [1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: []]
    var columnPossibility: [Int: Set<Int>] = [1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: []]
    var boxPossibility: [Int: Set<Int>] = [1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: []]
    var numbers = [Int]()
    let numbersToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    var gameTimer: Timer?
    var loopCount = 0
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    let gameButton: UIButton = {
        let frame = CGRect(x: 275, y: 600, width: 100, height: 50)
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.frame = frame
        button.backgroundColor = .green
        button.setTitle("New Game", for: .normal)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        return button
    }()
    
    let solveButton: UIButton = {
        let frame = CGRect(x: 0, y: 600, width: 100, height: 50)
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.frame = frame
        button.backgroundColor = .green
        button.setTitle("Solve Game", for: .normal)
        button.addTarget(self, action: #selector(solveGame), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(gameButton)
        self.view.addSubview(solveButton)
        view.addSubview(collectionView)
        view.backgroundColor = .black
        gameButton.frame = CGRect(x: view.frame.width - 100, y: view.frame.height - 100, width: 100, height: 50)
        solveButton.frame = CGRect(x: 0, y: view.frame.height - 100, width: 100, height: 50)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.widthAnchor, constant: 1).isActive = true
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        loadQuestion()
        setUpChecker()
        setupBoxLocation()
        solveButton.isEnabled = false
    }
    
    func setUpChecker() {
        for num1 in 1...9 {
            for num2 in 1...9 {
                rowPossibility[num1]?.insert(num2)
                columnPossibility[num1]?.insert(num2)
                boxPossibility[num1]?.insert(num2)
            }
        }
    }
    
    func loadQuestion() {
        QuestionAPI.getQuestion { (result) in
            switch result {
            case .failure(let appError):
                fatalError("couldn't load questions: \(appError)")
            case .success(let questions):
                for question in questions {
                    self.questionList.append(question)
                }
            }
        }
    }
    
    @objc func startGame(sender : UIButton) {
        createBoard()
    }
    
    @objc func solveGame(sender : UIButton) {
        loopCount = 0
        removeSeenNumber()
        gameTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(solve), userInfo: nil, repeats: true)
    }
    
    @objc func solve() {
       solveProblem()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.frame.width
        let size = CGSize(width: (viewWidth/9 - 2), height: (viewWidth/9 - 1))
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .white
        collection.append(cell)
        cell.tag = cellCount
        cellCount += 1
        return cell
    }
}

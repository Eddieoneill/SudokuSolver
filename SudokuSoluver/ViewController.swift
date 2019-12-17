//
//  ViewController.swift
//  SudokuSoluver
//
//  Created by Edward O'Neill on 12/16/19.
//  Copyright © 2019 Edward O'Neill. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var collection = [UICollectionViewCell]()
    var questionList: [SudokuQA] = []
    var cellCount = 1
    var numbers = [Int]()
    let numbersToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    
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
    
    let button: UIButton = {
        let frame = CGRect(x: 140, y: 600, width: 100, height: 50)
        let button = UIButton(type: .system)
        button.frame = frame
        button.backgroundColor = .green
        button.setTitle("Create Game", for: .normal)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
        view.addSubview(collectionView)
        view.backgroundColor = .black
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.widthAnchor, constant: 1).isActive = true
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        loadQuestion()
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
        //cellCollection = cellCollection.sorted(by: { $0.tag > $1.tag })
        createBoard()
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

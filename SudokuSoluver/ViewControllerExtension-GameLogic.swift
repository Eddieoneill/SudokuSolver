//
//  ViewControllerExtension:GameLogic.swift
//  SudokuSoluver
//
//  Created by Edward O'Neill on 12/17/19.
//  Copyright © 2019 Edward O'Neill. All rights reserved.
//

import UIKit

extension ViewController {
    func createBoard() {
        if gameButton.titleLabel?.text == "New Game" {
            randomQuestion.append(questionList.randomElement()!)
            setBoard()
            gameButton.setTitle("Reset Game", for: .normal)
        } else if gameButton.titleLabel?.text == "Reset Game" {
            for title in titles {
                title.text = ""
                title.isEditable = true
                title.backgroundColor = .white
                title.textColor = .black
            }
            numbers = []
            titles = []
            randomQuestion.removeAll()
            setUpChecker()
            setupBoxLocation()
            gameButton.setTitle("New Game", for: .normal)
        }
    }
    
    func setBoard() {
        var count = 1
        for question in randomQuestion[0].question {
            for number in question {
                numbers.append(number)
                if number != 0 {
                    currentRowLocation[count] = number
                }
                count += 1
            }
        }
        print("-----------------")
        print(currentRowLocation.sorted(by: { $0.key > $1.key }))
        print("-----------------")
        
        for (index, num) in numbers.enumerated() {
            let title = UITextView(frame: CGRect(x: 0, y: 0, width: collection[index].bounds.size.width, height: collection[index].bounds.size.height))
            numbersToolbar.barStyle = .default
            numbersToolbar.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
            numbersToolbar.sizeToFit()
            title.inputAccessoryView = numbersToolbar
            title.text = "\(num)"
            title.textAlignment = .center
            title.font = UIFont(name: title.font?.fontName ?? "", size: 20)
            title.keyboardType = .numberPad
            title.backgroundColor = .white
            title.textColor = .black
            title.tag = index
            
            if num != 0 {
                title.isEditable = false
                //title.font = .boldSystemFont(ofSize: 24)
                title.backgroundColor = .gray
                title.textColor = .white
            } else {
                self.emptySpots += 1
                title.text = ""
            }
            self.titles.append(title)
            collection[index].contentView.addSubview(title)
        }
    }
    
    @objc func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    
    func options(row: Set<Int>, column: Set<Int>, box: Set<Int>) -> Set<Int> {
        var result: Set<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        for num in 1...9 {
            if !row.contains(num) || !column.contains(num) || !box.contains(num) {
                result.remove(num)
            }
        }
        return result
    }
    
    func setupBox(count: Int, number: Int, num: Int) {
        if num <= 2 {
            box[count] = 1 + number
        } else if num <= 5 {
            box[count] = 2 + number
        } else {
            box[count] = 3 + number
        }
    }
    func setupBoxLocation() {
        var count = 0
        
        for num in 1...81 {
            if num % 9 != 0 {
                column[num] = num % 9
            } else {
                column[num] = 9
            }
        }
        
        for num1 in 0..<9 {
            for num2 in 0..<9 {
                count += 1
                row[count] = num1 + 1
                if num1 <= 2 {
                    setupBox(count: count, number: 0, num: num2)
                } else if num1 <= 5 {
                    setupBox(count: count, number: 3, num: num2)
                } else {
                    setupBox(count: count, number: 6, num: num2)
                }
            }
        }
    }
    
    func checkPossibility(location: [Int: Int], current: Int) -> Int? {
        return location[current]
    }
    
    func removeSeenNumber() {
        var count = 0
        
        for num1 in 0..<9 {
            for num2 in 0..<9 {
                count += 1
                let number = randomQuestion[0].question[num1][num2]
                guard let boxLocation = checkPossibility(location: box, current: count) else { break }
                guard let rowLocation = checkPossibility(location: row, current: count) else { break }
                guard let columnLocation = checkPossibility(location: column, current: count) else { break }
                
                if number != 0 {
                    if rowPossibility[rowLocation]!.contains(number) {
                        rowPossibility[rowLocation]?.remove(number)
                    }
                    if columnPossibility[columnLocation]!.contains(number) {
                        columnPossibility[columnLocation]?.remove(number)
                    }
                    if boxPossibility[boxLocation]!.contains(number) {
                        boxPossibility[boxLocation]?.remove(number)
                    }
                }
            }
        }
    }
        
    func solveProblem() {
        var loopCount = 0
        let numberList: Set<String> = ["1","2","3","4","5","6","7","8","9"]
        
        removeSeenNumber()
        
        while emptySpots > 0 {
            for (index, number) in titles.enumerated() where !numberList.contains(number.text) {
                let current = index + 1
                guard let boxLocation = checkPossibility(location: box, current: current) else { break }
                guard let rowLocation = checkPossibility(location: row, current: current) else { break }
                guard let columnLocation = checkPossibility(location: column, current: current) else { break }
                var possibleNumber = options(row: rowPossibility[rowLocation]!, column: columnPossibility[columnLocation]!, box: boxPossibility[boxLocation]!)
//                print("==============")
//                print(current)
//                print(possibleNumber.sorted(by: { $0 > $1 }))
                
                if possibleNumber.count == 1 {
                    let removedNumber = possibleNumber.removeFirst()
                    number.text = "\(removedNumber)"
                    number.textColor = .black
                    number.isEditable = false
                    loopCount = 0
                    emptySpots -= 1
                    print(emptySpots)
                    rowPossibility[rowLocation]?.remove(removedNumber)
                    columnPossibility[columnLocation]?.remove(removedNumber)
                    boxPossibility[boxLocation]?.remove(removedNumber)
                    print("\(titles.count)")
                    break
                } else {
                    loopCount += 1
                }
            }
            if loopCount > 81 {
                print("couldn't complete it")
                return
            }
        }
        print("completed it")
        return
    }
}





/*
 [[0, 0, 4, 3, 0, 0, 2, 0, 9],
 [0, 0, 5, 0, 0, 9, 0, 0, 1],
 [0, 7, 0, 0, 6, 0, 0, 4, 3],
 [0, 0, 6, 0, 0, 2, 0, 8, 7],
 [1, 9, 0, 0, 0, 7, 4, 0, 0],
 [0, 5, 0, 0, 8, 3, 0, 0, 0],
 [6, 0, 0, 0, 0, 0, 1, 0, 5],
 [0, 0, 3, 5, 0, 8, 6, 9, 0],
 [0, 4, 2, 9, 1, 0, 3, 0, 0]]
 
 8  6  4  3  7  1  2  5  9
 3  2  5  8  4  9  7  6  1
 9  7  1  2  6  5  8  4  3
 4  3  6  1  9  2  5  8  7
 1  9  8  6  5  7  4  3  2
 2  5  7  4  8  3  9  1  6
 6  8  9  7  3  4  1  2  5
 7  1  3  5  2  8  6  9  4
 5  4  2  9  1  6  3  7  8"
 */

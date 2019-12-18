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
        if gameButton.titleLabel?.text == "Create Game" {
            for question in questionList[0].question {
                for number in question {
                    numbers.append(number)
                }
            }
            
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
                } else {
                    self.emptySpots += 1
                    title.text = ""
                }
                self.titles.append(title)
                collection[index].contentView.addSubview(title)
            }
            gameButton.setTitle("Reset Game", for: .normal)
        } else if gameButton.titleLabel?.text == "Reset Game" {
            for title in titles {
                title.text = ""
            }
            gameButton.setTitle("New Game", for: .normal)
        } else {
            for (index, num) in numbers.enumerated() {
                if num != 0 {
                    titles[index].text = "\(num)"
                    titles[index].isEditable = false
                } else {
                    titles[index].text = " "
                }
            }
            gameButton.setTitle("Reset Game", for: .normal)
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
    
    func setupBoxLocation() {
        var count = 0
        for num1 in 0..<9 {
            for num2 in 0..<9 {
                count += 1
                if num1 <= 2 {
                    if num2 <= 2 {
                        box[count] = 1
                        row[count] = 1
                        column[count] = 1
                    } else if num2 <= 5 {
                        box[count] = 2
                        row[count] = 2
                        column[count] = 2
                    } else {
                        box[count] = 3
                        row[count] = 3
                        column[count] = 3
                    }
                } else if num1 <= 5 {
                    if num2 <= 2 {
                        box[count] = 4
                        row[count] = 4
                        column[count] = 4
                    } else if num2 <= 5 {
                        box[count] = 5
                        row[count] = 5
                        column[count] = 5
                    } else {
                        box[count] = 6
                        row[count] = 6
                        column[count] = 6
                    }
                } else {
                    if num2 <= 2 {
                        box[count] = 7
                        row[count] = 7
                        column[count] = 7
                    } else if num2 <= 5 {
                        box[count] = 8
                        row[count] = 8
                        column[count] = 8
                    } else {
                        box[count] = 9
                        row[count] = 9
                        column[count] = 9
                    }
                }
            }
        }
    }
    
    func checkPossibility(location: [Int: Int], current: Int) -> Int {
        return location[current] ?? 0
    }
    
    func solveProblem() -> Bool {
        var loopCount = 0
        let numberList: Set<String> = ["1","2","3","4","5","6","7","8","9"]
        while emptySpots >= 0 {
            for (index, number) in titles.enumerated() where !numberList.contains(number.text) {
                let current = index + 1
                let boxLocation = checkPossibility(location: box, current: current)
                let rowLocation = checkPossibility(location: row, current: current)
                let columnLocation = checkPossibility(location: column, current: current)
                var possibleNumber = options(row: rowPossibility[rowLocation]!, column: columnPossibility[columnLocation]!, box: boxPossibility[boxLocation]!)
                print("==============")
                print(current)
                print(possibleNumber.sorted(by: { $0 > $1 }))
                if possibleNumber.count == 1 {
                    number.text = "\(possibleNumber.removeFirst())"
                    loopCount = 0
                    break
                } else {
                    loopCount += 1
                }
            }
//            if loopCount > 81 {
//                return false
//            }
        }
        return true
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
 */

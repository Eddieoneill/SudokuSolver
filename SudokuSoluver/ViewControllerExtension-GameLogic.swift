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
        
        if button.titleLabel?.text == "Create Game" {
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
                
                if num != 0 {
                    title.text = "\(num)"
                    title.isEditable = false
                } else {
                    title.text = " "
                }
                title.textAlignment = .center
                title.font = UIFont(name: title.font!.fontName, size: 20)
                title.keyboardType = .numberPad
                title.backgroundColor = .white
                title.textColor = .black
                collection[index].contentView.addSubview(title)
            }
            
            button.setTitle("Next Game", for: .normal)
        }
    }
    
    @objc func doneWithNumberPad() {
        self.view.endEditing(true)
    }
}

extension UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let text = textField.text {
//            if text.count > 1 {
//                textField.endEditing(true)
//            }
//        }
//        print("hi")
//        return true
//    }
    
    
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

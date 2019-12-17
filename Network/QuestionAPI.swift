//
//  QuestionSearch.swift
//  SudokuSoluver
//
//  Created by Edward O'Neill on 12/16/19.
//  Copyright © 2019 Edward O'Neill. All rights reserved.
//

import Foundation

struct QuestionAPI {
    
    static func getQuestion(completion: @escaping (Result<[SudokuQA], AppError>) -> ()) {
        let urlString = "https://5df7a4364fdcb20014a482c7.mockapi.io/question"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL(urlString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                print(appError)
            case .success(let data):
                do {
                    let question = try JSONDecoder().decode([SudokuQA].self, from: data)
                    completion(.success(question))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
}

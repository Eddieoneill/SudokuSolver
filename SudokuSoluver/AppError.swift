//
//  AppError.swift
//  SudokuSoluver
//
//  Created by Edward O'Neill on 12/16/19.
//  Copyright © 2019 Edward O'Neill. All rights reserved.
//

import Foundation

enum AppError: Error {
  case badURL(String)
  case noResponse
  case networkClientError(Error)
  case noData
  case decodingError(Error)
  case badStatusCode(Int)
  case badMimeType(String)
}

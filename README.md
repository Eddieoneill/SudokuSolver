# SudokuSolver

## Description

- This app is a app that allows the user to play Sudoku and provides the answer if they request. The main focus of this project was the question solving algorithem.
- This app will load the question from the API and solve it with the logic I wrote

![SutokeSolverGIF](https://user-images.githubusercontent.com/42211866/71908641-66c1d800-313c-11ea-9635-6ed47a8a263a.gif)

## Challenges

The logic to figure out the actual possible number option was challenging since I needed to track the possible number for the row, column and the box for each location and filter it down.

```swift
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
```

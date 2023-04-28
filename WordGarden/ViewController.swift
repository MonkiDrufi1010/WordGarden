//
//  ViewController.swift
//  WordGarden
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wordsGuessedLabel: UILabel!
    
    @IBOutlet weak var wordsMissedLabel: UILabel!
    
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    
    @IBOutlet weak var wordsInGameLabel: UILabel!
    
    
    
    @IBOutlet weak var wordBeginRevealedLabel: UILabel!
    
    @IBOutlet weak var guessLetterField: UITextField!
    
    @IBOutlet weak var guessLetterButton: UIButton!
    
    @IBOutlet weak var gameStatusMessageLabel: UILabel!
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet weak var flowerImageView: UIImageView!
    
    var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    var currentWordIndex = 0
    var wordToGuess = ""
    var lettersGuessed = ""
    
    let maxNumberOfWrongGuess = 8  //最多猜的次數
    var wrongGuessesRemaining = 8  //猜錯多少次
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = guessLetterField.text!
        print(!(text.isEmpty)) //false
        guessLetterButton.isEnabled = !(text.isEmpty)
        wordToGuess = wordsToGuess[currentWordIndex]
        wordBeginRevealedLabel.text = String(repeating: " _", count: wordToGuess.count)
        
    }
    
    // Editing Changed
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        sender.text = String(sender.text?.last ?? " ").trimmingCharacters(in: .whitespaces)
        guessLetterButton.isEnabled = !(sender.text!.isEmpty)
        
//        var text = sender.text!
//        text = String(text.last ?? " ").trimmingCharacters(in: .whitespaces)
//        sender.text = text
//        guessLetterButton.isEnabled = !(text.isEmpty)
        
    }
    // 按下  textFile 收回鍵盤 並且 btn 不能按
    func updateUIAfterGuess() {
        guessLetterField.resignFirstResponder()
        // 因為textField 是一個可選的值 所以要！
        guessLetterField.text! = ""
        guessLetterButton.isEnabled = false
        
    }
      // 格式顯示字
    func formatRevealedWord() {
        var revealedWord = ""

        for letter in wordToGuess {
            if lettersGuessed.contains(letter) {
                revealedWord = revealedWord + "\(letter) "
                print("印出第一個:\(letter)")
            }else {
                revealedWord = revealedWord + "_ "
            }
        }
        print("RevealedWord: \(revealedWord)")
        revealedWord.removeLast()
        
        wordBeginRevealedLabel.text = revealedWord
        print("WordToGuess: \(wordToGuess)")

        print("LettersGuessed: \(lettersGuessed)")

        print("RevealedWord: \(revealedWord)")
        
        
    }
    
    //偵測 textField 輸入的數字
    func guessALatter() {
        let currentLetterGuessed = guessLetterField.text ?? ""
        lettersGuessed = lettersGuessed + currentLetterGuessed
        
        //
//        var revealedWord = ""
//
//        for letter in wordToGuess {
//            if lettersGuessed.contains(letter) {
//                revealedWord = revealedWord + "\(letter) "
//                print("印出第一個:\(letter)")
//            }else {
//                revealedWord = revealedWord + "_ "
//            }
//        }
//        print("RevealedWord: \(revealedWord)")
//        revealedWord.removeLast()
//
//        wordBeginRevealedLabel.text = revealedWord
//        print("WordToGuess: \(wordToGuess)")
//
//        print("LettersGuessed: \(lettersGuessed)")
//
//        print("RevealedWord: \(revealedWord)")
        formatRevealedWord()
        // 判斷如果猜錯
        if !wordsToGuess.contains(currentLetterGuessed) {
            wrongGuessesRemaining = wrongGuessesRemaining - 1
            flowerImageView.image = UIImage(named: "flower\(wrongGuessesRemaining)")
            
        }
        
        
    }
    // Primary Action Triggered
    @IBAction func donkeyPressed(_ sender: UITextField) {
        guessALatter()
        updateUIAfterGuess()
        
    }
    @IBAction func guseeLetterButtonPressed(_ sender: UIButton) {
        guessALatter()
        updateUIAfterGuess()
        
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
    }
    
    

}


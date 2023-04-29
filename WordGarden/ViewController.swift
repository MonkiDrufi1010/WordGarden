//
//  ViewController.swift
//  WordGarden
//

import UIKit
import AVFoundation

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
    
    let maxNumberOfWrongGuess = 8  //最多猜錯的次數
    var wrongGuessesRemaining = 8  //猜錯多少次
    
    //上面四個的計分欄
    var wordsGuessedCount = 0
    var wordsMissedCount = 0
    var guessCount = 0
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = guessLetterField.text!
        print(!(text.isEmpty)) //false
        guessLetterButton.isEnabled = !(text.isEmpty)
        wordToGuess = wordsToGuess[currentWordIndex]
        wordBeginRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        
        upDateGameStatusLabels()
    }
    
    // 播放音效
    func playSound(name: String) {
        if let sound = NSDataAsset(name: name) {
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print(error.localizedDescription)
            }
        }else {
            print("error: no data\(name)")
        }
    }
    
    // Editing Changed 進入textFile 編輯會觸發這個func
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        sender.text = String(sender.text?.last ?? " ").trimmingCharacters(in: .whitespaces).uppercased()
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
    func upDateAfterWinOrLose() {
        //
        currentWordIndex += 1
        guessLetterField.isEnabled = false
        guessLetterButton.isEnabled = false
//        playAgainButton.isHidden = false
        
        //
        upDateGameStatusLabels()
        
    }
    func upDateGameStatusLabels() {
        //
        wordsGuessedLabel.text = "Words Guessed: \(wordsGuessedCount)"
        wordsMissedLabel.text = "Words Missed: \(wordsMissedCount)"
        wordsRemainingLabel.text = "Words to Guess: \(wordsToGuess.count - (wordsGuessedCount + wordsMissedCount))"
        wordsInGameLabel.text = "Words In Game: \(wordsToGuess.count)"
    }
    
    func drawFlowerAndPlaySound(currentLetterGuessed: String) {
        if !wordToGuess.contains(currentLetterGuessed) {
            wrongGuessesRemaining = wrongGuessesRemaining - 1
//            flowerImageView.image = UIImage(named: "flower\(wrongGuessesRemaining)")  宜到下面的closure
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                UIView.transition(with: self.flowerImageView,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {self.flowerImageView.image = UIImage(named: "wilt\(self.wrongGuessesRemaining)")})
                { (_) in
                    self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")
                    
                }
                
                self.playSound(name: "incorrect")
            })
//            //落葉動畫
//            UIView.transition(with: flowerImageView,
//                              duration: 0.5,
//                              options: .transitionCrossDissolve,
//                              animations: {self.flowerImageView.image = UIImage(named: "wilt\(self.wrongGuessesRemaining)")})
//            { (_) in
//                self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")
//
//            }
            
            playSound(name: "incorrect")
        } else {
            playSound(name: "correct")
        }
    }
    
    
    //偵測 textField 輸入的數字
    func guessALatter() {
        let currentLetterGuessed = guessLetterField.text?.uppercased() ?? ""
        lettersGuessed = lettersGuessed + currentLetterGuessed
        
    

        formatRevealedWord()
        drawFlowerAndPlaySound(currentLetterGuessed: currentLetterGuessed)
        //下面copy 到 drawFLower
//        // 判斷如果猜錯 圖片顯示落葉
//        if !wordToGuess.contains(currentLetterGuessed) {
//            wrongGuessesRemaining = wrongGuessesRemaining - 1
//            flowerImageView.image = UIImage(named: "flower\(wrongGuessesRemaining)")
//            playSound(name: "incorrect")
//        } else {
//            playSound(name: "correct")
//        }
        // 更新顯示欄位
        guessCount += 1
        // 居然連英文單字 單複數都考慮進去
        
//        var guesses = "Geesses"
//        if guessCount == 1 {
//            guesses = "Guess"
//        }
        // 上面改寫成一行 三元運算式
        let guesses = (guessCount == 1 ? "Guess" : "Guesses")
        gameStatusMessageLabel.text = "You've Made \(guessCount) \(guesses)."
        
        //顯示訊息 猜錯 猜對
        if wordBeginRevealedLabel.text?.contains("_") == false {
            gameStatusMessageLabel.text = "You've guessd it! It took \(guessCount) guesses to guess the word. "
            wordsGuessedCount += 1
            playSound(name: "word-guessed")
            upDateAfterWinOrLose()
        }else if wrongGuessesRemaining == 0 {
            gameStatusMessageLabel.text = "So Sorry, You've all out of guesses. "
            wordsMissedCount += 1
            playSound(name: "word-not-guessed")
            upDateAfterWinOrLose()
        }
        
        // 顯示 三個次輪流輪完了
        if currentWordIndex == wordsToGuess.count {
            gameStatusMessageLabel.text! += "\n\nYou've tried all of the words! Restart from the begining"
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
        if currentWordIndex == wordToGuess.count {
            currentWordIndex = 0
            wordsGuessedCount = 0
            wordsMissedCount = 0
        }
        
        // 目前還不知道
        playAgainButton.isHidden = true
        guessLetterField.isEnabled = true
        guessLetterButton.isEnabled = false
        
        wordToGuess = wordsToGuess[currentWordIndex]

        wrongGuessesRemaining = maxNumberOfWrongGuess
        
        wordBeginRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        
        guessCount = 0
        
        flowerImageView.image = UIImage(named: "flower\(maxNumberOfWrongGuess)")
        lettersGuessed = ""
        upDateGameStatusLabels()
        gameStatusMessageLabel.text = "You've Made Zero Guesses."
        
    }
    
    

}


import UIKit



class ViewController: UIViewController {
    
    var totalLifesPlayer1 = 3{
        didSet {
            imgLifeSpanPlayer1.image = UIImage(named: "lifes\(totalLifesPlayer1)")
        }
    }
    
    var totalLifesPlayer2 = 3{
        didSet {
            imgLifeSpanPlayer2.image = UIImage(named: "lifes\(totalLifesPlayer2)")
        }
    }
    
    
    
    var scorePlayer1 = 0
    var perTurnLifesPLayer1 = 6
    
    var scorePlayer2 = 0
    var perTurnLifesPLayer2 = 6
    
    var isCompleteGame = false
    var chosen5CharWord = "";
    var chosen6CharWord = "";
    var chosen7CharWord = "";
    var globalChosenWord = "";
    
    @IBOutlet weak var hangmanImageView: UIImageView!
    
    @IBOutlet weak var btnStartGame: UIButton!
    
    
    
    
    @IBOutlet weak var imgLifeSpanPlayer1: UIImageView!
    @IBOutlet weak var imgLifeSpanPlayer2: UIImageView!
    
    
    @IBOutlet weak var lblPlayer1: UILabel!
    @IBOutlet weak var lblPlayer2: UILabel!
    
    
    @IBOutlet weak var labelWord: UILabel!
    
    //Buttons array
    @IBOutlet var letterButton: [UIButton]!
    @IBOutlet weak var underscoreBaseLabel: UILabel!
    
    var word = ""
    var wordInArray = [String]()

    var hiddenWord = ""
    var hiddenWordInArray = [String]()

    var wordStrings = [String]()
    var usedLetters = ""

    var level = 0
    
    var currentPlayerFlag = 0
    
    var isPlayer2Flag = false
    
    
    @IBAction func onGenerate(_ sender: Any) {
        enableButtons()
        generateRandomWord()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableButtons()
        //hideAllImages()
        // Do any additional setup after loading the view.
    }
        
    
        
        let wordList1 = ["actor", "album", "beach", "brain", "phone"];
        let wordList2 = ["camera", "bottle", "coffee", "church", "yellow"];
        let wordList3 = ["academy", "vehicle", "virtual", "formula", "account"];
        
    
    var hangmanImgNumber = 0 {
        didSet {
            hangmanImageView.image = UIImage(named: "hangman\(hangmanImgNumber)")
        }
    }
        
    
    func generateRandomWord(){
        validateUser()
        currentPlayerFlag += 1
        
        btnStartGame.isHidden = true;
        let randomList = "wordList\(arc4random_uniform(3)+1)"
        let randomWordIndex = Int((arc4random_uniform(5)));
        
        switch randomList{
        case "wordList1":
            chosen5CharWord = wordList1[randomWordIndex];
            labelWord.text = chosen5CharWord;
            setWordInTextfields(generatedWord: chosen5CharWord)
        case "wordList2":
            chosen6CharWord = wordList2[randomWordIndex];
            labelWord.text = chosen6CharWord;
            setWordInTextfields(generatedWord: chosen6CharWord)
        case "wordList3":
            chosen7CharWord = wordList3[randomWordIndex ];
            labelWord.text = chosen7CharWord;
            setWordInTextfields(generatedWord: chosen7CharWord)
        default: break
            
        }
        
        
    }
    
    func isPlayer2()-> Bool{
        currentPlayerFlag % 2 == 0 ? false : true
    }
    
    func validateUser(){
        if(isPlayer2()){
            isPlayer2Flag = true
            lblPlayer1.font = UIFont.systemFont(ofSize: 24, weight: .regular)
            lblPlayer2.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            
        }else{
            isPlayer2Flag = false
            lblPlayer2.font = UIFont.systemFont(ofSize: 24, weight: .regular)
            lblPlayer1.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        }
    }
    
        
    func disableButtons(){
        for button in letterButton {
            button.isHidden = true
        }
    }
    
    func enableButtons(){
        for button in letterButton {
            button.isHidden = false
        }
    }
    
    
    func setWordInTextfields(generatedWord: String){
        checkIfGameIsCompleted()
        wordInArray = [String]()
        word = ""
        hiddenWord = ""
        hiddenWordInArray = [String]()
        
        perTurnLifesPLayer1 = 6
        hangmanImgNumber = 0
        
        //  Save word into an array + string
        globalChosenWord = generatedWord;
        word = generatedWord
        
        
        for letter in generatedWord {
            wordInArray.append(String(letter))
        }
        
        print(generatedWord)
        //print(word)
        print(wordInArray)
        for _ in 0..<wordInArray.count {
            hiddenWord += "?"
            hiddenWordInArray.append("?")
        }
        
        labelWord.text = hiddenWord
        labelWord.typingTextAnimation(text: hiddenWord, timeInterval: 0.2)
        
    }
    
    
    
    
    @IBAction func letterTapped(_ sender: UIButton) {
        //print(sender.title(for: .normal))
        guard let letterChosen = sender.currentTitle?.lowercased() else { return }
        
        usedLetters.append(letterChosen)
        
        if wordInArray.contains(letterChosen) {
            
            for (index, letter) in wordInArray.enumerated() {
                if letterChosen == letter {
                    hiddenWordInArray[index] = letter
                }
            }
            
            hiddenWord = hiddenWordInArray.joined()
            
            
        } else {
            hangmanImgNumber += 1
            perTurnLifesPLayer1 -= 1
            
        }
        
        labelWord.text = hiddenWord
        checkIfTurnIsCompleted(generatedWord: globalChosenWord)
        
        
        
        
        //setLifesIcons()
    }
    
    
    
    
    
        
    func checkIfTurnIsCompleted(generatedWord: String){
        print(perTurnLifesPLayer1)
        if perTurnLifesPLayer1 > 0 {
            if hiddenWord == generatedWord {
                if isPlayer2Flag{
                    scorePlayer2 += 1
                    //score == 3 || totalLifes == score
                    if(scorePlayer2 == 3 && totalLifesPlayer2 > 0){
                        checkIfGameIsCompleted()
                    }else{
                        displayAlertMessage(title: "Player 2 win the round🎉", alertDescription: "Hangman is happy", alertStyle: alertType.Winner.rawValue)
                        generateRandomWord()
                    }
                }else{
                    scorePlayer1 += 1
                    //score == 3 || totalLifes == score
                    if(scorePlayer1 == 3 && totalLifesPlayer1 > 0){
                        checkIfGameIsCompleted()
                    }else{
                        displayAlertMessage(title: "Player 1 win the round🎉", alertDescription: "Hangman is happy", alertStyle: alertType.Winner.rawValue)
                        generateRandomWord()
                    }
                }
                
                
            }
            
        } else {
            
            if isPlayer2Flag{
                //score -= 1
                totalLifesPlayer2 -= 1
                if(totalLifesPlayer2 == 0){
                    checkIfGameIsCompleted()
                }else{
                    displayAlertMessage(title: "Player 2 loose the round💀", alertDescription: "You hanged the character... the answer was \"\(generatedWord.uppercased())\"!", alertStyle: alertType.Looser.rawValue)
                    generateRandomWord()
                }
            }else{
                
                //score -= 1
                totalLifesPlayer1 -= 1
                if(totalLifesPlayer1 == 0){
                    checkIfGameIsCompleted()
                }else{
                    displayAlertMessage(title: "Player 1 loose the round💀", alertDescription: "You hanged the character... the answer was \"\(generatedWord.uppercased())\"!", alertStyle: alertType.Looser.rawValue)
                    generateRandomWord()
                }
                    
                }
        }
            
        }
    
    
    
    
    func checkIfGameIsCompleted(){
        print("totalLifes1", totalLifesPlayer1)
        print("score1", scorePlayer1)
        
        
        print("totalLifes2", totalLifesPlayer2)
        print("score2", scorePlayer2)
        if isPlayer2Flag{
            if totalLifesPlayer2 > 0 && scorePlayer2==3{
                isCompleteGame = true
                displayAlertMessage(title: "Player 2 is winner 🚀", alertDescription: "Hangman is happy", alertStyle: alertType.Winner.rawValue)
                restartGame()
            }else if totalLifesPlayer2 == 0 && scorePlayer2 == 0{
                displayAlertMessage(title: "Player 2 loose game 💤", alertDescription: "Player 1 is winner", alertStyle: alertType.Looser.rawValue)
                restartGame()
            }
        }else{
            if totalLifesPlayer1 > 0 && scorePlayer1==3{
                isCompleteGame = true
                displayAlertMessage(title: "Player 1 is winner 🚀", alertDescription: "Hangman is happy", alertStyle: alertType.Winner.rawValue)
                restartGame()
            }else if totalLifesPlayer1 == 0 && scorePlayer1 == 0{
                displayAlertMessage(title: "Player 1 loose game 💤", alertDescription: "Player 2 is winner", alertStyle: alertType.Looser.rawValue)
                restartGame()
            }
        }
        
        
    }
    

    
    
    
    enum alertType: String{
        case Looser = "L"
        case Winner = "W"
    }
    
    
    
    func displayAlertMessage(title: String, alertDescription: String, alertStyle: String){
        let alert = UIAlertController(title: title, message: alertDescription, preferredStyle: UIAlertController.Style.alert);
        
        switch alertStyle{
        case alertType.Looser.rawValue:
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case alertType.Winner.rawValue:
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default:
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    func restartGame(){
        disableButtons()
        
        currentPlayerFlag = 0
        isPlayer2Flag = false
        
        labelWord.text = ""
        totalLifesPlayer1 = 3
        scorePlayer1 = 0
        perTurnLifesPLayer1 = 6
        
        totalLifesPlayer2 = 3
        scorePlayer2 = 0
        perTurnLifesPLayer2 = 6
        btnStartGame.isHidden = false
        
        lblPlayer1.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        lblPlayer2.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        
    }




}


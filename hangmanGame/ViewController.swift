import UIKit



class ViewController: UIViewController {
    
    var totalLifes = 3{
        didSet {
            imgLifeSpan.image = UIImage(named: "lifes\(totalLifes)")
        }
    }
    
    var score = 0
    var perTurnLifes = 6
    
    var isCompleteGame = false
    var chosen5CharWord = "";
    var chosen6CharWord = "";
    var chosen7CharWord = "";
    var globalChosenWord = "";
    
    @IBOutlet weak var hangmanImageView: UIImageView!
    
    @IBOutlet weak var btnStartGame: UIButton!
    
    @IBOutlet weak var imgLifeSpan: UIImageView!
    
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
        
        perTurnLifes = 6
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
            perTurnLifes -= 1
            
        }
        
        labelWord.text = hiddenWord
        checkIfTurnIsCompleted(generatedWord: globalChosenWord)
        
        
        
        
        //setLifesIcons()
    }
    
    
    
    
    
        
    func checkIfTurnIsCompleted(generatedWord: String){
        print(perTurnLifes)
        if perTurnLifes > 0 {
            if hiddenWord == generatedWord {
                score += 1
                //score == 3 || totalLifes == score
                if(score == 3 && totalLifes > 0){
                    checkIfGameIsCompleted()
                }else{
                    displayAlertMessage(title: "You win the round🎉", alertDescription: "Hangman is happy", alertStyle: alertType.Winner.rawValue)
                    generateRandomWord()
                }
            }
            
        } else {
            
            
            //score -= 1
            totalLifes -= 1
            if(totalLifes == 0){
                checkIfGameIsCompleted()
            }else{
                displayAlertMessage(title: "You loose the round💀", alertDescription: "You hanged the character... the answer was \"\(generatedWord.uppercased())\"!", alertStyle: alertType.Looser.rawValue)
                generateRandomWord()
            }
            
        }
        
    }
    
    
    
    
    func checkIfGameIsCompleted(){
        print("totalLifes", totalLifes)
        print("score", score)
        
        if totalLifes > 0 && score==3{
            isCompleteGame = true
            displayAlertMessage(title: "You Win 🚀", alertDescription: "Hangman is happy", alertStyle: alertType.Winner.rawValue)
            restartGame()
        }else if totalLifes == 0 && score == 0{
            displayAlertMessage(title: "Game Over 💤", alertDescription: "Hangman is sad", alertStyle: alertType.Looser.rawValue)
            restartGame()
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
        labelWord.text = ""
        totalLifes = 3
        score = 0
        perTurnLifes = 6
        btnStartGame.isHidden = false
    }


}


import UIKit

class MainViewController: UIViewController, TicTacToeDelegate {

    
    @IBOutlet private weak var bottomLabel: UILabel!
    @IBOutlet var allButtons: [GameButton]!
    
    @IBOutlet var xScore: UILabel!
    @IBOutlet var oScore: UILabel!
    private var game: TicTacToe!
    private var selectedButton: GameButton!
    private var isEnd: Bool = false
    private var xWins: Int = 0
    private var oWins: Int = 0
    private var currentPlayer: String {
        return "\(game.player.name) turn"
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = TicTacToe()
        game.delegate = self
        setUpViews()
        setupSwipeGestures()
        restoreState()
    }
    
    func restoreState() {
        xWins = LocalStorage.value(defaultValue: 0, forKey: LocalStorage.X_SCORE)
        oWins = LocalStorage.value(defaultValue: 0, forKey: LocalStorage.O_SCORE)
//        let oldGame = LocalStorage.value(defaultValue: "", forKey: LocalStorage.GAME)
//        print("Game", oldGame)
//        var i = 0
//        var j = 0
//        var count = 0
//        for char in oldGame {
//            if(char == "X" || char == "O") {
//                allButtons[count].isEnabled = false
//                let player = game.getPlayer(player: char)
//                allButtons[count].setTitle(player.rawValue, for: .normal)
//                allButtons[count].setTitleColor(player.color, for: .disabled)
//                game.player(didChoose: (i, j))
//            }
//            count += 1
//            j += 1
//            if(j%3 == 0) {
//                j = 0
//                i += 1
//            }
//        }
        printScore()
    }
    
    
    func setupSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func swiped(gesture: UISwipeGestureRecognizer) {
        let swipeGesture = gesture as UISwipeGestureRecognizer
        switch swipeGesture.direction {
        case UISwipeGestureRecognizer.Direction.left, UISwipeGestureRecognizer.Direction.right:
            game.reset()
            setUpViews()
        default:
            break
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEvent.EventSubtype.motionShake {
            if(!isEnd) {
                undo()
            }
        }
    }
    
    func undo() {
        if(selectedButton != nil) {
            game.undoMove(didChoose: (selectedButton.row, selectedButton.column))
            selectedButton.isEnabled = true
            selectedButton.setTitle("", for: .normal)
            selectedButton = nil
        }
    }

    
    @IBAction func pressGameButton(sender button: GameButton) {
        selectedButton = button
        button.isEnabled = false
        button.setTitle(game.player.rawValue, for: .normal)
        button.setTitleColor(game.player.color, for: .disabled)
        game.player(didChoose: (button.row, button.column))
    }

    
    private func setUpViews() {
        isEnd = false
        allButtons.forEach{
            $0.isEnabled = true
            $0.setTitleColor(.black, for: .disabled)
            $0.setTitle("", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 90)
        }
        bottomLabel.text = currentPlayer
//        saveState()
    }

    
    func continues(with nextPlayer: TicTacToe.Player) {
        bottomLabel.text = currentPlayer
        saveState()
    }
    
    func saveState() {
        LocalStorage.value(value: xWins, forKey: LocalStorage.X_SCORE)
        LocalStorage.value(value: oWins, forKey: LocalStorage.O_SCORE)
        var board = ""
        for players in game.board {
            for player in players {
                if(player == .X) {
                    board = board + "X"
                } else if (player == .O) {
                    board = board + "O"
                } else {
                    board = board + " "
                }
            }
        }
        LocalStorage.value(value: board, forKey: LocalStorage.GAME)
    }

    func over(winner: TicTacToe.Player?) {
        isEnd = true
        allButtons.forEach { $0.isEnabled = false }
        if let winner = winner {
            bottomLabel.text = "\(winner.name.capitalized) WIN!"
            if(game.isXTurn()) {
                xWins += 1
            } else {
                oWins += 1
            }
            printScore()
        } else {
            bottomLabel.text = "DRAW!"
        }
        saveState()
    }
    
    func printScore() {
        xScore.text = "\(xWins)"
        oScore.text = "\(oWins)"
    }
}

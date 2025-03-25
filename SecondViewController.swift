//
//  SecondViewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/03/07.
//
import Foundation
import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var diceButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var GobackButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var lifpoint1: UIButton!
    @IBOutlet weak var lifpoint2: UIButton!
    @IBOutlet weak var lifpointLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    var player1LP: Int = 8000
    var player2LP: Int = 8000
    var inputValue: String = ""
    var amount: Int {
        return Int(inputValue) ?? 0
    }
    var currentPlayer: Player = .player1
    var currentOperation: OperationType = .subtraction
    enum Player: Int {
        case player1 = 0
        case player2 = 1
    }
    enum OperationType {
        case addition
        case subtraction
        case half
        var symbol: String {
            switch self {
            case .addition:
                return "+"
            case .subtraction:
                return "-"
            case .half:
                return "/2"
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.orientationLock = .landscapeRight
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    @IBAction func lpButtontaped(_ sender: UIButton) {
        if let selectedPlayer = Player(rawValue: sender.tag) {
            currentPlayer = selectedPlayer
            updateLifePointDisplay()
            clearInput()
            clearOperation()
            clearresultPoint()
            updateUI()
           }
    }
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        guard let digit = sender.titleLabel?.text else { return }
        // 入力の上限など制限したければここで調整
        inputValue += digit
        updateLifePointDisplay()
        updateAmountDisplay()
        updateOperationLabel()
        updateresultLabelDisplay()
    }
    @IBAction func operatorButtonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        switch title {
        case "+":
            currentOperation = .addition
        case "-":
            currentOperation = .subtraction
        case "/2":
            currentOperation = .half
        case "CRL":
            clearInput()
        default:
            break
        }
        updateOperationLabel()
    }
    func updateLifePointDisplay() {
        switch currentPlayer {
        case .player1:
            lifpointLabel.text = "\(player1LP)"
        case .player2:
            lifpointLabel.text = "\(player2LP)"
        }
    }
    func updateAmountDisplay() {
        amountLabel.text = inputValue.isEmpty ? "" : inputValue
    }
    func updateOperationLabel() {
        operationLabel.text = currentOperation.symbol
    }
    func updateresultLabelDisplay() {
        let sign = currentOperation.symbol
        switch currentOperation {
        case .addition:
            resultLabel.text = inputValue.isEmpty ? "" : "\(curentPlayerLifpoint()+amount)"
        case .subtraction:
            resultLabel.text = inputValue.isEmpty ? "" : "\(curentPlayerLifpoint()-amount)"
        case .half:
            resultLabel.text = inputValue.isEmpty ? "" : "\(curentPlayerLifpoint() / 2)"
        }
    }
    @IBAction func applyButtonTapped() {
        switch currentOperation {
        case .addition:
            heal(amount)
        case .subtraction:
            applyDamage(amount)
        case .half:
            applyDamage(amount / 2)
        }
        updateLifePointDisplay()
        clearOperation()
        clearresultPoint()
        clearInput()
    }
    func applyDamage(_ amount: Int) {
        switch currentPlayer {
        case .player1:
            player1LP -= amount
        case .player2:
            player2LP -= amount
        }
        updateUI()
    }
    func heal(_ amount: Int) {
        switch currentPlayer {
        case .player1:
            player1LP += amount
        case .player2:
            player2LP += amount
        }
        updateUI()
    }
    func curentPlayerLifpoint() ->Int {
        switch currentPlayer {
        case .player1:
            let value = player1LP
            return value
        case .player2:
            let value = player2LP
            return value
        }
    }
    func clearInput() {
        inputValue = ""
        updateAmountDisplay()
    }
    func clearOperation() {
        currentOperation = .subtraction
        updateOperationLabel()
    }
    func clearresultPoint() {
        resultLabel.text = ""
    }
    func updateUI() {
        switch currentPlayer {
        case .player1:
            lifpoint1.setTitle("\(player1LP)", for: .normal)
            lifpoint1.backgroundColor = .systemBlue
        case .player2:
            lifpoint2.setTitle("\(player2LP)", for: .normal)
            lifpoint2.backgroundColor = .lightGray
        }
        updateAmountDisplay()
    }
}

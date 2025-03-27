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
    struct LogItem {
        let player: Player
        let message: String
        let timestamp: Date  // 時間で並べ替えもできる
    }
    var logs: [LogItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view.backgroundColor = \(String(describing: view.backgroundColor))")
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
            clearAll()
            sender.backgroundColor = .brown
           }
    }
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        guard let digit = sender.titleLabel?.text else { return }
        // 入力の上限など制限したければここで調整
        inputValue += digit
        updateAll()
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
            updateAll()
        default:
            break
        }
        updateOperationLabel()
    }
    func addLogEntry(_ entry: String, for player: Player) {
        switch player {
        case .player1:
            logs.append(LogItem(player: .player1, message: entry, timestamp: Date()))
        case .player2:
            logs.append(LogItem(player: .player2, message: entry, timestamp: Date()))
        }
    }
    func updateAll() {
        updateAmountDisplay()
        updateOperationLabel()
        updateLifePointDisplay()
        updateresultLabelDisplay()
        updateUI()
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
    func updateUI() {
        switch currentPlayer {
        case .player1:
            lifpoint1.setTitle("\(player1LP)", for: .normal)
        case .player2:
            lifpoint2.setTitle("\(player2LP)", for: .normal)
        }
    }
    func clearAll() {
        clearInput()
        clearOperation()
        clearresultPoint()
        clearLifepoinLabel()
        updateAmountDisplay() //inputが空ならlabelをクリアするため
    }
    func clearInput() {
        inputValue = ""
    }
    func clearLifepoinLabel() {
        lifpointLabel.text = ""
    }
    func clearOperation() {
        currentOperation = .subtraction
        operationLabel.text = ""
    }
    func clearresultPoint() {
        resultLabel.text = ""
    }
    @IBAction func applyButtonTapped() {
        switch currentOperation {
        case .addition:
            heal(amount)
        case .subtraction:
            applyDamage(amount)
        case .half:
            applyHalfDamage()
        }
        clearAll()
        updateAll()
    }
    func applyDamage(_ amount: Int) {
        switch currentPlayer {
        case .player1:
            player1LP -= amount
            addLogEntry("−\(amount) → \(player1LP)", for: .player1)
        case .player2:
            player2LP -= amount
            addLogEntry("−\(amount) → \(player2LP)", for: .player2)
        }
    }
    func heal(_ amount: Int) {
        switch currentPlayer {
        case .player1:
            player1LP += amount
            addLogEntry("+\(amount) → \(player1LP)", for: .player1)
        case .player2:
            player2LP += amount
            addLogEntry("+\(amount) → \(player2LP)", for: .player2)
        }
    }
    func applyHalfDamage() {
        switch currentPlayer {
        case .player1:
            player1LP /= 2
            addLogEntry("/2 → \(player1LP)", for: .player1)
        case .player2:
            player2LP /= 2
            addLogEntry("/2 → \(player2LP)", for: .player2)
        }
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
    @IBAction func logButtonTapped(_ sender: Any) {
        showOverlay()
    }
    func showOverlay() {
        // 背景ビュー（半透明の黒）
        // デバッグ用ログを強制追加
        let backgroundView = UIView(frame: self.view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.alpha = 0
        backgroundView.tag = 999 // 削除用
        // メインの白いビュー
        let overlayView = UIView()
        overlayView.layer.cornerRadius = 16
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        // ラベル
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        // 2. スタックビュー（縦方向）
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = .green.withAlphaComponent(0.4)
        stackView.backgroundColor = .blue.withAlphaComponent(0.4)
        let testLabel = UILabel()
        testLabel.text = "ログ"
        testLabel.textAlignment = .center
        testLabel.numberOfLines = 0
        testLabel.textColor = .black
        stackView.addArrangedSubview(testLabel)
        for log in logs {
            let label = UILabel()
            switch log.player {
            case .player1:
                
                label.text = "P1: \(log.message)"
            case .player2:
                label.text = "P2: \(log.message)"
            }
            label.textAlignment = .center
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            stackView.addArrangedSubview(label)
        }
        // 閉じるボタン
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("閉じる", for: .normal)
        closeButton.addTarget(self, action: #selector(dismissOverlay), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.tintColor = .black
        // add & layout
        scrollView.addSubview(stackView)
        overlayView.addSubview(scrollView)
        overlayView.addSubview(closeButton)
        backgroundView.addSubview(overlayView)
        self.view.addSubview(backgroundView)
        // オートレイアウト
        NSLayoutConstraint.activate([
            // overlayView の配置
            overlayView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            overlayView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            overlayView.widthAnchor.constraint(equalToConstant: 300),
            overlayView.heightAnchor.constraint(equalToConstant: 300),
            // scrollView の配置
            scrollView.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -20),
            // stackView の中身制約
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            // 閉じるボタン
            closeButton.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            closeButton.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -20)
        ])
        // アニメーション表示
        UIView.animate(withDuration: 0.3) {
            backgroundView.alpha = 1
        }
    }
    @objc func dismissOverlay() {
        if let overlay = self.view.viewWithTag(999) {
            UIView.animate(withDuration: 0.2, animations: {
                overlay.alpha = 0
            }) { _ in
                overlay.removeFromSuperview()
            }
        }
    }
}


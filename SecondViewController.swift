//
//  SecondViewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/03/07.
//

import Foundation
import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var player1label: UILabel!
    @IBOutlet weak var player2label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .landscape
       }
    @objc func tapedButton(_ sender: UIButton) {
        if sender.backgroundColor == .blue {
            return deleteButtun(sender: sender)
        }
        selectButtun(sender: sender)
    }
    func deleteButtun(sender: UIButton) {
        sender.layer.borderColor = UIColor.black.cgColor
        sender.backgroundColor = .white
    }
    func selectButtun(sender:UIButton) {//  ["name":"["クリボー","真紅眼の黒龍"],"level":["1","7"]]のようなdictionaryを作る
        sender.layer.borderColor = UIColor.red.cgColor
        sender.backgroundColor = .blue
        let title = sender.title(for: .normal)
    }    
}

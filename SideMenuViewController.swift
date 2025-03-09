//
//  File.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/03/07.
//

import Foundation
import UIKit
class FileManager : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
               view.backgroundColor = .white
               let label = UILabel()
               label.text = "メニュー"
               label.frame = view.bounds
               view.addSubview(label)
    }
}

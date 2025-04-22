//
//  CinkuroJokyuVIewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/04/22.
//

import Foundation
import UIKit
class CinkuroJokyuVIewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textView3: UITextView!
    @IBOutlet weak var textView4: UITextView!
    @IBOutlet weak var textView5: UITextView!
    @IBOutlet weak var textView6: UITextView!
    @IBOutlet weak var textView7: UITextView!
    @IBOutlet weak var textViewHeihtConst: NSLayoutConstraint!
    @IBOutlet weak var textViewHeihtConst2: NSLayoutConstraint!
    @IBOutlet weak var textViewHeihtConst3: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let textViews = [textView1,textView2,textView3,textView4,textView5,textView6,textView7]
        for tv in textViews {
            textViewsCustom(textView: tv!)
        }
        zoomToRedLineAreaSmooth(imageView: imageView)
    }
    func textViewsCustom(textView: UITextView) {
        let fittingSize = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
        let size = textView.sizeThatFits(fittingSize)
        switch textView {
        case textView1:
            textViewHeihtConst.constant = size.height
        case textView3:
            textViewHeihtConst2.constant = size.height
        case textView6:
            textViewHeihtConst3.constant = size.height
        default:
            break
        }
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 12
        textView.backgroundColor = UIColor(white: 1.0, alpha: 0.8) // 半透明でクール
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        textView.layer.masksToBounds = true
        
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16) // 内側の余白
        textView.isEditable = false
    }
    func zoomToRedLineAreaSmooth(imageView: UIImageView) {
        // 表示したい赤線部分の範囲（割合で指定）
        // 例として：中央下部の横長部分（画像サイズに応じて調整必要）
        let targetRect = CGRect(x: 0.05, y: 0.9, width: 0.6, height: 0.1)
        // アニメーション付きで contentsRect を変更
        let animation = CABasicAnimation(keyPath: "contentsRect")
        animation.fromValue = imageView.layer.contentsRect
        animation.toValue = targetRect
        animation.duration = 5.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true             // 元に戻す
        animation.repeatCount = .infinity         // 無限ループ！
        imageView.layer.add(animation, forKey: "zoomContentsRect")
        // 実際の表示も変える
        imageView.layer.contentsRect = targetRect
    }
    func resetZoom(imageView: UIImageView) {
        UIView.animate(withDuration: 0.8) {
            imageView.transform = .identity
        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

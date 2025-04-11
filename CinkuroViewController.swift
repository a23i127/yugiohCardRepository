//
//  TestViewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/03/31.
//

import Foundation
import UIKit
class sinkuroViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var monster1: UIImageView!
    @IBOutlet weak var monster2: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var monster3: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var monster4: UIImageView!
    @IBOutlet weak var monster5: UIImageView!
    @IBOutlet weak var fireImage1: UIImageView!
    @IBOutlet weak var fireImage2: UIImageView!
    @IBOutlet weak var fireImage3: UIImageView!
    @IBOutlet weak var fireImage4: UIImageView!
    @IBOutlet weak var fireImage5: UIImageView!
    @IBOutlet weak var monster6: UIImageView!
    @IBOutlet weak var monster7: UIImageView!
    
    //パララックスのため
    var originalX1: CGFloat = 0
    var originalY1: CGFloat = 0
    var originalX2: CGFloat = 0
    var originalY2: CGFloat = 0
    var originalX3: CGFloat = 0
    var originalY3: CGFloat = 0
    var originalX4: CGFloat = 0
    var originalY4: CGFloat = 0
    var originalX5: CGFloat = 0
    var originalY5: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.frame = scrollView.bounds
        self.contentView.insertSubview(self.backgroundImage, at: 0)
        backgroundImage.isHidden = true
        monster1.alpha = 0
        monster2.alpha = 0
        monster3.alpha = 0
        monster4.alpha = 0
        monster5.alpha = 0
        monster6.alpha = 0
        monster7.alpha = 0
        textView.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //パララックスのため
        originalX1 = fireImage1.frame.origin.x
        originalY1 = fireImage1.frame.origin.y
        originalX2 = fireImage2.frame.origin.x
        originalY2 = fireImage2.frame.origin.y
        originalX3 = fireImage3.frame.origin.x
        originalY3 = fireImage3.frame.origin.y
        originalX4 = fireImage4.frame.origin.x
        originalY4 = fireImage4.frame.origin.y
        originalX5 = fireImage5.frame.origin.x
        originalY5 = fireImage5.frame.origin.y
        backgroundImage.frame = CGRect(origin: .zero, size: scrollView.contentSize)
        self.animateText( on: self.textView)
        playSynchroExplosionAndTransition()
        DispatchQueue.main.asyncAfter(deadline: .now()+4.5) {
            self.backgroundImage.isHidden = false
            self.animateCharacter()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+6.5) {
            self.animateCharacter2()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+7.5) {
            self.animateCharacter3()
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {//パララックス
        let offsetY = scrollView.contentOffset.y
        if offsetY > 500 {
            
        }
        // 隕石の動き（速く落ちるように倍率大きめにする）
        if offsetY > 750  {
            let newY1 = offsetY * 0.4         // 下に落ちる（Y方向）
            let newX1 = -offsetY * 0.1
            let newY2 = offsetY * 0.2         // 下に落ちる（Y方向）
            let newX2 = -offsetY * 0.06
            let newY3 = offsetY * 0.04          // 下に落ちる（Y方向）
            let newX3 = -offsetY * 0.1
            let newY4 = offsetY * 0.2          // 下に落ちる（Y方向）
            let newX4 = -offsetY * 0.15// 左に流れる（X方向にマイナス）
            let newY5 = offsetY * 0.1          // 下に落ちる（Y方向）
            let newX5 = -offsetY * 0.15
            fireImage1.frame.origin = CGPoint(x: originalX1 + newX1,
                                              y: originalY1 + newY1)
            fireImage2.frame.origin = CGPoint(x: originalX2 + newX2,
                                              y: originalY2 + newY2)
            fireImage3.frame.origin = CGPoint(x: originalX3 + newX3,
                                              y: originalY3 + newY3)
            fireImage4.frame.origin = CGPoint(x: originalX4 + newX4,
                                              y: originalY4 + newY4)
            fireImage5.frame.origin = CGPoint(x: originalX5 + newX5,
                                              y: originalY5 + newY5)
            
        }
            
        // ← 調整ポイント！
    }
    func animateCharacter() {
        // 斜め右下に向かう位置に制約を変える
        contentView.addSubview(monster1)
        monster1.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 1.0) {
            self.monster1.alpha = 1  // 徐々に表示される
        }
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.auraPlas(imageView: self.monster1, color: .red)
                self.floatAction(imageView: self.monster1)
            },
            completion: nil
        )
    }
    func animateCharacter2() {
        contentView.addSubview(monster2)
        monster2.transform = .identity
        
        // ステップ1：移動（スケール1.0）
        UIView.animate(withDuration: 1.0,animations: {
            //self.monster2.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            self.monster2.alpha = 1  // 徐々に表示される
            self.auraPlas(imageView: self.monster2, color: .blue)
            self.floatAction(imageView: self.monster2)
        })
    }
    func animateCharacter3() {
        // 斜め右下に向かう位置に制約を変える
        contentView.addSubview(monster3)
        monster3.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 1.0,animations: {
            //self.monster2.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            self.monster3.alpha = 1  // 徐々に表示される
            self.auraPlas(imageView: self.monster3, color: .yellow)
            self.floatAction(imageView: self.monster3)
        })
    }
    
    func playSynchroExplosionAndTransition() {
        let centerPoint = view.center
        // グリーンフラッシュの土台ビュー
        let greenFlash = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        greenFlash.center = centerPoint
        greenFlash.layer.cornerRadius = 100
        greenFlash.clipsToBounds = true
        greenFlash.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        greenFlash.alpha = 0.4
        view.addSubview(greenFlash)
        // ✅ グラデーションレイヤーを追加
        let gradient = CAGradientLayer()
        gradient.frame = greenFlash.bounds
        gradient.colors = [
            UIColor.green.cgColor,
            UIColor.white.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        greenFlash.layer.insertSublayer(gradient, at: 0)
        
        // ✅ 加算合成っぽく（glow感UP）
        greenFlash.layer.compositingFilter = "screen"
        
        // ✅ Glowっぽくシャドウも
        greenFlash.layer.shadowColor = UIColor.green.cgColor
        greenFlash.layer.shadowOpacity = 0.8
        greenFlash.layer.shadowRadius = 40
        greenFlash.layer.shadowOffset = .zero
        
        // 💥 エフェクトアニメーション開始
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            greenFlash.alpha = 1.0
            greenFlash.transform = CGAffineTransform(scaleX: 15, y: 15)
        })
        
        // 白爆発：タイミング調整（緑の拡大中に発動）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.showWhiteExplosionAndTransition()
        }
        
        // 緑エフェクトを消すタイミング（遷移前に後片付け）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            greenFlash.removeFromSuperview()
        }
    }
    func showWhiteExplosionAndTransition() {
        let whiteExplosion = UIView(frame: view.bounds)
        whiteExplosion.backgroundColor = UIColor.white
        whiteExplosion.alpha = 1.0
        contentView.addSubview(whiteExplosion)
        // 爆発のフェードアウト（ゆっくり消えていく）
        UIView.animate(withDuration: 5.0, delay: 0.1, options: [.curveEaseOut], animations: {
            whiteExplosion.alpha = 0.0
        }) { _ in
            whiteExplosion.removeFromSuperview()
        }
    }
    func fadeInMonster(_ imageView: UIImageView, duration: TimeInterval = 0.8) {
        imageView.alpha = 0.0
        imageView.transform = CGAffineTransform(translationX: -50, y: 130)
            .scaledBy(x: 3.0, y: 3.0)// ちょっと小さくしてから登場
        imageView.isHidden = false
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: {
            imageView.alpha = 1.0
            // 元のサイズに戻す
        }, completion: nil)
    }
    func auraPlas(imageView: UIImageView,color: UIColor) {
        imageView.layer.shadowColor = color.cgColor     // オーラの色
        imageView.layer.shadowRadius = 20                      // ぼかし具合
        imageView.layer.shadowOpacity = 0.8                    // 透明度
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        let glowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        glowAnimation.fromValue = 0.4
        glowAnimation.toValue = 1.0
        glowAnimation.duration = 1.0
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = .infinity
        
        imageView.layer.add(glowAnimation, forKey: "glow")// 影を画像の周囲全体に
    }
    func floatAction(imageView: UIImageView) {
        let float = CABasicAnimation(keyPath: "transform.translation.y")
        float.fromValue = -5
        float.toValue = 5
        float.duration = 2.5
        float.autoreverses = true
        float.repeatCount = .infinity
        float.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        imageView.layer.add(float, forKey: "float")
    }
    func animateText(on textView: UITextView, interval: TimeInterval = 0.05) {
        guard let fullText = textView.text else { return }
        textView.text = ""  // 一旦非表示にして、あとから1文字ずつ表示
        var charIndex = 0
        UIView.animate(withDuration: 1.0,animations: {
            self.textView.alpha = 1  // 徐々に表示される
        })
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
            textView.text.append(fullText[index])
            charIndex += 1
            
            if charIndex == fullText.count {
                timer.invalidate()
                textView.alpha = 0
            }
        }
    }
}

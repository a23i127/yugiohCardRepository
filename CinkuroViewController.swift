//
//  TestViewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/03/31.
//

import Foundation
import UIKit
class sinkuroViewController: UIViewController {
    @IBOutlet weak var monster1: UIImageView!
    @IBOutlet weak var monster2: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var monster3: UIImageView!
    @IBOutlet weak var textView: UITextView!
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
        textView.alpha = 0
        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //backgroundImage.frame = CGRect(origin: .zero, size: scrollView.contentSize)
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

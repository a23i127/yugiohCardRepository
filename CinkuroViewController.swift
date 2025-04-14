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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tyunar1: UIImageView!
    @IBOutlet weak var tyunar2: UIImageView!
    @IBOutlet weak var monstar6: UIImageView!
    @IBOutlet weak var cercleImage1: UIImageView!
    @IBOutlet weak var cercleImage2: UIImageView!
    @IBOutlet weak var reftWing: UIImageView!
    @IBOutlet weak var rightWing: UIImageView!
    @IBOutlet weak var jankuSinkuron: UIImageView!
    @IBOutlet weak var jankuSpeader: UIImageView!
    //パララックスのため
    var hasAnimatedMonster4 = false
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.frame = scrollView.bounds
        self.contentView.insertSubview(self.backgroundImage, at: 0)
        backgroundImage.isHidden = true
        monster1.alpha = 0
        monster2.alpha = 0
        monstar6.alpha = 0
        jankuSpeader.alpha = 0
        jankuSinkuron.alpha = 0
        textView.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //パララックスのため
        backgroundImage.frame = CGRect(origin: .zero, size: scrollView.contentSize)
        self.animateText( on: self.textView)
        //playSynchroExplosionAndTransition()
        DispatchQueue.main.asyncAfter(deadline: .now()+4.5) {
            self.backgroundImage.isHidden = false
            //self.animateCharacter()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+6.5) {
            //self.animateCharacter2(imageView: self.monster2, color: .blue)
        }
    }
    @IBAction func introduceAction(_ sender: Any) {
        self.animateSynchroLineUp()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {//パララックス
        var offsetY = scrollView.contentOffset.y
        if offsetY > 500 && !hasAnimatedMonster4 {
                hasAnimatedMonster4 = true // もう呼ばせないようにフラグON
            
            }
        // 隕石の動き（速く落ちるように倍率大きめにする）
        if offsetY > 750  {
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
    func animateCharacter2(imageView: UIImageView, color: UIColor = .blue) {
        imageView.transform = .identity
        imageView.alpha = 0
        contentView.addSubview(imageView)
        UIView.animate(withDuration: 1.0, animations: {
            imageView.alpha = 1
            self.auraPlas(imageView: imageView, color: color)
            self.floatAction(imageView: imageView)
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
    func animateSynchroLineUp() {
        let centerX = view.center.x
        let centerY = view.center.y

        // ステップ1：モンスター画像を一直線に並べる
        UIView.animate(withDuration: 0.5, animations: {
            print("今のスレッド：\(Thread.isMainThread ? "メイン" : "バックグラウンド")")
            self.tyunar1.center = CGPoint(x: centerX, y: centerY + 750)
            self.tyunar2.center = CGPoint(x: centerX, y: centerY + 1000)
        }, completion: { _ in
            // ステップ2：並んだ後に光の線を出現！
            self.showRisingLightLineWithExplosion()
        })
    }
    func showRisingLightLineWithExplosion() {
        let lightLine = UIView()
        lightLine.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        let lineWidthStart: CGFloat = 2
        let lineWidthMid: CGFloat = 150
        let lineHeight: CGFloat = 852
        let startY = view.bounds.height
        let endY = view.bounds.height - lineHeight
        // 最初の細い線（下から登場）
        lightLine.frame = CGRect(x: view.bounds.midX - lineWidthStart / 2,
                                 y: startY,
                                 width: lineWidthStart,
                                 height: lineHeight)
        view.addSubview(lightLine)
        // Step 1: 上にスライド（太さは変えない）
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            lightLine.frame.origin.y = endY
        }, completion: { _ in
            // Step 2: ゆっくり太くなっていく
            UIView.animate(withDuration: 1.2, delay: 0, options: [.curveEaseInOut], animations: {
                lightLine.frame = CGRect(x: self.view.bounds.midX - lineWidthMid / 2,
                                         y: endY,
                                         width: lineWidthMid,
                                         height: lineHeight)
            }, completion: { _ in
                // Step 3: 一気に爆発（画面全体を覆う）
                let finalSize: CGFloat = max(self.view.bounds.width, self.view.bounds.height) * 2

                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                    lightLine.frame = CGRect(x: self.view.bounds.midX - finalSize / 2,
                                             y: self.view.bounds.midY - finalSize / 2,
                                             width: finalSize,
                                             height: finalSize)
                    lightLine.layer.cornerRadius = finalSize / 2
                    lightLine.alpha = 0.0// フェードアウトで爆発の余韻を出す
                    self.cercleImage1.alpha = 0
                    self.cercleImage2.alpha = 0
                    self.tyunar1.alpha = 0
                    self.tyunar2.alpha = 0
                }, completion: { _ in
                    lightLine.removeFromSuperview()
                    self.animateCharacter2(imageView: self.monstar6)
                    self.gentleFlap(view: self.reftWing, isLeftWing: true)
                    self.gentleFlap(view: self.rightWing, isLeftWing: false)
                })
            })
        })
    }
    func gentleFlap(view: UIView, isLeftWing: Bool) {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")

        // とても小さな回転角（約6度）
        let angle: CGFloat = isLeftWing ? -CGFloat.pi / 30 : CGFloat.pi / 30

        // やさしく開いて、戻るだけ（揺らぎ少なめ）
        animation.values = [0, angle, 0]
        animation.keyTimes = [0.0, 0.5, 1.0] as [NSNumber]

        animation.duration = 3.5  // ゆっくりふんわり
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        view.layer.add(animation, forKey: "gentleFlap")
    }}

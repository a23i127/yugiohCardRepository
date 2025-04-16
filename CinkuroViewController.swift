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
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tyunar1: UIImageView!
    @IBOutlet weak var tyunar2: UIImageView!
    @IBOutlet weak var monstar6: UIImageView!
    @IBOutlet weak var cercleImage1: UIImageView!
    @IBOutlet weak var cercleImage2: UIImageView!
    @IBOutlet weak var leftWing: UIImageView!
    @IBOutlet weak var rightWing: UIImageView!
    @IBOutlet weak var jankuSinkuron: UIImageView!
    @IBOutlet weak var jankuSpeader: UIImageView!
    @IBOutlet weak var lebel3Image: UIImageView!
    @IBOutlet weak var lebel5Image: UIImageView!
    @IBOutlet weak var teacher: UIImageView!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textView3: UITextView!
    var animationFlag = false
    var animationFlag2 = false
    override func viewDidLoad() {
        super.viewDidLoad()
        textView1.layer.masksToBounds = true
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.frame = scrollView.bounds
        self.contentView.insertSubview(self.backgroundImage, at: 0)
        backgroundImage.isHidden = true
        monster1.alpha = 0
        monstar6.alpha = 0
        textView.alpha = 0
        cercleImage1.alpha = 0
        cercleImage2.alpha = 0
        leftWing.alpha = 0
        rightWing.alpha = 0
        textView1.alpha = 0
        textView2.alpha = 0
        textView3.alpha = 0
        tyunar1.alpha = 0
        tyunar2.alpha = 0
        lebel3Image.alpha = 0
        lebel5Image.alpha = 0
        jankuSinkuron.alpha = 0
        jankuSpeader.alpha = 0
        contentView.bringSubviewToFront(tyunar1)
        contentView.bringSubviewToFront(tyunar2)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundImage.frame = CGRect(origin: .zero, size: scrollView.contentSize)
        //playSynchroExplosionAndTransition()
        DispatchQueue.main.asyncAfter(deadline: .now()+4.5) {
            self.backgroundImage.isHidden = false
            self.animateCharacter(monster: self.monster1, color: .red)
        }
        textViewsCustom(textView: textView)
        textViewsCustom(textView: textView1)
        textViewsCustom(textView: textView2)
        textViewsCustom(textView: textView3)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let viewHeight = scrollView.frame.height
        let scrollRatio = offsetY / viewHeight  // ← これがポイント！
        switch true {
        case scrollRatio > 0.4 && !animationFlag:
            jankuSinkuron.alpha = 1
            jankuSpeader.alpha = 1
            changeClearColor(monsterView: jankuSinkuron)
            changeClearColor(monsterView: jankuSpeader)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.tyunar1.alpha = 0
                self.tyunar2.alpha = 0
                self.animateSynchroLineUp()
            }
            animationFlag = true
        case scrollRatio > 0.8 && !animationFlag2:
            animateCharacter(monster: teacher, color: .red)
            animateTextView(on: textView)
            animationFlag2 = true
        default:
            break
        }
    }
    
    func animateCharacter(monster: UIImageView, color: UIColor) {
        // 斜め右下に向かう位置に制約を変える
        contentView.addSubview(monster)
        monster.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 1.0) {
            monster.alpha = 1  // 徐々に表示される
        }
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.auraPlas(imageView: monster, color: color)
                self.floatAction(imageView: monster)
            },
            completion: {_ in 
                self.animateTextView( on: self.textView1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.animateTextView( on: self.textView2)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.animateTextView( on: self.textView3)
                }
                self.tyunar1.alpha = 1
                self.tyunar2.alpha = 1
                self.lebel3Image.alpha = 1
                self.lebel5Image.alpha = 1
            }
        )
    }
    func sinkuroSumoon() {
        monstar6.transform = .identity
        contentView.addSubview(monstar6)
        UIView.animate(withDuration: 0.5, animations: {
            self.leftWing.alpha = 1
            self.rightWing.alpha = 1
            self.monstar6.alpha = 1
            self.auraPlas(imageView: self.monstar6, color: .blue)
            self.floatAction(imageView: self.monstar6)
        })
    }
    func changeClearColor(monsterView: UIImageView) {
        let mask = CALayer()
        mask.backgroundColor = UIColor.white.cgColor
        mask.anchorPoint = CGPoint(x: 0.5, y: 1.0)//起点
        mask.position = CGPoint(x: monsterView.bounds.midX, y: monsterView.bounds.height)
        mask.bounds = CGRect(x: 0, y: 0, width: monsterView.bounds.width, height: 0)
        monsterView.layer.mask = mask
        let animation = CABasicAnimation(keyPath: "bounds.size.height")
        animation.fromValue = 0
        animation.toValue = monsterView.bounds.height
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        contentView.bringSubviewToFront(monsterView)//ImageViewの順序変更
        mask.add(animation, forKey: "reveal")
        mask.bounds.size.height = monsterView.bounds.height
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
    func animateTextView(on textView: UITextView, interval: TimeInterval = 0.02) {
        guard let fullText = textView.text else { return }
        textView.text = ""  // 一旦非表示にして、あとから1文字ずつ表示
        var charIndex = 0
        UIView.animate(withDuration: 0.3,animations: {
            textView.alpha = 1  // 徐々に表示される
        })
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
            textView.text.append(fullText[index])
            charIndex += 1
            
            if charIndex == fullText.count {
                timer.invalidate()
            }
        }
    }
    func animateSynchroLineUp() {
        let centerX = view.center.x
        let centerY = view.center.y
        
        // ステップ1：モンスター画像を一直線に並べる
        UIView.animate(withDuration: 0.8, animations: {
            self.jankuSinkuron.center = CGPoint(x: centerX, y: centerY + 550)
            self.jankuSpeader.center = CGPoint(x: centerX, y: centerY + 700)
            self.lebel3Image.center = CGPoint(x: centerX - 160, y: centerY + 76)
            self.lebel5Image.center = CGPoint(x: centerX - 60, y: centerY - 140)
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
                    self.jankuSinkuron.alpha = 0
                    self.jankuSpeader.alpha = 0
                }, completion: { _ in
                    lightLine.removeFromSuperview()
                    self.sinkuroSumoon()
                    self.gentleFlap(view: self.leftWing, isLeftWing: true)
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
    }
    func textViewsCustom(textView: UITextView) {
        textView.layer.cornerRadius = 12
        textView.backgroundColor = UIColor(white: 1.0, alpha: 0.1) // 半透明でクール
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        textView.layer.masksToBounds = true
        
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16) // 内側の余白
        textView.isEditable = false
    }
}

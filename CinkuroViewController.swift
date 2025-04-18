//
//  TestViewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/03/31.
//

import Foundation
import UIKit
class sinkuroViewController: UIViewController,UIScrollViewDelegate {
    //@IBOutlet weak var tatleLog: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tyunar1: UIImageView!
    @IBOutlet weak var tyunar2: UIImageView!
    @IBOutlet weak var monstar6: UIImageView!
    @IBOutlet weak var leftWing: UIImageView!
    @IBOutlet weak var rightWing: UIImageView!
    @IBOutlet weak var jankuSinkuron: UIImageView!
    @IBOutlet weak var jankuSpeader: UIImageView!
    @IBOutlet weak var lebel3Image: UIImageView!
    @IBOutlet weak var lebel5Image: UIImageView!
    @IBOutlet weak var teacher: UIImageView!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView3: UITextView!
    @IBOutlet weak var textView4: UITextView!
    @IBOutlet weak var textView6: UITextView!
    @IBOutlet weak var textView7: UITextView!
    @IBOutlet weak var textView8: UITextView!
    @IBOutlet weak var textView9: UITextView!
    @IBOutlet weak var apealView: UIView!
    @IBOutlet weak var titleLog: UIImageView!
    @IBOutlet weak var tyunarLabel: UILabel!
    @IBOutlet weak var monstarLabel: UILabel!
    @IBOutlet weak var lebel8Image: UIImageView!
    var animationFlag = false
    var animationFlag2 = false
    var animationFlag3 = false
    var animationFlag4 = false
    override func viewDidLoad() {
        super.viewDidLoad()
        textView1.layer.masksToBounds = true
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.frame = scrollView.bounds
        contentView.isHidden = true
        self.contentView.insertSubview(self.backgroundImage, at: 0)
        titleLog.alpha = 0
        monstar6.alpha = 0
        leftWing.alpha = 0
        rightWing.alpha = 0
        textView1.alpha = 0
        textView3.alpha = 0
        textView6.alpha = 0
        textView8.alpha = 0
        apealView.alpha = 0
        tyunar1.alpha = 0
        tyunar2.alpha = 0
        lebel3Image.alpha = 0
        lebel5Image.alpha = 0
        jankuSinkuron.alpha = 0
        jankuSpeader.alpha = 0
        lebel8Image.alpha = 0
        contentView.bringSubviewToFront(tyunar1)
        contentView.bringSubviewToFront(tyunar2)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let textViews: [UITextView] = [textView1, textView3, textView4, textView6, textView7, textView8, textView9]
        backgroundImage.frame = CGRect(origin: .zero, size: scrollView.contentSize)
        appearTitleLog(on: self.view)
        for tv in textViews {
            textViewsCustom(textView: tv)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            self.appearView( on: self.textView6)
            self.tyunar1.alpha = 1
            self.tyunar2.alpha = 1
            self.lebel3Image.alpha = 1
            self.lebel5Image.alpha = 1
        }
    }
    func appearTitleLog(on parentView: UIView) {
        // 黒いビューを用意
        let blackView = UIView(frame: parentView.bounds)
        blackView.backgroundColor = .black
        blackView.alpha = 1.0
        blackView.addSubview(titleLog)
        parentView.addSubview(blackView)
        parentView.bringSubviewToFront(blackView)
        titleLog.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLog.centerXAnchor.constraint(equalTo: blackView.centerXAnchor),
            titleLog.centerYAnchor.constraint(equalTo: blackView.centerYAnchor)
        ])
        // フェードイン（0.5秒）
        UIView.animate(withDuration: 0.5, animations: {
            self.titleLog.alpha = 1.0
        }) { _ in
            // 1秒待ってからフェードアウト
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.titleLog.alpha = 0.0
                }) { _ in
                    // 完了後にビューを削除
                    blackView.removeFromSuperview()
                    self.contentView.isHidden = false
                }
            }
        }
    }
    func textViewsCustom(textView: UITextView) {
        textView.layer.cornerRadius = 12
        textView.backgroundColor = UIColor(white: 1.0, alpha: 0.8) // 半透明でクール
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        textView.layer.masksToBounds = true
        
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16) // 内側の余白
        textView.isEditable = false
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
            }
        )
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let viewHeight = contentView.frame.height
        let scrollRatio = offsetY / viewHeight  // ← これがポイント！
        switch true {
        case scrollRatio > 0.1 && !animationFlag:
            self.appearView( on: self.apealView)
            animationFlag = true
        case scrollRatio > 0.2 && !animationFlag2:
            self.appearView( on: self.textView8)
            animationFlag2 = true
        case scrollRatio > 0.3 && !animationFlag3:
            self.appearView( on: self.textView3)
            animationFlag3 = true
        case scrollRatio > 0.4 && !animationFlag4:
            jankuSinkuron.alpha = 1
            jankuSpeader.alpha = 1
            changeClearColor(monsterView: jankuSinkuron) {
                self.lebel3Image.alpha = 0
                self.tyunarLabel.alpha = 0
            }
            changeClearColor(monsterView: jankuSpeader) {
                self.lebel5Image.alpha = 0
                self.monstarLabel.alpha = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.tyunar1.alpha = 0
                self.tyunar2.alpha = 0
                self.animateSynchroLineUp()
            }
            animationFlag4 = true
        default:
            break
        }
    }
    func appearView(on textView: UIView) {
        UIView.animate(withDuration: 0.3,animations: {
            textView.alpha = 1  // 徐々に表示される
        })
    }
    func changeClearColor(monsterView: UIImageView, completion: @escaping () -> Void) {
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
        completion()
    }
    func animateSynchroLineUp() {
        let centerX = view.center.x
        let centerY = view.center.y
        // ステップ1：モンスター画像を一直線に並べる
        UIView.animate(withDuration: 0.8, animations: {
            self.jankuSinkuron.center = CGPoint(x: centerX, y: centerY + self.contentView.bounds.height * 0.5)
            self.jankuSpeader.center = CGPoint(x: centerX, y: centerY + self.contentView.bounds.height * 0.6)//後で調整
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
        let lineHeight: CGFloat = contentView.bounds.height
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
                    self.jankuSinkuron.alpha = 0
                    self.jankuSpeader.alpha = 0
                }, completion: { _ in
                    lightLine.removeFromSuperview()
                    self.sinkuroSumoon()
                    self.wingFlap(view: self.leftWing, isLeftWing: true)
                    self.wingFlap(view: self.rightWing, isLeftWing: false)
                })
            })
        })
    }
    func sinkuroSumoon() {
        monstar6.transform = .identity
        contentView.addSubview(monstar6)
        UIView.animate(withDuration: 0.5, animations: {
            self.leftWing.alpha = 1
            self.rightWing.alpha = 1
            self.monstar6.alpha = 1
            self.lebel8Image.alpha = 1
            self.auraPlas(imageView: self.monstar6, color: .blue)
            self.floatAction(imageView: self.monstar6)
        })
    }
    func wingFlap(view: UIView, isLeftWing: Bool) {
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
}

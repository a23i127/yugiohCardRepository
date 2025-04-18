//
//  TestViewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/03/31.
//

import Foundation
import UIKit
class TestViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.frame = scrollView.bounds
        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //backgroundImage.frame = CGRect(origin: .zero, size: scrollView.contentSize)
        contentView.insertSubview(backgroundImage, at: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
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
   /* func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    }*/
    func appearView(on textView: UIView) {
        UIView.animate(withDuration: 0.3,animations: {
            textView.alpha = 1  // 徐々に表示される
        })
    }
}

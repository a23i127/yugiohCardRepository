//
//  TestViewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/03/31.
//

import Foundation
import UIKit
import PKHUD
class TestViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var exsMonster: UIImageView!
    @IBOutlet weak var exsMonsterArm: UIImageView!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textView3: UITextView!
    @IBOutlet weak var textView4: UITextView!
    @IBOutlet weak var monsterStackView: UIStackView!
    @IBOutlet weak var monsterStackView2: UIStackView!
    var textData:[texts]?
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.frame = contentView.bounds
        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.show(.progress, onView: self.view)
        let textViews: [UITextView] = [textView1,textView2,textView3]
        fetchTextActon()
        backgroundImage.frame = CGRect(origin: .zero, size: scrollView.contentSize)
       
        for tv in textViews {
            textViewsCustom(textView: tv)
        }
        //animateCharacter(monster: exsMonster, color: .yellow)
        //animateHand()
    }
    func fetchTextActon() {
        if textData == nil {
            let fetchTextInstance = fetchTextData()
            fetchTextInstance.fecthText() { [weak self] texts,result in
                guard let self = self else { return }
                switch result {
                case true:
                    self.textData = texts!
                    DispatchQueue.main.async{
                        self.textDataset(texts: self.textData!)
                    }
                case false: self.showAlert()
                }
            }
        }
    }
    func textDataset(texts: [texts]) {
        for textbox in texts {
            switch textbox.position {
            case 0: textView1.text = textbox.text
            case 1: textView2.text = textbox.text
            case 2: textView3.text = textbox.text
            default:
                break
            }
        }
    }
    func textViewsCustom(textView: UITextView) {
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
    
    func animateCharacter(monster: UIImageView, color: UIColor) {
        // 斜め右下に向かう位置に制約を変える
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
    func animateHand() {
        UIView.animate(withDuration: 3.5,
                       delay: 0,
                       options: [.autoreverse, .repeat],
                       animations: {
            self.exsMonsterArm.transform = CGAffineTransform(translationX: 0, y: -5)
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
    func showAlert() {
        let alert = UIAlertController(title: "お知らせです", message: "エラーです", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

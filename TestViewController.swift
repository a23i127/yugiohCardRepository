//
//  TestViewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/03/31.
//

import Foundation
import UIKit
import PKHUD
import SDWebImage
class TestViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textView3: UITextView!
    @IBOutlet weak var textView4: UITextView!
    @IBOutlet weak var textView5: UITextView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    @IBOutlet weak var imageView7: UIImageView!
    @IBOutlet weak var imageView8: UIImageView!
    @IBOutlet weak var imageView9: UIImageView!
    @IBOutlet weak var buttun1: UIButton!
    @IBOutlet weak var buttun2: UIButton!
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackVIew3: UIStackView!
    var animationFlags: [Bool] = Array(repeating: false, count: 8)
    var textData:[texts]?
    var kategori: String?
    var textViews: [UITextView] = []
    var buttons: [UIButton] = []
    var imageViews: [UIImageView] = []
    struct AnimationAction {
        let threshold: CGFloat
        var flag: Bool
        let action: () -> Void
    }
    var animationAction: [AnimationAction] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.frame = contentView.bounds
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textViews = [textView1,textView2,textView3,textView4,textView5]
        buttons = [buttun1, buttun2]
        imageViews = [imageView1, imageView2, imageView3, imageView4, imageView5, imageView6, imageView7, imageView8, imageView9]
        if textData == nil {
            HUD.show(.progress, onView: self.view)
            fetchTextActon()
        }
        for tv in textViews {
            textViewsCustom(textView: tv)
        }
        
        animationAction = [
            AnimationAction(threshold: 0.02, flag: false, action: { self.appearView(on: self.textView1) }),
            AnimationAction(threshold: 0.02, flag: false, action: {
                self.zoomToRedLineAreaSmooth(imageView: self.imageView1)
                self.appearView(on: self.stackView1)
            }),
            AnimationAction(threshold: 0.1, flag: false, action: { self.appearView(on: self.stackView2) }),
            AnimationAction(threshold: 0.35, flag: false, action: { self.animateCharacter(monster: self.imageView4, color: .yellow) }),
            AnimationAction(threshold: 0.45, flag: false, action: { self.animateCharacter(monster: self.imageView5, color: .yellow) }),
            AnimationAction(threshold: 0.65, flag: false, action: { self.kategoriAction()}),
            AnimationAction(threshold: 0.9, flag: false, action: { self.appearView(on: self.stackVIew3) })
        ]
    }
    func fetchTextActon() {
        guard let kategori = kategori else { return showAlert() }
        let fetchTextInstance = fetchTextData()
        fetchTextInstance.fecthViewData(kategori: kategori,dataContent: "メインデータ") { [weak self] texts,result in
            guard let self = self else { return }
            switch result {
            case true:
                self.textData = texts!
                self.Dataset(texts: self.textData!)
            case false:
                self.showAlert()
            }
        }
    }
    func Dataset(texts: [texts]) {
        for textbox in texts {
            let position = textbox.position
            if let textData = textbox.text {
                switch position {
                case 0..<textViews.count:
                    textViews[position].text = textData
                case 5:
                    buttons[0].setTitle(textData, for: .normal)
                case 6:
                    buttons[1].setTitle(textData, for: .normal)
                default:
                    break
                }
            }
            
            if let photoString = textbox.photo {
                switch position {
                case 0..<imageViews.count:
                    urlImageSet(imageView: imageViews[position], photoData: photoString)
                case 9:
                    urlImageSet(imageView: backgroundImage, photoData: photoString)
                default:
                    break
                }
            }
        }
    }
    func urlImageSet(imageView:UIImageView,photoData: String) {
        print(photoData)
        let url = URL(string: photoData)
        do {
            imageView.sd_setImage(with:url)
        } catch {
            print("Error : Cat't get image")
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
    func zoomToRedLineAreaSmooth(imageView: UIImageView) {
        var targetRect = CGRect(x: 0.6, y: 0.1, width: 0.3, height: 0.1)
        if imageView == imageView3 {
            targetRect = CGRect(x: 0.05, y: 0.75, width: 0.6, height: 0.1)
        }
        //Uikitで座標反転する！
        let animation = CABasicAnimation(keyPath: "contentsRect")
        animation.fromValue = imageView.layer.contentsRect
        animation.toValue = targetRect
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)// 無限ループ！
        imageView.layer.add(animation, forKey: "zoomContentsRect")
        // 実際の表示も変える
        imageView.layer.contentsRect = targetRect
    }
    func kategoriAction(){
        switch kategori {
        case "エクシーズ":
            exsSummon(imageView1: self.imageView4, imageView2: self.imageView5)
        default:
            break
        }
    }
    //カテゴリ専用関数
    func exsSummon(imageView1: UIImageView, imageView2: UIImageView) {
        let screenWidth = contentView.bounds.width
        let screenHeight = contentView.bounds.height
        let targetCenter = CGPoint(x: screenWidth / 2, y: screenHeight * 0.3)
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseOut], animations: {
            imageView1.alpha = 1.0
        }, completion: { _ in
            // imageView2を少し遅れてフェードイン＆移動
            UIView.animate(withDuration: 1.0, delay: 0.2, options: [.curveEaseOut], animations: {
                imageView2.alpha = 1.0
            }, completion: {_ in
                UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut,], animations: {
                    imageView1.center = targetCenter
                    imageView2.center = targetCenter
                }, completion: { _ in
                    let target = CGPoint(x: screenWidth / 2, y: screenHeight * 0.7)
                    self.firstGlowAnimation(point: target)
                    self.explosion(at: target, in: self.contentView)
                })
            })
        })
    }
    func firstGlowAnimation(point: CGPoint) {
        let glow = CALayer()
        glow.backgroundColor = UIColor.black.cgColor
        glow.frame = CGRect(x: point.x - 40, y: point.y - 40, width: 80, height: 80)
        glow.cornerRadius = 40
        glow.opacity = 0
        view.layer.addSublayer(glow)
        
        let glowAnimation = CABasicAnimation(keyPath: "opacity")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = 1
        glowAnimation.duration = 0.2
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = 3
        glow.add(glowAnimation, forKey: "glowFlash")
    }
    func explosion(at point: CGPoint, in view: UIView) {
        createExplosion(point: point, color: .yellow, delay: 0.6)
        createExplosion(point: point, color: .black, delay: 0.9,additionalAnimations: {
            self.imageView4.alpha = 0
            self.imageView5.alpha = 0
        },completion: {
            self.animateCharacter(monster: self.imageView7, color: .yellow)
            self.animateHand()
        } )
    }
    func createExplosion(point: CGPoint,color: UIColor, delay: TimeInterval, additionalAnimations: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let explosion = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                explosion.center = point
                explosion.layer.cornerRadius = 10
                explosion.backgroundColor = color
                self.contentView.addSubview(explosion)
                UIView.animate(withDuration: 0.5, animations: {
                    explosion.transform = CGAffineTransform(scaleX: 100, y: 100)
                    explosion.alpha = 0
                    additionalAnimations?()
                }, completion: { _ in
                    completion?()
                })
            }
        }
    func animateHand() {
        self.auraPlas(imageView: imageView8, color: .yellow)
        appearView(on: imageView8)
        UIView.animate(withDuration: 2.5,
                       delay: 0,
                       options: [.autoreverse, .repeat],
                       animations: {
            self.imageView8.transform = CGAffineTransform(translationX: 0, y: -5)
        }, completion: nil)
    }
    //汎用関数
    func animateCharacter(monster: UIImageView, color: UIColor) {
        monster.transform = CGAffineTransform.identity
        appearView(on: monster)
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
            completion: nil)
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
        let scrollableHeight = scrollView.contentSize.height - scrollView.frame.height
        let scrollRatio = offsetY / scrollableHeight
        for i in 0..<animationAction.count {
            if scrollRatio > animationAction[i].threshold && !animationAction[i].flag {
                animationAction[i].action()
                animationAction[i].flag = true
            }
        }
    }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewData = segue.destination as! introduceViewController
        nextViewData.kategori = kategori!
    }
}

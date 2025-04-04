//
//  sinkuroSummon.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/04/04.
//

import UIKit
import AVFoundation

class sinkuroSummonViewController: UIViewController {

    @IBOutlet weak var tunerImageView: UIImageView!
    @IBOutlet weak var nonTunerImageView: UIImageView!
    @IBOutlet weak var synchroMonsterImageView: UIImageView!
    @IBOutlet weak var summonLabel: UILabel!
    @IBOutlet weak var magicCircleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summonLabel.alpha = 0
        synchroMonsterImageView.isHidden = true
    }

    @IBAction func startSummon(_ sender: UIButton) {
        // 1. モンスターを少し動かす
        UIView.animate(withDuration: 1.0, animations: {
            self.tunerImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.nonTunerImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            // 2. フラッシュ演出
            self.apply3DTiltedRotation(view: self.magicCircleImageView, tiltAngleDeg: 45)
            
            let flashView = UIView(frame: self.view.bounds)
            flashView.backgroundColor = .white
            flashView.alpha = 0
            self.view.addSubview(flashView)

            UIView.animate(withDuration: 0.6, animations: {
                flashView.alpha = 1.0
            }) { _ in
                UIView.animate(withDuration: 0.6, delay: 1, options: [],animations: {
                    flashView.alpha = 0.0
                }) { _ in
                    flashView.removeFromSuperview()

                    // 3. SYNCHRO SUMMON!! を表示
                    self.summonLabel.text = "SYNCHRO SUMMON!!"
                    self.summonLabel.alpha = 0
                    UIView.animate(withDuration: 1.0, animations: {
                        self.summonLabel.alpha = 1.0
                    }) { _ in
                        // 4. モンスター画像を切り替え
                        self.tunerImageView.isHidden = true
                        self.nonTunerImageView.isHidden = true
                        self.synchroMonsterImageView.alpha = 0
                        self.synchroMonsterImageView.isHidden = false
                        UIView.animate(withDuration: 1.0) {
                            self.synchroMonsterImageView.alpha = 1.0
                            self.applyAura(to: self.synchroMonsterImageView)
                            self.animateAuraPulse(on: self.synchroMonsterImageView)
                        }
                    }
                }
            }
        }
    }
    func applyAura(to imageView: UIImageView) {
        imageView.layer.shadowColor = UIColor.cyan.cgColor      // 光の色（青白っぽい）
        imageView.layer.shadowRadius = 20                       // どれだけ拡がるか
        imageView.layer.shadowOpacity = 0.9                     // 光の濃さ
        imageView.layer.shadowOffset = .zero                    // 位置ずれなし
    }
    func animateAuraPulse(on imageView: UIImageView) {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0.3  // 最小の明るさ
        animation.toValue = 1.0    // 最大の明るさ
        animation.duration = 1.0   // 1秒かけて明→暗→明
        animation.autoreverses = true
        animation.repeatCount = .infinity
        imageView.layer.add(animation, forKey: "auraPulse")
    }
    func apply3DTiltedRotation(view: UIView, tiltAngleDeg: CGFloat = 45) {
        // 1. 傾き方向を設定（右下方向に）
        let direction = normalize(x: 1, y: 1) // 45度方向ベクトル

        // 2. 初期の傾き（固定値）
        var baseTransform = CATransform3DIdentity
        baseTransform.m34 = -1.0 / 500.0
        baseTransform = CATransform3DRotate(
            baseTransform,
            tiltAngleDeg * .pi / 180,
            direction.x,
            direction.y,
            0
        )

        // 3. 傾きを「見た目に適用」
        view.layer.transform = baseTransform

        // 4. アニメーション（面に垂直なZ軸回転）
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 5.0
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        view.layer.add(rotation, forKey: "zRotation")
    }
    func normalize(x: CGFloat, y: CGFloat) -> (x: CGFloat, y: CGFloat) {
        let length = sqrt(x * x + y * y)
        return (x / length, y / length)
    }
}

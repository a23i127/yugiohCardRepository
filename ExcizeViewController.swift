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
            self.animateCharacter()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animateCharacter2()
        }
    }
    func animateCharacter() {
        // 斜め右下に向かう位置に制約を変える
        contentView.addSubview(imageView)
        imageView.transform = CGAffineTransform.identity
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.imageView.transform = CGAffineTransform(translationX: 200, y: 600)
                    .scaledBy(x: 2.5, y: 2.5)
            },
            completion: nil
        )
    }
    
    func animateCharacter2() {
        contentView.addSubview(imageView2)
        imageView2.transform = CGAffineTransform.identity
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.imageView2.transform = CGAffineTransform(translationX: -100, y: 150)
                    .scaledBy(x: 4, y: 4)
            },
            completion: nil
        )
    }
}

//
//  CinkuroJokyuVIewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/04/22.
//

import Foundation
import UIKit
import Alamofire
class CinkuroJokyuVIewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textView3: UITextView!
    @IBOutlet weak var textView4: UITextView!
    @IBOutlet weak var textView5: UITextView!
    @IBOutlet weak var textView6: UITextView!
    @IBOutlet weak var textView7: UITextView!
    @IBOutlet weak var textVIew8: UITextView!
    @IBOutlet weak var textViewHeihtConst: NSLayoutConstraint!
    @IBOutlet weak var textViewHeihtConst2: NSLayoutConstraint!
    @IBOutlet weak var textViewHeihtConst3: NSLayoutConstraint!
    @IBOutlet weak var textView4HeightConst4: NSLayoutConstraint!
    @IBOutlet weak var textView4HeightConst5: NSLayoutConstraint!
    @IBOutlet weak var textView4HeightConst6: NSLayoutConstraint!
    @IBOutlet weak var textView4HeightConst7: NSLayoutConstraint!
    @IBOutlet weak var textView4HeightConst8: NSLayoutConstraint!
    var kategori: String?
    var databox: [introduce]?
    var textViews: [UITextView] = []
    var imageViews: [UIImageView] = []
    var textViewConst: [NSLayoutConstraint] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print(kategori)
        fetchData()
        super.viewDidAppear(animated)
        textViews = [textView1,textView2,textView3,textView4,textView5,textView6,textView7,textVIew8]
        imageViews = [imageView,imageView2,imageView3,imageView4]
        textViewConst = [textViewHeihtConst,textViewHeihtConst,textViewHeihtConst2,textView4HeightConst4,textView4HeightConst5,textView4HeightConst6,textView4HeightConst7,textView4HeightConst8]
        for tv in textViews {
            textViewsCustom(textView: tv)
        }
        zoomToRedLineAreaSmooth(imageView: imageView)
    }
    func textViewsCustom(textView: UITextView) {
        let fittingSize = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
        let size = textView.sizeThatFits(fittingSize)
        switch textView {
        case textView1:
            textViewHeihtConst.constant = size.height
        case textView3:
            textViewHeihtConst2.constant = size.height
        case textView6:
            textViewHeihtConst3.constant = size.height
        default:
            break
        }
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
    func fetchData() {
        let fetchDataObj = fetchTextData()
        fetchDataObj.fecthIntroduceData(kategori: kategori!) { [weak self] decodedObj,bool in
            guard let self = self else { return }
            switch bool {
            case true:
                self.databox = decodedObj
                self.Dataset(texts: self.databox!)
            case false:
                self.showAlert()
            }
        }
    }
    func Dataset(texts: [introduce]) {
        for textbox in texts {
            let position = textbox.position
            if let textData = textbox.text {
                switch position {
                case 0..<textViews.count:
                    textViews[position].text = textData
                default:
                    break
                }
            }
            
            if let photoString = textbox.image {
                switch position {
                case 0..<imageViews.count:
                    urlImageSet(imageView: imageViews[position], photoData: photoString)
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
    func zoomToRedLineAreaSmooth(imageView: UIImageView) {
        let targetRect = CGRect(x: 0.05, y: 0.9, width: 0.6, height: 0.1)
        let animation = CABasicAnimation(keyPath: "contentsRect")
        animation.fromValue = imageView.layer.contentsRect
        animation.toValue = targetRect
        animation.duration = 8.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true             // 元に戻す
        animation.repeatCount = .infinity         // 無限ループ！
        imageView.layer.add(animation, forKey: "zoomContentsRect")
        // 実際の表示も変える
        imageView.layer.contentsRect = targetRect
    }
    func resetZoom(imageView: UIImageView) {
        UIView.animate(withDuration: 0.8) {
            imageView.transform = .identity
        }
    }
    func showAlert() {
        let alert = UIAlertController(title: "お知らせです", message: "エラーです", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//
//  CinkuroJokyuVIewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/04/22.
//

import Foundation
import UIKit
import Alamofire
class introduceViewController: UIViewController {
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
    @IBOutlet weak var textView8: UITextView!
    @IBOutlet weak var textViewHeihtConst: NSLayoutConstraint!
    @IBOutlet weak var textViewHeihtConst2: NSLayoutConstraint!
    @IBOutlet weak var textViewHeihtConst3: NSLayoutConstraint!
    @IBOutlet weak var textView4HeightConst4: NSLayoutConstraint!
    @IBOutlet weak var textView4HeightConst5: NSLayoutConstraint!
    @IBOutlet weak var textView4HeightConst6: NSLayoutConstraint!
    @IBOutlet weak var textView4HeightConst7: NSLayoutConstraint!
    @IBOutlet weak var textView4HeightConst8: NSLayoutConstraint!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var parentView1: UIView!
    @IBOutlet weak var parentView2: UIView!
    @IBOutlet weak var parentView3: UIView!
    @IBOutlet weak var zoomButton1: UIButton!
    @IBOutlet weak var zoomButton2: UIButton!
    @IBOutlet weak var zoomButton3: UIButton!
    
    var kategori: String?
    var databox: [texts]?
    var textViews: [UITextView] = []
    var imageViews: [UIImageView] = []
    var isZoomedIn = false
    var constraintMap:[UITextView:NSLayoutConstraint] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print(kategori)
        fetchData()
        super.viewDidAppear(animated)
        textViews = [textView1,textView2,textView3,textView4,textView5,textView6,textView7,textView8]
        imageViews = [imageView,imageView2,imageView3,imageView4]
        constraintMap = [textView1: textViewHeihtConst,
                         textView2: textViewHeihtConst2,
                         textView3: textViewHeihtConst3,
                         textView4: textView4HeightConst4,
                         textView5: textView4HeightConst5,
                         textView6: textView4HeightConst6,
                         textView7: textView4HeightConst7,
                         textView8: textView4HeightConst8]
        parentView1.bringSubviewToFront(zoomButton1)
        parentView2.bringSubviewToFront(zoomButton2)
        parentView3.bringSubviewToFront(zoomButton3)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            for tv in self.textViews {
                textViewsCustom(textView: tv)
            
        }
    }
    func textViewsCustom(textView: UITextView) {
        
        let height = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        if let constraint = constraintMap[textView] {
                constraint.constant = height
            }
        textView.layer.cornerRadius = 12
        textView.backgroundColor = UIColor(white: 1.0, alpha: 0.8) // 半透明でクール
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        textView.layer.masksToBounds = true
        
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16) // 内側の余白
        textView.isEditable = false
        textView.isScrollEnabled = false
    }
    func fetchData() {
        let fetchDataObj = fetchTextData()
        fetchDataObj.fecthViewData(kategori: kategori!, dataContent: "サブデータ") { [weak self] decodedObj,bool in
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
    func Dataset(texts: [texts]) {
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
            
            if let photoString = textbox.photo {
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
        let url = URL(string: photoData)
        do {
            imageView.sd_setImage(with:url)
        } catch {
            print("Error : Cat't get image")
        }
    }
    func zoomToRedLineAreaSmooth(imageView: UIImageView,toggle: Bool) {
            let targetRect = CGRect(x: 0.01, y: 0.9, width: 0.8, height: 0.1)
            let zoomOutRect = CGRect(x: 0, y: 0, width: 1, height: 1)
            let animation = CABasicAnimation(keyPath: "contentsRect")
            animation.fromValue = imageView.layer.contentsRect //可変の値
            animation.toValue = toggle ? targetRect : zoomOutRect
            animation.duration = 2.0
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            imageView.layer.add(animation, forKey: "zoomContentsRect")
            // 実際の表示も変える
        imageView.layer.contentsRect = toggle ? targetRect : zoomOutRect
        
    }
    @IBAction func imageDidTatch(_ sender: UIButton) {
        // 今の画像名に応じて切り替え
        isZoomedIn.toggle()
        let imageName = isZoomedIn ? "minus.magnifyingglass" : "plus.magnifyingglass"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        if let parentView = (sender as AnyObject).superview {
            for subview in parentView!.subviews {
                    if let imageView = subview as? UIImageView {
                        // ここでimageViewを取り出せた！
                        zoomToRedLineAreaSmooth(imageView: imageView,toggle: isZoomedIn)
                        // たとえばここで何かする
                       
                    }
                }
            }
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

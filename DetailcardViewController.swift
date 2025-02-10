//
//  Detailbook.swift
//  yuugioh
//
//  Created by 高橋沙久哉 on 2025/01/17.
//

import Foundation
import UIKit
class DetailCard: UIViewController {
    var cardData: cards?
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = cardData?.trueName
        ImageUrl()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func ImageUrl() {
        //ここで、urlを画像に表示させる
        do{
            imageView.sd_setImage(with:UserInfo.shared.imageUrls![UserInfo.shared.indexPath])
        } catch {
            print("Error : Cat't get image")
        }
    }
}

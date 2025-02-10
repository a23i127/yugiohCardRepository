//
//  CardCell.swift
//  yuugioh
//
//  Created by 高橋沙久哉 on 2024/12/06.
//

import Foundation
import UIKit
import SDWebImage
class CardCell: UICollectionViewCell {
    @IBOutlet weak var cardImage: UIImageView!
    func configure(card: cards?) {
        if card == nil {
            print("通信していない")
            return }
     let url = URL(string: card!.imageUrl)
     do {
         cardImage.sd_setImage(with:url)
     } catch {
         print("Error : Cat't get image")
     }
     
     }
}

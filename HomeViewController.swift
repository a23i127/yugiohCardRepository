//
//  TableViewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/04/03.
//

import Foundation
import UIKit
struct ImageData {
    var background: String    // 画像の名前（Asset名）
    var title: String
    var identifer: String    // 表示するタイトル
}
let imageArray: [ImageData] = [
    ImageData(background: "upscalemedia-transformed", title: "IMG_5070", identifer: "toZeal"),
    ImageData(background: "fusion", title: "IMG_5072", identifer: "toGX"),
    ImageData(background: "sinkuro", title: "IMG_5090", identifer: "to5Dis"),
    ImageData(background: "Ark5", title: "IMG_5077", identifer: "toArk5"),
    ImageData(background: "saybar", title: "IMG_5078", identifer: "Torink")
]
class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //今回はとりあえず12とする。（配列に表示させたいデータを入れている場合は配列のデータ数を返せば良い。）
       
        return 5
    }
    //セルに表示する内容を記載する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCel",for: indexPath)
        let imageDatas = imageArray[indexPath.row]
         if let cell = cell as? imageDataCell//ダウンキャスト(継承時のインスタンス化は、注意)
         {
             cell.configure(imageData:imageDatas)
         }
        return cell
    }
    //セルのサイズを指定する処理
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10 // セル間の間隔
        let numberOfItemsPerRow: CGFloat = 4 // 1行に表示するセルの数
        let totalPadding = padding * (numberOfItemsPerRow + 1)//全体の余白を計算
        //Viewの中に表示させるcellの大きさを指定
        let individualWidth = (collectionView.frame.width - totalPadding) / numberOfItemsPerRow
        return CGSize(width: individualWidth, height: individualWidth+20) // 長方形のセル
    }
    //セル選択時の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserInfo.shared.indexPath = indexPath.row
        self.performSegue(withIdentifier: imageArray[indexPath.row].identifer, sender: nil)
        
    }
}

class imageDataCell: UICollectionViewCell {
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    var identifer :String!
    func configure(imageData: ImageData) {
        imageView1.image = UIImage(named: imageData.background)
        imageView2.image = UIImage(named: imageData.title)
        identifer = imageData.identifer
    }
}

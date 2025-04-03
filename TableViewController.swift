//
//  TableViewController.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/04/03.
//

import Foundation
import UIKit
struct ImageData {
    var aikon: String    // 画像の名前（Asset名）
    var title: String    // 表示するタイトル
}
let imageArray: [ImageData] = [
    ImageData(aikon: "IMG_5072", title: "IMG_5070"),
    ImageData(aikon: "IMG_5068", title: "IMG_5072")
]
class TableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       //cellに値を設定する(numberOfRows(cellの個数)分だけ呼び出される)
       let cell  = tableView.dequeueReusableCell(withIdentifier: "imageViewCell",for: indexPath)
       let imageDatas = imageArray[indexPath.row]
        if let cell = cell as? imageDataCell//ダウンキャスト(継承時のインスタンス化は、注意)
        {
            cell.configure(imageData:imageDatas)
        }
       return cell //再利用可能なセルを作った
   }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       //ここに行数を返す
           return 2
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //cellが選択(タップ)された時に呼び出された時の処理(個数分だけ呼び出される)
       UserInfo.shared.indexPath = indexPath.row
       //letここpr
       self.performSegue(withIdentifier: "toZeal", sender: nil)
   }
}

class imageDataCell: UITableViewCell {
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    func configure(imageData: ImageData) {
        imageView1.image = UIImage(named: imageData.aikon)
        imageView2.image = UIImage(named: imageData.title)
        
    }
}

//
//  Detailbook.swift
//  yuugioh
//
//  Created by 高橋沙久哉 on 2025/01/17.
//

import Foundation
import UIKit
class DetailCard: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    var cardData: cards?
    var anyCards: [cards]?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView2: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageUrl()
    }
    override func viewDidAppear(_ animated: Bool) {
        let fetchCardInstance = fetchCardData()
        fetchCardInstance.fecthCard() { [weak self] cards,result in
            guard let self = self else { return }
            switch result {
            case true:
                self.anyCards = cards
                self.collectionView2.reloadData()
                //更新
            case false: self.showAlert()
            }
        }
    }
    func conditionalSearch() {
        let fetchCardInstance = fetchCardData()
        fetchCardInstance.conditionalSearch(card: cardData) { [weak self] cards,result in
                guard let self = self else { return }
                switch result {
                case true:
                    self.anyCards = cards
                    self.collectionView2.reloadData()
                    //更新
                case false: self.showAlert()
                }
        }
    }
    func ImageUrl() {
        //ここで、urlを画像に表示させる
        do{
            let url = URL(string: cardData!.imageUrl)
            imageView.sd_setImage(with: url)
        } catch {
            print("Error : Cat't get image")
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //今回はとりあえず12とする。（配列に表示させたいデータを入れている場合は配列のデータ数を返せば良い。）
        return anyCards?.count ?? 0
    }
    //セルに表示する内容を記載する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "anyCards", for:  indexPath)
        //セル上のTag(1)とつけたUILabelを生成
        let cardObj = anyCards?[indexPath.row]
        let castingCell = cell as? CardCell
        guard let castingCell else {
            self.showAlert()
            return  cell }
        UserInfo.shared.indexPath = indexPath.row
        castingCell.configure2(card:cardObj)
        //今回は簡易的にセルの番号をラベルのテキストに反映させる
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
        self.cardData = self.anyCards![indexPath.row]
        self.ImageUrl()
        self.conditionalSearch()
        self.collectionView2.reloadData()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "お知らせです", message: "エラーです", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//
//  ViewController.swift
//  yuugioh
//
//  Created by 高橋沙久哉 on 2024/12/02.
//

import UIKit
import Alamofire
import SDWebImage
class FirstViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITabBarDelegate {
    var card: [cards]?
    @IBOutlet weak var seachTextFirld: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabVar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabVar.delegate = self
        self.seachTextFirld.placeholder = "カード名を入力"
        NotificationCenter.default.addObserver(self, selector: #selector(HandleDismiss(_:)), name: NSNotification.Name("検索完了"), object: nil)
    }
    //ローカルサーバーでもstructの内容をコーディングする
    override func viewDidAppear(_ animated: Bool) {
        if card == nil{
            let fetchCardInstance = fetchCardData()
            fetchCardInstance.fecthCard() { [weak self] cards,result in
                guard let self = self else { return }
                switch result {
                case true:
                    for item in cards! {
                        UserInfo.shared.imageUrls?.append(URL(string:item.imageUrl)!)
                    }
                    SDWebImagePrefetcher.shared.prefetchURLs(UserInfo.shared.imageUrls!)
                    self.card = cards
                    self.collectionView.reloadData()
                    //更新
                case false: self.showAlert()
                }
            }
        }
    }
    @objc func HandleDismiss(_ notification: Notification) {
    guard let value = notification.object as? [cards],!value.isEmpty else { return }
        self.card = value
        self.collectionView.reloadData()
    }
    @IBAction func searchAction(_ sender: Any) {
        guard let textString = self.seachTextFirld.text else { return }
        //Getに対してparametersをつけようとすると、urlクエリにparametersが自動で組み込まれる.==urlクエリに、jsonencoderすると、Jsonが、urlの中にあってだめ
        //getリクエストでは、ボディを指定できない
        AF.request("**",method: .get,parameters: ["name":textString],encoding:URLEncoding.default).response { response in
            guard let data = response.data else { return }
            print(String(data: data, encoding: .utf8))
            let decoder = JSONDecoder()
            do {
                let searchResult = try decoder.decode([cards].self, from: data)
                self.card = searchResult
                self.collectionView.reloadData()
            }
            catch {
                
            }
        }
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag{
        case 0:
            print("0") // カレンダーアイコンをタップした場合
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "Main")
            nextView.modalPresentationStyle = .formSheet
            present(nextView, animated: true, completion: nil)
        case 1:
            print("1") // 設定アイコンをタップした場合
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "Config")
            nextView.modalPresentationStyle = .formSheet
            present(nextView, animated: true, completion: nil)
        default : return
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // segueの識別子を確認
        if segue.identifier == "DetailCard" {
            if let destinationView = segue.destination as? DetailCard {
                destinationView.cardData = self.card![UserInfo.shared.indexPath]
            }
        }
    }
    //セクションの中のセルの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //今回はとりあえず12とする。（配列に表示させたいデータを入れている場合は配列のデータ数を返せば良い。）
        print(card?.count)
        return card?.count ?? 0
    }
    //セルに表示する内容を記載する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for:  indexPath)
        //セル上のTag(1)とつけたUILabelを生成
        let cardObj = card?[indexPath.row]
        let castingCell = cell as? CardCell
        guard let castingCell else {
            self.showAlert()
            return  cell }
        UserInfo.shared.indexPath = indexPath.row
        castingCell.configure(card:cardObj)
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
        self.performSegue(withIdentifier: "DetailCard", sender: nil)
        
    }
    func showAlert() {
        let alert = UIAlertController(title: "お知らせです", message: "エラーです", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


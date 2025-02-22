//
//  filterMenu.swift
//  YugiohProject
//
//  Created by 高橋沙久哉 on 2025/02/19.
//

import Foundation
import UIKit
class filterMenu: UIViewController {
    @IBOutlet weak var scrollOfsubView: UIView!
    var buttunArray:[UIButton] = []
    var parametersDic : [String : [String]] = [:]
    var kategoriArray = ["通常","効果","儀式","融合","シンクロ","エクシーズ","ペンデュラム","リンク"]
    var attributeArray = ["火属性","水属性","風属性","地属性","光属性","闇属性","神属性"]
    var raceArray = ["ドラゴン族","悪魔族","海竜族","機械族","恐竜族","獣族","植物族","戦士族","天使族","雷族","サイキック族","サイバース族","アンデット族","炎族","岩石族","魚族","昆虫族","獣戦士族","水族","鳥獣族","魔法使い族","爬虫類族","幻竜族","幻神獣族"]
    var levelArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    var rankArray = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13"]
    var rinkArray = ["1","2","3","4","5","6"]
    override func viewDidLoad() {
        super.viewDidLoad()
        print(raceArray.count)
        createTitleLabel(x: 50, y: 50, width: 200, height: 50, text: "カード種類")
        createButtun(x: 50, y: 100, buttonWidth: 100, buttonHeight: 25, array: kategoriArray, buttonSpacing: 30,createButtunCount: 8 ,buttonsPerColumn: 4,parameterKey: "description")//parameterKeyは、サーバーのカラム名
        createTitleLabel(x: 50, y: 210, width: 200, height: 50, text: "属性")
        createButtun(x: 50, y: 250, buttonWidth: 100, buttonHeight: 25, array: attributeArray, buttonSpacing: 30, createButtunCount: 7,buttonsPerColumn: 4,parameterKey: "attribute")
        createTitleLabel(x: 50, y: 370, width: 200, height: 50, text: "種族")
        createButtun(x: 50, y: 410, buttonWidth: 100, buttonHeight: 25, array: raceArray, buttonSpacing: 30, createButtunCount: 24,buttonsPerColumn: 12,parameterKey: "race")
        createTitleLabel(x: 50, y: 770, width: 200, height: 50, text: "レベル")
        createButtun(x: 50, y: 810, buttonWidth: 100, buttonHeight: 25, array: levelArray, buttonSpacing: 30, createButtunCount: 12,buttonsPerColumn: 6,parameterKey: "level")
        createTitleLabel(x: 50, y: 980, width: 200, height: 50, text: "ランク")
        createButtun(x: 50, y: 1020, buttonWidth: 100, buttonHeight: 25, array: rankArray, buttonSpacing: 30, createButtunCount: 14,buttonsPerColumn: 7,parameterKey: "level")
        createTitleLabel(x: 50, y: 1220, width: 200, height: 50, text: "リンク")
        createButtun(x: 50, y: 1260, buttonWidth: 100, buttonHeight: 25, array: rinkArray, buttonSpacing: 30, createButtunCount: 6,buttonsPerColumn: 3,parameterKey: "rink")
    }
    @objc func tapedButton(_ sender: UIButton) {
        if sender.backgroundColor == .blue {
            return deleteButtun(sender: sender)
        }
        selectButtun(sender: sender)
    }
    func deleteButtun(sender: UIButton) {
        sender.layer.borderColor = UIColor.black.cgColor
        sender.backgroundColor = .white
        if let value = parametersDic[sender.accessibilityIdentifier!] {
            removeValueOfArray(array: &parametersDic[sender.accessibilityIdentifier!]!, value:  sender.title(for: .normal)!)
            if parametersDic[sender.accessibilityIdentifier!]!.count == 0 {
                parametersDic.removeValue(forKey: sender.accessibilityIdentifier!)
            }
            print(parametersDic)
        }
    }
    func selectButtun(sender:UIButton) {//  ["name":"["クリボー","真紅眼の黒龍"],"level":["1","7"]]のようなdictionaryを作る
        sender.layer.borderColor = UIColor.red.cgColor
        sender.backgroundColor = .blue
        let title = sender.title(for: .normal)
        if parametersDic[sender.accessibilityIdentifier!] == nil{   //[string:[string]]のため、値を参照するには空配列だとクラッシュする
            parametersDic[sender.accessibilityIdentifier!] = []
        }
        parametersDic[sender.accessibilityIdentifier!]?.insert(title!, at: 0)
        print(parametersDic)
    }
    func createButtun(x: Int,y: Int,buttonWidth: Int,buttonHeight: Int,array: [String],buttonSpacing: Int,createButtunCount: Int,buttonsPerColumn: Int,parameterKey: String) {
        var xOffset = x
        var yOffset = y
        for i in 0..<createButtunCount { // ボタン数は10個にして例示
            let button = UIButton(type: .system)
            button.frame = CGRect(x: xOffset, y: yOffset, width: buttonWidth, height: buttonHeight)
            button.tag = i
            button.setTitle(array[i], for: .normal)
            button.accessibilityIdentifier = parameterKey //サーバーのカラム名をidentiferに設定する
            button.titleLabel?.adjustsFontSizeToFitWidth = true //自動でfont
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(tapedButton), for: .touchUpInside)
            scrollOfsubView.addSubview(button)
            buttunArray.append(button)
            // 次のボタンのY座標を更新
            yOffset += buttonSpacing
            // buttonsPerColumnに達したら新しい列に移動
            if (i + 1) % buttonsPerColumn == 0 {
                xOffset += buttonWidth + 20 // 次の列に移動（ボタンの幅 + 余白）
                yOffset = y // Y座標を初期位置にリセット
            }
        }
    }
    func createTitleLabel(x: Int,y: Int,width: Int,height: Int,text: String){
        let label = UILabel()
        label.frame = CGRect(x: x,y: y,width: width,height: height)
        label.text = text
        scrollOfsubView.addSubview(label)
    }
    func removeValueOfArray(array: inout [String], value: String) {
        if let index = array.firstIndex(of: value) {
            array.remove(at: index)
        }
    }
}


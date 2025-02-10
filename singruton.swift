
import Foundation
// ユーザ情報保持するクラス
final class UserInfo {
    // インスタンスを参照するためのプロパティ
    static let shared = UserInfo()
    var indexPath: Int!
    var imageUrls: [URL]?=[]
    // イニシャライズ
    private init() {}
    // ユーザ情報セットメソッド
    
    
}

import Foundation

class LocalStorage {
    
    static let X_SCORE = "x_score"
    static let O_SCORE = "o_score"
    static let GAME = "game"
    
    static func value<T>(defaultValue: T, forKey key: String) -> T{
            let preferences = UserDefaults.standard
            return preferences.object(forKey: key) == nil ? defaultValue : preferences.object(forKey: key) as! T
        }

        static func value(value: Any, forKey key: String){
            UserDefaults.standard.set(value, forKey: key)
        }

}

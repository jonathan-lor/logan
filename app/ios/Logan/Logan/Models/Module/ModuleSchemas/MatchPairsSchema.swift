import Foundation

struct MatchPairsSchema: Decodable {
        let question: String 
        let answer: [String : String] 
}

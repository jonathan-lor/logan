//
//  Module.swift
//  Logan
//
//  Created by jon on 2/7/26.
//

import Foundation

struct Module: Decodable, Identifiable {
    let id = UUID()
    let type: Kind
    let tags: [String]
    let data: DataPayload

    enum Kind: String, Decodable {
        case multipleChoice = "MultipleChoice"
        case trueOrFalse = "TrueOrFalse"
        case orderedList = "OrderedList"
        case matchPairs = "MatchPairs"
        case guessWord = "GuessWord"
        case twoTruthsAndLie = "TwoTruthsAndLie"
        case whichCameFirst = "WhichCameFirst"
    }

    enum CodingKeys: String, CodingKey {
        case type
        case tags
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let kind = try container.decode(Kind.self, forKey: .type)
        self.type = kind
        self.tags = try container.decode([String].self, forKey: .tags)

        switch kind {
        case .multipleChoice:
            let mc = try container.decode(MultipleChoiceSchema.self, forKey: .data)
            self.data = .multipleChoice(mc)
        case .trueOrFalse:
            let tf = try container.decode(TrueOrFalseSchema.self, forKey: .data)
            self.data = .trueOrFalse(tf)
        case .orderedList:
            let ol = try container.decode(OrderedListSchema.self, forKey: .data)
            self.data = .orderedList(ol)
        case .matchPairs:
            let mp = try container.decode(MatchPairsSchema.self, forKey: .data)
            self.data = .matchPairs(mp)
        case .guessWord:
            let gw = try container.decode(GuessWordSchema.self, forKey: .data)
            self.data = .guessWord(gw)
        case .twoTruthsAndLie:
            let tt = try container.decode(TwoTruthsAndLieSchema.self, forKey: .data)
            self.data = .twoTruthsAndLie(tt)
        case .whichCameFirst:
            let wc = try container.decode(WhichCameFirstSchema.self, forKey: .data)
            self.data = .whichCameFirst(wc)
        }
    }
}

enum DataPayload: Decodable {
    case multipleChoice(MultipleChoiceSchema)
    case trueOrFalse(TrueOrFalseSchema)
    case orderedList(OrderedListSchema)
    case matchPairs(MatchPairsSchema)
    case guessWord(GuessWordSchema)
    case twoTruthsAndLie(TwoTruthsAndLieSchema)
    case whichCameFirst(WhichCameFirstSchema)
}

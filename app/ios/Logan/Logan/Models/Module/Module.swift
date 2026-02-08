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
        // will be more here
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case tags
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // decode the discriminator first
        let kind = try container.decode(Kind.self, forKey: .type)
        self.type = kind
        self.tags = try container.decode([String].self, forKey: .tags)
        
        // decode "data" field using discriminator
        switch kind {
        case .multipleChoice:
            let mc = try container.decode(MultipleChoiceSchema.self, forKey: .data)
            self.data = .multipleChoice(mc)
        }
    }
}

enum DataPayload: Decodable {
    case multipleChoice(MultipleChoiceSchema)
}

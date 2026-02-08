//
//  MultipleChoiceSchema.swift
//  Logan
//
//  Created by jon on 2/7/26.
//

import Foundation

struct MultipleChoiceSchema: Decodable {
    let question: String
    let answer: [Answer]

}

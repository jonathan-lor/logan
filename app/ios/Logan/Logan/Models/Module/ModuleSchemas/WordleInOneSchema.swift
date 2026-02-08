//
//  WordleInOneSchema.swift
//  Logan
//
//  Created by jon on 2/7/26.
//
import Foundation

struct WordleInOneSchema: Decodable {
    let incorrectGuess: IncorrectGuess
    let answer: String
    
    struct IncorrectGuess: Decodable {
        let word: String
        let values: [Letter]

        struct Letter: Decodable {
                let character: String
                let value: Int
        }
    }
}

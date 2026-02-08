//
//  TestData.swift
//  Logan
//
//  Created by jon on 2/7/26.
//


// a bunch of hardcoded test data for debugging
struct TestData {
    static let multipleChoiceJson = """
    
    {
                "type": "MultipleChoice",
                "tags": [
                    "Pokemon",
                    "Pokedex",
                    "Video Games"
                ],
                "data": {
                    "question": "Which Pokémon is officially listed as the first entry (#001) in the National Pokédex?",
                    "answers": [
                        {
                            "content": "Bulbasaur",
                            "correct": true
                        },
                        {
                            "content": "Charmander",
                            "correct": false
                        },
                        {
                            "content": "Squirtle",
                            "correct": false
                        },
                        {
                            "content": "Pikachu",
                            "correct": false
                        }
                    ]
                }
            }
    
    """
}

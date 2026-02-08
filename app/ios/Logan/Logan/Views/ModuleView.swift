//
//  ModuleView.swift
//  Logan
//
//  Created by jon on 2/7/26.
//

import SwiftUI

struct ModuleView: View {
    let module: Module
    @State private var selectedAnswer: String? = nil
    @State private var orderedItems: [String] = []
    @State private var matchSelections: [String: String] = [:]
    @State private var guessText: String = ""
    @State private var guessSubmitted = false
    @State private var selectedPairLeft: String? = nil

    private var isCompleted: Bool {
        selectedAnswer != nil || guessSubmitted || matchSelections.count == matchPairsCount
    }

    // Stored on appear so we can check match completion without the schema
    @State private var matchPairsCount: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            switch module.data {
            case .multipleChoice(let mc):
                multipleChoiceView(mc)
            case .trueOrFalse(let tf):
                trueOrFalseView(tf)
            case .orderedList(let ol):
                orderedListView(ol)
            case .matchPairs(let mp):
                matchPairsView(mp)
                    .onAppear { matchPairsCount = mp.answer.count }
            case .guessWord(let gw):
                guessWordView(gw)
            case .twoTruthsAndLie(let tt):
                twoTruthsAndLieView(tt)
            case .whichCameFirst(let wc):
                whichCameFirstView(wc)
            }

            if isCompleted {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        reset()
                    }
                } label: {
                    Label("Try Again", systemImage: "arrow.counterclockwise")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func reset() {
        selectedAnswer = nil
        guessText = ""
        guessSubmitted = false
        matchSelections = [:]
        selectedPairLeft = nil
        // Re-shuffle ordered list
        if case .orderedList(let ol) = module.data {
            orderedItems = ol.answer.shuffled()
        }
    }

    // MARK: - Multiple Choice

    private func multipleChoiceView(_ mc: MultipleChoiceSchema) -> some View {
        VStack(spacing: 24) {
            Text(mc.question)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                ForEach(mc.answer, id: \.content) { answer in
                    answerButton(answer)
                }
            }
        }
        .padding(.horizontal, 24)
    }

    // MARK: - True or False

    private func trueOrFalseView(_ tf: TrueOrFalseSchema) -> some View {
        VStack(spacing: 24) {
            Text(tf.question)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            HStack(spacing: 16) {
                ForEach(["True", "False"], id: \.self) { option in
                    let isCorrect = (option == "True") == tf.answer
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedAnswer = option
                        }
                    } label: {
                        Text(option)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(tfBackground(option: option, isCorrect: isCorrect))
                            .foregroundStyle(tfForeground(option: option, isCorrect: isCorrect))
                            .cornerRadius(12)
                    }
                    .disabled(selectedAnswer != nil)
                }
            }
        }
        .padding(.horizontal, 24)
    }

    private func tfBackground(option: String, isCorrect: Bool) -> Color {
        guard let selected = selectedAnswer else { return Color(.systemGray5) }
        if option == selected {
            return isCorrect ? .green : .red
        }
        if isCorrect { return .green.opacity(0.3) }
        return Color(.systemGray5)
    }

    private func tfForeground(option: String, isCorrect: Bool) -> Color {
        guard let selected = selectedAnswer else { return .primary }
        if option == selected || isCorrect { return .white }
        return .primary
    }

    // MARK: - Which Came First

    private func whichCameFirstView(_ wc: WhichCameFirstSchema) -> some View {
        VStack(spacing: 24) {
            Text(wc.question)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                ForEach(wc.answer, id: \.content) { answer in
                    answerButton(answer)
                }
            }
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Two Truths and a Lie

    private func twoTruthsAndLieView(_ tt: TwoTruthsAndLieSchema) -> some View {
        VStack(spacing: 24) {
            Text("Two Truths and a Lie")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Find the lie!")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(spacing: 12) {
                ForEach(tt.answer, id: \.content) { answer in
                    // In two truths and a lie, the "correct" answer is the lie
                    answerButton(answer)
                }
            }
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Ordered List

    private func orderedListView(_ ol: OrderedListSchema) -> some View {
        VStack(spacing: 24) {
            Text(ol.question)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            VStack(spacing: 8) {
                ForEach(Array(orderedItems.enumerated()), id: \.offset) { index, item in
                    HStack {
                        Text("\(index + 1).")
                            .font(.headline)
                            .frame(width: 30)

                        Text(item)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if !guessSubmitted {
                            VStack(spacing: 4) {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        guard index > 0 else { return }
                                        orderedItems.swapAt(index, index - 1)
                                    }
                                } label: {
                                    Image(systemName: "chevron.up")
                                        .font(.caption)
                                }
                                .disabled(index == 0)

                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        guard index < orderedItems.count - 1 else { return }
                                        orderedItems.swapAt(index, index + 1)
                                    }
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                }
                                .disabled(index == orderedItems.count - 1)
                            }
                        } else {
                            let correctIndex = ol.answer.firstIndex(of: item)
                            if correctIndex == index {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                }
            }

            if !guessSubmitted {
                Button("Submit Order") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        guessSubmitted = true
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .cornerRadius(12)
            } else {
                let correct = orderedItems == ol.answer
                Text(correct ? "Correct!" : "Not quite — check the order above.")
                    .font(.headline)
                    .foregroundStyle(correct ? .green : .red)
            }
        }
        .padding(.horizontal, 24)
        .onAppear {
            if orderedItems.isEmpty {
                orderedItems = ol.answer.shuffled()
            }
        }
    }

    // MARK: - Match Pairs

    private func matchPairsView(_ mp: MatchPairsSchema) -> some View {
        let keys = Array(mp.answer.keys).sorted()
        let values = Array(mp.answer.values).sorted()

        return VStack(spacing: 24) {
            Text(mp.question)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            HStack(alignment: .top, spacing: 16) {
                // Left column — keys
                VStack(spacing: 12) {
                    ForEach(keys, id: \.self) { key in
                        Button {
                            selectedPairLeft = key
                        } label: {
                            Text(key)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedPairLeft == key ? Color.blue.opacity(0.3) : Color(.systemGray5))
                                .foregroundStyle(.primary)
                                .cornerRadius(12)
                        }
                        .disabled(matchSelections[key] != nil)
                    }
                }

                // Right column — values
                VStack(spacing: 12) {
                    ForEach(values, id: \.self) { value in
                        Button {
                            if let left = selectedPairLeft {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    matchSelections[left] = value
                                    selectedPairLeft = nil
                                }
                            }
                        } label: {
                            Text(value)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(matchValueBackground(value, correct: mp.answer))
                                .foregroundStyle(.primary)
                                .cornerRadius(12)
                        }
                        .disabled(matchSelections.values.contains(value))
                    }
                }
            }

            if matchSelections.count == mp.answer.count {
                let allCorrect = matchSelections.allSatisfy { mp.answer[$0.key] == $0.value }
                Text(allCorrect ? "All matched correctly!" : "Some pairs are wrong.")
                    .font(.headline)
                    .foregroundStyle(allCorrect ? .green : .red)
            }
        }
        .padding(.horizontal, 24)
    }

    private func matchValueBackground(_ value: String, correct: [String: String]) -> Color {
        if let matchedKey = matchSelections.first(where: { $0.value == value })?.key {
            return correct[matchedKey] == value ? .green.opacity(0.3) : .red.opacity(0.3)
        }
        return Color(.systemGray5)
    }

    // MARK: - Guess Word

    private func guessWordView(_ gw: GuessWordSchema) -> some View {
        VStack(spacing: 24) {
            Text(gw.question)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            TextField("Type your answer...", text: $guessText)
                .textFieldStyle(.roundedBorder)
                .font(.body)
                .disabled(guessSubmitted)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            if !guessSubmitted {
                Button("Submit") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        guessSubmitted = true
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .cornerRadius(12)
            } else {
                let correct = guessText.trimmingCharacters(in: .whitespacesAndNewlines)
                    .lowercased() == gw.answer.lowercased()
                VStack(spacing: 8) {
                    Text(correct ? "Correct!" : "Not quite.")
                        .font(.headline)
                        .foregroundStyle(correct ? .green : .red)
                    if !correct {
                        Text("Answer: \(gw.answer)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Shared Answer Button

    private func answerButton(_ answer: Answer) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                selectedAnswer = answer.content
            }
        } label: {
            Text(answer.content)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor(for: answer))
                .foregroundStyle(foregroundColor(for: answer))
                .cornerRadius(12)
        }
        .disabled(selectedAnswer != nil)
    }

    private func backgroundColor(for answer: Answer) -> Color {
        guard let selected = selectedAnswer else { return Color(.systemGray5) }
        if answer.content == selected {
            return answer.correct ? .green : .red
        }
        if answer.correct { return .green.opacity(0.3) }
        return Color(.systemGray5)
    }

    private func foregroundColor(for answer: Answer) -> Color {
        guard let selected = selectedAnswer else { return .primary }
        if answer.content == selected || answer.correct { return .white }
        return .primary
    }
}

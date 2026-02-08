//
//  ModuleView.swift
//  Logan
//
//  Created by jon on 2/7/26.
//

import SwiftUI

// MARK: - Neo-Brutalist Style Constants

private enum Brutal {
    static let border: CGFloat = 3
    static let shadow: CGFloat = 5
    static let radius: CGFloat = 4
    static let cream = Color(red: 1.0, green: 0.99, blue: 0.95)
    static let black = Color.black
    static let white = Color.white
    static let green = Color(red: 0.29, green: 0.87, blue: 0.50)
    static let red = Color(red: 1.0, green: 0.42, blue: 0.42)
    static let yellow = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let blue = Color(red: 0.35, green: 0.55, blue: 1.0)
    static let pink = Color(red: 1.0, green: 0.56, blue: 0.68)
    static let purple = Color(red: 0.69, green: 0.53, blue: 1.0)
}

private struct BrutalCard: ViewModifier {
    var fill: Color = Brutal.white
    func body(content: Content) -> some View {
        content
            .background(fill)
            .clipShape(RoundedRectangle(cornerRadius: Brutal.radius))
            .overlay(
                RoundedRectangle(cornerRadius: Brutal.radius)
                    .stroke(Brutal.black, lineWidth: Brutal.border)
            )
            .background(
                RoundedRectangle(cornerRadius: Brutal.radius)
                    .fill(Brutal.black)
                    .offset(x: Brutal.shadow, y: Brutal.shadow)
            )
    }
}

private struct BrutalButton: ViewModifier {
    var fill: Color = Brutal.white
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(Brutal.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .modifier(BrutalCard(fill: fill))
    }
}

private extension View {
    func brutalCard(fill: Color = Brutal.white) -> some View {
        modifier(BrutalCard(fill: fill))
    }
    func brutalButton(fill: Color = Brutal.white) -> some View {
        modifier(BrutalButton(fill: fill))
    }
}

// MARK: - Haptics

private enum Haptic {
    static func tap() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}

// MARK: - ModuleView

struct ModuleView: View {
    let module: Module
    @State private var selectedAnswer: String? = nil
    @State private var orderedItems: [String] = []
    @State private var matchSelections: [String: String] = [:]
    @State private var guessSubmitted = false
    @State private var selectedPairLeft: String? = nil

    private var isCompleted: Bool {
        selectedAnswer != nil || guessSubmitted || (matchPairsCount > 0 && matchSelections.count == matchPairsCount)
    }

    @State private var matchPairsCount: Int = 0

    var body: some View {
        VStack(spacing: 20) {
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
            case .twoTruthsAndLie(let tt):
                twoTruthsAndLieView(tt)
            case .whichCameFirst(let wc):
                whichCameFirstView(wc)
            }

            if isCompleted {
                explanationCard

                Button {
                    Haptic.light()
                    withAnimation(.easeInOut(duration: 0.25)) {
                        reset()
                    }
                } label: {
                    Label("Try Again", systemImage: "arrow.counterclockwise")
                        .font(.subheadline)
                        .fontWeight(.black)
                        .foregroundStyle(Brutal.black)
                }
            }
        }
    }

    private func reset() {
        selectedAnswer = nil
        guessSubmitted = false
        matchSelections = [:]
        selectedPairLeft = nil
        if case .orderedList(let ol) = module.data {
            orderedItems = ol.answer.shuffled()
        }
    }

    // MARK: - Explanation

    private var explanationCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("EXPLANATION")
                .font(.caption)
                .fontWeight(.black)
                .tracking(2)
                .foregroundStyle(Brutal.black)

            Text(module.explanation)
                .font(.subheadline)
                .foregroundStyle(Brutal.black)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .brutalCard(fill: Brutal.cream)
        .padding(.horizontal, 24)
    }

    // MARK: - Question Header

    private func questionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .fontWeight(.black)
            .multilineTextAlignment(.center)
            .foregroundStyle(Brutal.black)
    }

    // MARK: - Multiple Choice

    private func multipleChoiceView(_ mc: MultipleChoiceSchema) -> some View {
        VStack(spacing: 16) {
            questionHeader(mc.question)

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
        VStack(spacing: 16) {
            questionHeader(tf.question)

            HStack(spacing: 14) {
                ForEach(["True", "False"], id: \.self) { option in
                    let isCorrect = (option == "True") == tf.answer
                    Button {
                        Haptic.tap()
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedAnswer = option
                        }
                    } label: {
                        Text(option)
                            .brutalButton(fill: tfBackground(option: option, isCorrect: isCorrect))
                    }
                    .disabled(selectedAnswer != nil)
                }
            }
        }
        .padding(.horizontal, 24)
    }

    private func tfBackground(option: String, isCorrect: Bool) -> Color {
        guard let selected = selectedAnswer else { return Brutal.white }
        if option == selected {
            return isCorrect ? Brutal.green : Brutal.red
        }
        if isCorrect { return Brutal.green }
        return Brutal.white
    }

    // MARK: - Which Came First

    private func whichCameFirstView(_ wc: WhichCameFirstSchema) -> some View {
        VStack(spacing: 16) {
            questionHeader(wc.question)

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
        VStack(spacing: 16) {
            questionHeader("Two Truths and a Lie")

            Text("FIND THE LIE!")
                .font(.caption)
                .fontWeight(.black)
                .tracking(2)
                .foregroundStyle(Brutal.red)

            VStack(spacing: 12) {
                ForEach(tt.answer, id: \.content) { answer in
                    answerButton(answer)
                }
            }
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Ordered List

    private func orderedListView(_ ol: OrderedListSchema) -> some View {
        VStack(spacing: 16) {
            questionHeader(ol.question)

            VStack(spacing: 10) {
                ForEach(Array(orderedItems.enumerated()), id: \.offset) { index, item in
                    HStack {
                        Text("\(index + 1)")
                            .font(.headline)
                            .fontWeight(.black)
                            .frame(width: 28, height: 28)
                            .background(Brutal.yellow)
                            .clipShape(RoundedRectangle(cornerRadius: Brutal.radius))
                            .overlay(
                                RoundedRectangle(cornerRadius: Brutal.radius)
                                    .stroke(Brutal.black, lineWidth: 2)
                            )

                        Text(item)
                            .fontWeight(.semibold)
                            .foregroundStyle(Brutal.black)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if !guessSubmitted {
                            HStack(spacing: 6) {
                                Button {
                                    Haptic.light()
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        guard index > 0 else { return }
                                        orderedItems.swapAt(index, index - 1)
                                    }
                                } label: {
                                    Image(systemName: "chevron.up")
                                        .fontWeight(.black)
                                        .font(.caption)
                                        .foregroundStyle(index == 0 ? .gray : Brutal.black)
                                }
                                .disabled(index == 0)

                                Button {
                                    Haptic.light()
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        guard index < orderedItems.count - 1 else { return }
                                        orderedItems.swapAt(index, index + 1)
                                    }
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .fontWeight(.black)
                                        .font(.caption)
                                        .foregroundStyle(index == orderedItems.count - 1 ? .gray : Brutal.black)
                                }
                                .disabled(index == orderedItems.count - 1)
                            }
                        } else {
                            let correctIndex = ol.answer.firstIndex(of: item)
                            if correctIndex == index {
                                Image(systemName: "checkmark")
                                    .fontWeight(.black)
                                    .foregroundStyle(Brutal.green)
                            } else {
                                Image(systemName: "xmark")
                                    .fontWeight(.black)
                                    .foregroundStyle(Brutal.red)
                            }
                        }
                    }
                    .padding(12)
                    .brutalCard()
                }
            }

            if !guessSubmitted {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        guessSubmitted = true
                    }
                    orderedItems == ol.answer ? Haptic.success() : Haptic.error()
                } label: {
                    Text("SUBMIT")
                        .brutalButton(fill: Brutal.yellow)
                }
            } else {
                let correct = orderedItems == ol.answer
                resultBadge(correct: correct)
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

        return VStack(spacing: 16) {
            questionHeader(mp.question)

            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 10) {
                    ForEach(keys, id: \.self) { key in
                        Button {
                            Haptic.light()
                            selectedPairLeft = key
                        } label: {
                            Text(key)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(Brutal.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 8)
                                .brutalCard(fill: matchSelections[key] != nil
                                    ? (mp.answer[key] == matchSelections[key] ? Brutal.green : Brutal.red)
                                    : selectedPairLeft == key ? Brutal.blue : Brutal.white)
                        }
                        .disabled(matchSelections[key] != nil)
                    }
                }

                VStack(spacing: 10) {
                    ForEach(values, id: \.self) { value in
                        Button {
                            if let left = selectedPairLeft {
                                Haptic.tap()
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    matchSelections[left] = value
                                    selectedPairLeft = nil
                                }
                            }
                        } label: {
                            Text(value)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(Brutal.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 8)
                                .brutalCard(fill: matchValueBG(value, correct: mp.answer))
                        }
                        .disabled(matchSelections.values.contains(value))
                    }
                }
            }

            if matchSelections.count == mp.answer.count {
                let allCorrect = matchSelections.allSatisfy { mp.answer[$0.key] == $0.value }
                resultBadge(correct: allCorrect)
            }
        }
        .padding(.horizontal, 24)
    }

    private func matchValueBG(_ value: String, correct: [String: String]) -> Color {
        if let matchedKey = matchSelections.first(where: { $0.value == value })?.key {
            return correct[matchedKey] == value ? Brutal.green : Brutal.red
        }
        return Brutal.white
    }

    // MARK: - Result Badge

    private func resultBadge(correct: Bool) -> some View {
        Text(correct ? "CORRECT!" : "WRONG!")
            .font(.headline)
            .fontWeight(.black)
            .tracking(2)
            .foregroundStyle(Brutal.black)
            .padding(.vertical, 10)
            .padding(.horizontal, 24)
            .brutalCard(fill: correct ? Brutal.green : Brutal.red)
    }

    // MARK: - Shared Answer Button

    private func answerButton(_ answer: Answer) -> some View {
        Button {
            Haptic.tap()
            withAnimation(.easeInOut(duration: 0.25)) {
                selectedAnswer = answer.content
            }
        } label: {
            Text(answer.content)
                .brutalButton(fill: backgroundColor(for: answer))
        }
        .disabled(selectedAnswer != nil)
    }

    private func backgroundColor(for answer: Answer) -> Color {
        guard let selected = selectedAnswer else { return Brutal.white }
        if answer.content == selected {
            return answer.correct ? Brutal.green : Brutal.red
        }
        if answer.correct { return Brutal.green }
        return Brutal.white
    }
}

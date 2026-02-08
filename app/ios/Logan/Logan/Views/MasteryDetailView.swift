//
//  MasteryDetailView.swift
//  Logan
//
//  Created by jon on 2/8/26.
//

import SwiftUI

// MARK: - Style Constants

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

private extension View {
    func brutalCard(fill: Color = Brutal.white) -> some View {
        modifier(BrutalCard(fill: fill))
    }
}

// MARK: - MasteryDetailView

struct MasteryDetailView: View {
    let tag: String
    @Environment(MasteryViewModel.self) private var mastery
    @Environment(\.dismiss) private var dismiss

    private var modules: [Module] {
        mastery.recentModules[tag] ?? []
    }

    private var score: Int {
        mastery.scores[tag] ?? 0
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .fontWeight(.black)
                        .foregroundStyle(Brutal.black)
                }

                Spacer()

                VStack(spacing: 2) {
                    Text(tag)
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundStyle(Brutal.black)
                    Text("Score: \(score)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                }

                Spacer()

                Image(systemName: "xmark")
                    .fontWeight(.black)
                    .foregroundStyle(.clear)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 16)

            if modules.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Text("NO MODULES YET")
                        .font(.headline)
                        .fontWeight(.black)
                        .tracking(2)
                        .foregroundStyle(Brutal.black)
                    Text("Answer some modules with this tag to see them here.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(modules) { module in
                            moduleSummaryCard(module)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Brutal.cream.ignoresSafeArea())
    }

    // MARK: - Module Summary Card

    private func moduleSummaryCard(_ module: Module) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(typeBadgeText(module.data))
                .font(.caption2)
                .fontWeight(.black)
                .tracking(1.5)
                .foregroundStyle(Brutal.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Brutal.black)
                .clipShape(RoundedRectangle(cornerRadius: Brutal.radius))

            Text(questionText(module.data))
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(Brutal.black)

            answerSummary(module.data)

            VStack(alignment: .leading, spacing: 6) {
                Text("EXPLANATION")
                    .font(.caption2)
                    .fontWeight(.black)
                    .tracking(1.5)
                    .foregroundStyle(.gray)

                Text(module.explanation)
                    .font(.caption)
                    .foregroundStyle(Brutal.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(Brutal.cream)
            .clipShape(RoundedRectangle(cornerRadius: Brutal.radius))
            .overlay(
                RoundedRectangle(cornerRadius: Brutal.radius)
                    .stroke(Brutal.black.opacity(0.15), lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .brutalCard()
    }

    // MARK: - Helpers

    private func typeBadgeText(_ data: DataPayload) -> String {
        switch data {
        case .multipleChoice: return "MULTIPLE CHOICE"
        case .trueOrFalse: return "TRUE OR FALSE"
        case .orderedList: return "ORDERED LIST"
        case .matchPairs: return "MATCH PAIRS"
        case .twoTruthsAndLie: return "TWO TRUTHS AND A LIE"
        case .whichCameFirst: return "WHICH CAME FIRST"
        }
    }

    private func questionText(_ data: DataPayload) -> String {
        switch data {
        case .multipleChoice(let mc): return mc.question
        case .trueOrFalse(let tf): return tf.question
        case .orderedList(let ol): return ol.question
        case .matchPairs(let mp): return mp.question
        case .twoTruthsAndLie: return "Two Truths and a Lie"
        case .whichCameFirst(let wc): return wc.question
        }
    }

    @ViewBuilder
    private func answerSummary(_ data: DataPayload) -> some View {
        switch data {
        case .multipleChoice(let mc):
            answerList(mc.answer)
        case .whichCameFirst(let wc):
            answerList(wc.answer)
        case .twoTruthsAndLie(let tt):
            answerList(tt.answer)
        case .trueOrFalse(let tf):
            HStack(spacing: 6) {
                Text("Answer:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                Text(tf.answer ? "True" : "False")
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundStyle(Brutal.green)
            }
        case .orderedList(let ol):
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(ol.answer.enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 8) {
                        Text("\(index + 1).")
                            .font(.caption)
                            .fontWeight(.black)
                            .foregroundStyle(.gray)
                        Text(item)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Brutal.black)
                    }
                }
            }
        case .matchPairs(let mp):
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(mp.answer.keys).sorted(), id: \.self) { key in
                    HStack(spacing: 6) {
                        Text(key)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(Brutal.black)
                        Image(systemName: "arrow.right")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                        Text(mp.answer[key] ?? "")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Brutal.green)
                    }
                }
            }
        }
    }

    private func answerList(_ answers: [Answer]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(answers, id: \.content) { answer in
                HStack(spacing: 8) {
                    Image(systemName: answer.correct ? "checkmark.circle.fill" : "circle")
                        .font(.caption)
                        .foregroundStyle(answer.correct ? Brutal.green : .gray)
                    Text(answer.content)
                        .font(.caption)
                        .fontWeight(answer.correct ? .bold : .regular)
                        .foregroundStyle(answer.correct ? Brutal.green : Brutal.black)
                }
            }
        }
    }
}

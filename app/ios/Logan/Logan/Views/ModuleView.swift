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

    var body: some View {
        switch module.data {
        case .multipleChoice(let mc):
            multipleChoiceView(mc)
        }
    }

    private func multipleChoiceView(_ mc: MultipleChoiceSchema) -> some View {
        VStack(spacing: 24) {
            Text(mc.question)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                ForEach(mc.answers, id: \.content) { answer in
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
            }
        }
        .padding(.horizontal, 24)
    }

    private func backgroundColor(for answer: MultipleChoiceSchema.Answer) -> Color {
        guard let selected = selectedAnswer else {
            return Color(.systemGray5)
        }
        if answer.content == selected {
            return answer.correct ? .green : .red
        }
        if answer.correct {
            return .green.opacity(0.3)
        }
        return Color(.systemGray5)
    }

    private func foregroundColor(for answer: MultipleChoiceSchema.Answer) -> Color {
        guard let selected = selectedAnswer else {
            return .primary
        }
        if answer.content == selected || answer.correct {
            return .white
        }
        return .primary
    }
}

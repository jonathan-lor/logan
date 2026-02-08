//
//  MasteryView.swift
//  Logan
//
//  Created by jon on 2/8/26.
//

import SwiftUI

private struct IdentifiableTag: Identifiable {
    let id: String
    init(_ tag: String) { self.id = tag }
}

struct MasteryView: View {
    @Environment(MasteryViewModel.self) private var mastery
    @State private var selectedTag: IdentifiableTag? = nil

    private let bgColor = Color(red: 1.0, green: 0.99, blue: 0.95)

    private var sortedTags: [(tag: String, score: Int)] {
        mastery.scores
            .sorted { $0.value > $1.value }
            .map { (tag: $0.key, score: $0.value) }
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("MASTERY")
                .font(.title2)
                .fontWeight(.black)
                .tracking(2)
                .foregroundStyle(.black)
                .padding(.top, 60)
                .padding(.bottom, 20)

            if sortedTags.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Text("NO MASTERIES YET")
                        .font(.headline)
                        .fontWeight(.black)
                        .tracking(2)
                        .foregroundStyle(.black)
                    Text("Answer some modules to start tracking your mastery!")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                        ForEach(sortedTags, id: \.tag) { item in
                            Button {
                                selectedTag = IdentifiableTag(item.tag)
                            } label: {
                                tagCard(tag: item.tag, score: item.score)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100)
                }
                .scrollIndicators(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(bgColor.ignoresSafeArea())
        .sheet(item: $selectedTag) { tag in
            MasteryDetailView(tag: tag.id)
        }
    }

    private func tagCard(tag: String, score: Int) -> some View {
        VStack(spacing: 8) {
            Text("\(score)")
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(.black)

            Text(tag)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, minHeight: 90)
        .padding(10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.black, lineWidth: 3)
        )
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.black)
                .offset(x: 5, y: 5)
        )
    }
}

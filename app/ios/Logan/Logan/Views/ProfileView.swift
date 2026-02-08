//
//  ProfileView.swift
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
    static let yellow = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let blue = Color(red: 0.35, green: 0.55, blue: 1.0)
    static let pink = Color(red: 1.0, green: 0.56, blue: 0.68)
    static let purple = Color(red: 0.69, green: 0.53, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.65, blue: 0.25)
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

// MARK: - ProfileView

struct ProfileView: View {
    @Environment(MasteryViewModel.self) private var mastery

    private var totalScore: Int {
        mastery.scores.values.reduce(0, +)
    }

    private var tagsStudied: Int {
        mastery.scores.count
    }

    private var modulesCompleted: Int {
        mastery.recentModules.values.reduce(0) { $0 + $1.count }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // pfp
                Image("Logan")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
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
                    .padding(.top, 60)

                // bio
                VStack(spacing: 6) {
                    Text("LOGAN")
                        .font(.title2)
                        .fontWeight(.black)
                        .tracking(2)
                        .foregroundStyle(Brutal.black)

                    Text("Chill guy...")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                }

                // stats
                HStack(spacing: 12) {
                    statCard(value: "\(totalScore)", label: "SCORE", color: Brutal.yellow)
                    statCard(value: "\(tagsStudied)", label: "TAGS", color: Brutal.blue)
                    statCard(value: "\(modulesCompleted)", label: "DONE", color: Brutal.green)
                }
                .padding(.horizontal, 24)

                // freaking AWESOME about section
                VStack(alignment: .leading, spacing: 10) {
                    sectionHeader("ABOUT")

                    Text("Hey, I'm Logan! I am an Electrical Engineering Masters Student at Texas A&M. WHOOP! I'm also a big fan of Minecraft, C++, Irony, and good vibes.")
                        .font(.subheadline)
                        .foregroundStyle(Brutal.black)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .brutalCard(fill: Brutal.white)
                .padding(.horizontal, 24)

                // some simple achievements
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader("ACHIEVEMENTS")

                    achievementRow(
                        icon: "flame.fill",
                        title: "First Steps",
                        description: "Complete your first module",
                        unlocked: modulesCompleted >= 1,
                        color: Brutal.orange
                    )
                    achievementRow(
                        icon: "star.fill",
                        title: "Tag Explorer",
                        description: "Study 3 different tags",
                        unlocked: tagsStudied >= 3,
                        color: Brutal.yellow
                    )
                    achievementRow(
                        icon: "trophy.fill",
                        title: "High Scorer",
                        description: "Reach a total score of 10",
                        unlocked: totalScore >= 10,
                        color: Brutal.pink
                    )
                    achievementRow(
                        icon: "bolt.fill",
                        title: "Knowledge Machine",
                        description: "Reach a total score of 50",
                        unlocked: totalScore >= 50,
                        color: Brutal.purple
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .brutalCard(fill: Brutal.white)
                .padding(.horizontal, 24)
                .padding(.bottom, 100)
            }
            .frame(maxWidth: .infinity)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Brutal.cream.ignoresSafeArea())
    }

    // MARK: - Components

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.caption)
            .fontWeight(.black)
            .tracking(2)
            .foregroundStyle(Brutal.black)
    }

    private func statCard(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(Brutal.black)

            Text(label)
                .font(.caption2)
                .fontWeight(.black)
                .tracking(1)
                .foregroundStyle(Brutal.black)
        }
        .frame(maxWidth: .infinity, minHeight: 70)
        .padding(8)
        .brutalCard(fill: color)
    }

    private func achievementRow(icon: String, title: String, description: String, unlocked: Bool, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .fontWeight(.black)
                .foregroundStyle(unlocked ? Brutal.black : .gray)
                .frame(width: 40, height: 40)
                .brutalCard(fill: unlocked ? color : Color(.systemGray5))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.black)
                    .foregroundStyle(unlocked ? Brutal.black : .gray)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }

            Spacer()

            if unlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Brutal.green)
            } else {
                Image(systemName: "lock.fill")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}

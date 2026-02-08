//
//  ContentView.swift
//  Logan
//
//  Created by jon on 2/7/26.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case mastery = "Mastery"
    case you = "You"

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .mastery: return "trophy.fill"
        case .you: return "person.fill"
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var mastery = MasteryViewModel()

    private let bgColor = Color(red: 1.0, green: 0.99, blue: 0.95)

    var body: some View {
        ZStack(alignment: .bottom) {
            bgColor.ignoresSafeArea()

            Group {
                switch selectedTab {
                case .home:
                    FeedView()
                case .mastery:
                    MasteryView()
                case .you:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            tabBar
        }
        .environment(mastery)
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    selectedTab = tab
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: tab.icon)
                            .font(.subheadline)
                            .fontWeight(.black)
                        Text(tab.rawValue)
                            .font(.caption2)
                            .fontWeight(.black)
                    }
                    .foregroundStyle(selectedTab == tab ? Color.black : Color.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 6)
        .padding(.bottom, 4)
        .background(
            Color.white
                .overlay(
                    Rectangle()
                        .frame(height: 3)
                        .foregroundStyle(Color.black),
                    alignment: .top
                )
                .ignoresSafeArea(.container, edges: .bottom)
        )
    }
}

#Preview {
    ContentView()
}

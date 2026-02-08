//
//  FeedView.swift
//  Logan
//
//  Created by jon on 2/7/26.
//

import SwiftUI

struct FeedView: View {
    @State private var feed = FeedViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(feed.modules) { module in
                    ModuleView(module: module)
                        .containerRelativeFrame(.vertical, alignment: .center)
                        .onAppear {
                            // load more when the last module appears
                            if module.id == feed.modules.last?.id {
                                Task { await feed.loadModules() }
                            }
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
        .background(Color(red: 1.0, green: 0.99, blue: 0.95))
        .task {
            await feed.loadModules()
        }
    }
}

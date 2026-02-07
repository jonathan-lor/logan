//
//  FeedView.swift
//  Logan
//
//  Created by jon on 2/7/26.
//

import SwiftUI

struct FeedView: View {
    
    let items = [1,2,3,4,5,6,7,8,9,10]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(items, id: \.self) { item in
                    ModuleView(num: item)
                        .containerRelativeFrame(.vertical, alignment: .center)
                        .onAppear {
                            diddy()
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
    }
}

func diddy() {
    print("diddy")
}

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
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
        .task {
            await diddy2()
        }
    }
}

func diddy2() async {
    print("diddy2")
    
    do {
        //let result: APIResponse<Module> = try await api.get("/questions/random?tag=Pokemon")
        let result: Module = try await APIClient.shared.getItem("/questions/random?tag=Pokemon")
        print("yayaya \(result)")
    } catch {
        print("diddy2: an error occurred: \(error)")
    }
}

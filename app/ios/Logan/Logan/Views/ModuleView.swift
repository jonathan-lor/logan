//
//  ModuleView.swift
//  Logan
//
//  Created by jon on 2/7/26.
//

import SwiftUI

struct ModuleView: View {
    let num: Int
    @State private var showingHint: Bool = false
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .ignoresSafeArea()
                .onTapGesture(count: 2) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showingHint.toggle()
                    }
                }
            
            // Content layer respects safe area
            ZStack {
                moduleContent
                    .rotation3DEffect(
                        .degrees(showingHint ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .opacity(showingHint ? 0 : 1)
                
                hintContent
                    .rotation3DEffect(
                        .degrees(showingHint ? 0 : -180),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .opacity(showingHint ? 1 : 0)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var moduleContent: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Module \(num)")
        }
    }
    
    private var hintContent: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Hint goes here")
        }
    }
}

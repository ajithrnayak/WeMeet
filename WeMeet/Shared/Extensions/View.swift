//
//  View.swift
//  WeMeet
//
//  Created by Ajith Renjala on 02/08/23.
//

import SwiftUI

extension View {
    @ViewBuilder
    func active(if condition: Bool) -> some View {
        if condition { self }
    }

    @ViewBuilder
    func loading(if condition: Bool) -> some View {
        if condition {
            SwiftUI.ProgressView {
                Text("Loading...")
                    .font(.body)
                    .foregroundColor(Color.accentColor)
            }
        } else {
            self
        }
    }

    @ViewBuilder
    func loadingOverlay(if condition: Bool) -> some View {
        if condition {
            ZStack {
                self
                SwiftUI.ProgressView {
                    Text("Loading...")
                        .font(.body)
                        .foregroundColor(.white)
                }
                .tint(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
            }
        } else {
            self
        }
    }
}

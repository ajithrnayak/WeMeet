//
//  RoomListView.swift
//  WeMeet
//
//  Created by Ajith Renjala on 01/08/23.
//

import SwiftUI

struct RoomListView: View {
    @StateObject var viewModel: RoomListViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 420))]) {
                    ForEach((0...20), id: \.self) {_ in
                        Color(.red)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 300)
                    }
                }
                .padding()
            }
            .navigationTitle(viewModel.title)
        }
        .navigationViewStyle(.stack)
        .task {
            await viewModel.loadRooms()
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(viewModel: RoomListViewModel())
    }
}

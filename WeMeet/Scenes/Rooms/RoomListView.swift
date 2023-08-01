//
//  RoomListView.swift
//  WeMeet
//
//  Created by Ajith Renjala on 01/08/23.
//

import SwiftUI

struct RoomListView: View {
    @StateObject var viewModel: RoomListViewModel

    private let gridColumns: [GridItem] = [
        GridItem(.flexible())
    ]

    // MARK: - Build View

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(
                    columns: gridColumns,
                    alignment: .center,
                    pinnedViews: [.sectionHeaders]
                ) {
                    ForEach(viewModel.rooms, id: \.name) { room in
                        ZStack {
                            Color(.red)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 300)
                            Text(room.name)
                                .font(.largeTitle)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(viewModel.title)
        }
        .navigationViewStyle(.stack)
        .task {
            await viewModel.loadSampleRooms()
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(viewModel: RoomListViewModel())
    }
}

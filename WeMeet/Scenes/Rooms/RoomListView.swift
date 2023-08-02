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
                    spacing: Spacing.multipliedBy(3).value
                ) {
                    ForEach(viewModel.rooms, id: \.name) { room in
                        RoomView(room: room) { bookedRoom in
                            viewModel.bookRoom(bookedRoom)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(viewModel.title)
            .loading(if: viewModel.isLoading)
            .loadingOverlay(if: viewModel.showLoadingOverlay)
        }
        .navigationViewStyle(.stack)
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(
            viewModel: RoomListViewModel.example
        )
    }
}

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
            ZStack {
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
                .refreshable {
                    await viewModel.refreshRooms()
                }
                .navigationTitle(viewModel.title)
                .loading(if: viewModel.isLoading)
                .alert(isPresented: $viewModel.isAlertVisible) {
                    if let config = viewModel.alertConfig {
                        return Alert(
                            title: Text(config.title),
                            message: Text(config.message),
                            dismissButton: .default(Text("Ok"))
                        )
                    } else {
                        return Alert(title: Text("Something Wrong!"))
                    }
                }

                if viewModel.showLoadingOverlay {
                    loadingOverlay
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - View Builders
    
    @ViewBuilder
    var loadingOverlay: some View {
        ProgressView {
            Text("Loading...")
                .font(.body)
                .foregroundColor(.white)
        }
        .progressViewStyle(CircularProgressViewStyle())
        .tint(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5))
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(
            viewModel: RoomListViewModel.example
        )
    }
}

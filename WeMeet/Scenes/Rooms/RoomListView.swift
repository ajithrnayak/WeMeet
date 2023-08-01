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
        }
        .navigationViewStyle(.stack)
    }
}

struct RoomView: View {
    let room: Room
    var onBookAction: ((Room) -> Void)?

    var body: some View {
        VStack(spacing: Spacing.double.value) {
            AsyncImage(
                url: room.thumbnailURL,
                transaction: .init(animation: .spring())
            ) {
                handleAsyncImagePhase($0)
            }
            .frame(height: 220)
            .mask(RoundedRectangle(cornerRadius: CornerRadius.grids))

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Spacing.full.value) {
                    Text("\(room.name)")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(room.remainingSpotsLabel)
                        .font(.body)
                        .foregroundColor(room.hasRemainingSpots ? .accentColor : .gray)
                }

                Spacer(minLength: 8)

                Button("Book!") {
                    onBookAction?(room)
                }
                .buttonStyle(PrimaryButton())
                .fixedSize()
                .active(if: room.hasRemainingSpots)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private func handleAsyncImagePhase(_ phase: AsyncImagePhase) -> some View {
        switch phase {
        case .empty:
            Color.gray
                .opacity(0.2)
                .transition(.opacity.combined(with: .scale))

        case .success(let image):
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .transition(.opacity.combined(with: .scale))

        case .failure(let error):
            ErrorView(error)

        @unknown default:
            ErrorView()
        }
    }
}

struct ErrorView: View {
    var error: Error?

    private var errorDescr: String {
        return error?.localizedDescription ?? "Error Occurred"
    }

    init(_ error: Error? = nil) {
        self.error = error
    }

    var body: some View {
        Text(errorDescr)
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(viewModel: RoomListViewModel())
    }
}

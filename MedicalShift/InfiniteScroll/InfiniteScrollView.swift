//
//  InfiniteScrollView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/05.
//

import SwiftUI

struct Item: Identifiable, Equatable {
    let id: Int
    let title: String
}

struct InfiniteScrollView: View {
    let initialPosition: Item.ID = 50
    @State private var items: [Item] = (40..<60).map { Item(id: $0, title: "Item \($0)") }
    @State private var position = ScrollPosition(idType: Item.ID.self, edge: .bottom)
    @State private var initialPositionSet = false

    var body: some View {
        let viewID = position.viewID(type: Item.ID.self) ?? initialPosition

        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(items) { item in
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 200, height: 200)

                            Text(item.title)
                        }
                        .onAppear {
                            if item.id == initialPosition && !initialPositionSet {
                                position.scrollTo(id: viewID, anchor: .center)
                                initialPositionSet = true
                            }
                            print(item.id, Date.now)

                            if items.first == item {
                                items.insert(
                                    Item(id: item.id - 1, title: "Item \(item.id - 1)"), at: 0)
                            }

                            if items.last == item {
                                items.append(Item(id: item.id + 1, title: "Item \(item.id + 1)"))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollTargetLayout()
            }
            .scrollBounceBehavior(.basedOnSize)
            .scrollPosition($position, anchor: .center)
            .navigationTitle("\(viewID)")
            .onAppear {
                position.scrollTo(id: viewID, anchor: .center)
            }
            .toolbar {
                // Button {
                //     withAnimation {
                //         position.scrollTo(id: viewID, anchor: .center)
                //     }
                // } label: {
                //     Text("Scroll to \(viewID)")
                // }
            }
            // .onChange(of: items) {
            //     withAnimation {
            //         position.scrollTo(id: viewID, anchor: .center)
            //     }
            // }
        }
    }
}

#Preview {
    InfiniteScrollView()
}

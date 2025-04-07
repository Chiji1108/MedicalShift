//
//  InfiniteTabView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/06.
//

import SwiftUI

struct InfiniteTabView: View {
    let initialPosition: Item.ID = 0
    @State private var items: [Item] = []
    @State private var selection: Item.ID = 0

    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                ForEach(items) { item in
                    Text(item.title)
                        .tag(item.id)
                        .onAppear {
                            print("onAppear: \(item.id), \(Date.now)")

                            if items.first == item {
                                items.insert(
                                    Item(id: item.id - 1, title: "Tab \(item.id - 1)"), at: 0)
                            }

                            if items.last == item {
                                items.append(Item(id: item.id + 1, title: "Tab \(item.id + 1)"))
                            }
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .onAppear {
                items = (initialPosition - 3..<initialPosition + 3).map {
                    Item(id: $0, title: "Tab \($0)")
                }
                selection = initialPosition
            }
            .navigationTitle("\(selection)")
        }
    }
}

#Preview {
    InfiniteTabView()
}

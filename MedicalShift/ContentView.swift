//
//  ContentView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/04.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMonth: Date = Date()

    var body: some View {
        TabView {
            Tab("Horizontal", systemImage: "distribute.horizontal") {
                HorizontalCalendarView(selectedMonth: $selectedMonth)
            }

            Tab("Vertical", systemImage: "distribute.vertical") {
                VerticalCalendarView(selectedMonth: $selectedMonth)
            }
        }
    }
}

#Preview {
    ContentView()
}

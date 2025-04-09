//
//  ContentView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/04.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedYearMonth: Date = Date()

    var body: some View {
        TabView {
            Tab("Horizontal", systemImage: "distribute.horizontal") {
                HorizontalCalendar(selectedYearMonth: $selectedYearMonth)
            }

            Tab("Vertical", systemImage: "distribute.vertical") {
                VerticalCalendar(selectedYearMonth: $selectedYearMonth)
            }
        }
    }
}

#Preview {
    ContentView()
}

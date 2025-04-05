//
//  ContentView.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/04.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMonth: Date? = Date.now

    var body: some View {
        TabView {
            Tab("Vertical", systemImage: "distribute.vertical") {
                VerticalCalendarView()
            }
            
            Tab("Horizontal", systemImage: "distribute.horizontal") {
                HorizontalCalendarView()
            }
        }
    }
}

#Preview {
    ContentView()
}

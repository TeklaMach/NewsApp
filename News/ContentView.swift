//
//  ContentView.swift
//  News
//
//  Created by Tekla Matcharashvili on 20.12.23.
//

import SwiftUI

struct JournalEntryForm: View {
    // MARK: - Properties
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var newsEntries: [NewsEntry] = []
    
    // MARK: - Button Style
    struct GrowingButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - Text Fields
                TextField("News", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Description", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // MARK: - Date Picker
                DatePicker("Date:", selection: $date, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding(.horizontal)
                
                // MARK: - Save Button
                Button("Save News") {
                    saveNews()
                }
                .buttonStyle(GrowingButton())
                .padding()
                
                // MARK: - News List
                NewsList(newsEntries: $newsEntries)
            }
            .padding()
            .background(Color(red: 9.9, green: 0.9, blue: 0.9).edgesIgnoringSafeArea(.all))
            .navigationTitle("Daily News Scene")
        }
    }
    
    // MARK: - Save News Function
    func saveNews() {
        let newsEntry = NewsEntry(title: title, description: description, date: date)
        newsEntries.append(newsEntry)
        
        //MARK: - Clear the form
        title = ""
        description = ""
        date = Date()
    }
}

struct NewsList: View {
    // MARK: - Properties
    @Binding var newsEntries: [NewsEntry]
    
    // MARK: - Body
    var body: some View {
        List {
            ForEach(newsEntries) { newsEntry in
                VStack(alignment: .leading, spacing: 4) {
                    Text(newsEntry.title)
                        .font(.headline)
                    Text(newsEntry.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Date: \(formattedDate(newsEntry.date))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .onDelete { indexSet in
                deleteNews(at: indexSet)
            }
            .onMove(perform: moveNews)
        }
        .listStyle(InsetGroupedListStyle())
        .overlay(emptyStateView, alignment: .center)
    }
    
    // MARK: - Delete News Function
    func deleteNews(at offsets: IndexSet) {
        newsEntries.remove(atOffsets: offsets)
    }
    
    // MARK: - Move News Function
    func moveNews(from source: IndexSet, to destination: Int) {
        newsEntries.move(fromOffsets: source, toOffset: destination)
    }
    
    // MARK: - Formatted Date Function
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Empty State View
    var emptyStateView: some View {
        Group {
            if newsEntries.isEmpty {
                Text("No news available")
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - News Entry Model
struct NewsEntry: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryForm()
    }
}

#Preview {
    JournalEntryForm()
}

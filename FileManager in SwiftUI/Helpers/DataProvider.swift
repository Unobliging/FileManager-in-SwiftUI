//
//  DataProvider.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/25/21.
//

import Foundation

class DataProvider: ObservableObject {
    
    // MARK: - Propeties
    static let shared = DataProvider()
    private let dataSourceURL: URL
    @Published var allNotes = [Note]()
    
    // MARK: - Life Cycle
    init() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let notesPath = documentsPath.appendingPathComponent("notes").appendingPathExtension("json")
        dataSourceURL = notesPath
        
        _allNotes = Published(wrappedValue: getAllNotes())
    }
    
    // MARK: - Methods
    private func getAllNotes() -> [Note] {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            let decodedNotes = try! decoder.decode([Note].self, from: data)
            
            return decodedNotes
        } catch {
            return []
        }
    }
    
    private func saveNotes() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allNotes)
            try data.write(to: dataSourceURL)
        } catch {

        }
    }
    
    func create(note: Note) {
        allNotes.insert(note, at: 0)
        saveNotes()
    }
    
    func changeNote(note: Note, index: Int) {
        allNotes[index] = note
        saveNotes()
    }
    
    func delete(_ offsets: IndexSet) {
        allNotes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    func move(source: IndexSet, destination: Int) {
        allNotes.move(fromOffsets: source, toOffset: destination)
        saveNotes()
    }
}

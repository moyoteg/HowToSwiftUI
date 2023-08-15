//
//  UseCloudFirestore.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 5/11/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct UseCloudFirestore: View {
    @StateObject private var viewModel = FirestoreViewModel()
    
    var body: some View {
//        List(viewModel.items) { item in
//            Text(item.stringField)
//        }
        FirestoreCRUD()
            .onAppear {
                viewModel.fetchDataAndFavoritedItems()
            }
    }
}

struct UseCloudFirestore_Previews: PreviewProvider {
    static var previews: some View {
        UseCloudFirestore()
    }
}

class FirestoreViewModel: ObservableObject {
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    @Published var items: [ExampleModel] = []
    
    @Published var favoritedItems: [ExampleModel] = [] {
        didSet {
            print("didSet: favoritedItems: \(favoritedItems)")
        }
    }

    func fetchDataAndFavoritedItems() {
        fetchFavoritedItems()
        fetchData()
    }
    
    func fetchData() {
        listenerRegistration = db.collection("examples").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.items = documents.compactMap { document in
                                
                do {
                    let data = try document.data(as: ExampleModel.self)
                    return data
                } catch {
                    print("Error decoding document: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    
    func addItem(_ item: ExampleModel) {
        do {
            _ = try db.collection("examples").addDocument(from: item)
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    func updateItem(_ item: ExampleModel) {
        guard let documentID = item.id else { return }
        
        do {
            try db.collection("examples").document(documentID).setData(from: item)
        } catch {
            print("Error updating document: \(error)")
        }
    }
    
    func deleteItem(_ item: ExampleModel) {
        guard let documentID = item.id else { return }
        
        db.collection("examples").document(documentID).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            }
        }
    }
    
    func fetchItem(withID id: String, completion: @escaping (ExampleModel?) -> Void) {
        db.collection("examples").document(id).getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let item = try document.data(as: ExampleModel.self)
                completion(item)
            } catch {
                print("Error decoding document: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func favoriteItem(_ item: ExampleModel, completion: @escaping (Bool) -> Void) {
        guard let itemId = item.id else {
            completion(false)
            return
        }
        
        let favoritedExamplesRef = db.collection("favoritedExamples").document("favoritedExamplesDoc")
        
        favoritedExamplesRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists, var favoritedExamples = try? document.data(as: FavoritedExamples.self) {
                let itemRef = self?.db.collection("examples").document(itemId)
                favoritedExamples.favoritedItems.append(itemRef!)
                
                do {
                    try favoritedExamplesRef.setData(from: favoritedExamples)
                    completion(true)
                } catch {
                    print("Error updating favoritedExamples document: \(error)")
                    completion(false)
                }
            } else {
                let itemRef = self?.db.collection("examples").document(itemId)
                let favoritedExamples = FavoritedExamples(favoritedItems: [itemRef!])
                
                do {
                    try favoritedExamplesRef.setData(from: favoritedExamples)
                    completion(true)
                } catch {
                    print("Error creating favoritedExamples document: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func unfavoriteItem(_ item: ExampleModel, completion: @escaping (Bool) -> Void) {
        guard let itemId = item.id else {
            completion(false)
            return
        }
        
        let favoritedExamplesRef = db.collection("favoritedExamples").document("favoritedExamplesDoc")
        
        favoritedExamplesRef.getDocument { [weak self] (document, error) in
            guard let document = document, document.exists,
                  var favoritedExamples = try? document.data(as: FavoritedExamples.self) else {
                completion(false)
                return
            }
            
            let itemRef = self?.db.collection("examples").document(itemId)
            if let index = favoritedExamples.favoritedItems.firstIndex(of: itemRef!) {
                favoritedExamples.favoritedItems.remove(at: index)
            }
            
            do {
                try favoritedExamplesRef.setData(from: favoritedExamples)
                completion(true)
            } catch {
                print("Error updating favoritedExamples document: \(error)")
                completion(false)
            }
        }
    }
    
    func fetchFavoritedItems() {
        let favoritedExamplesRef = db.collection("favoritedExamples").document("favoritedExamplesDoc")
        
        favoritedExamplesRef.getDocument { (document, error) in
            if let document = document, document.exists, let favoritedExamples = try? document.data(as: FavoritedExamples.self) {
                let dispatchGroup = DispatchGroup()
                var fetchedItems: [ExampleModel] = []
                
                for favoritedItemRef in favoritedExamples.favoritedItems {
                    dispatchGroup.enter()
                    
                    favoritedItemRef.getDocument { (document, error) in
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        if let document = document, document.exists {
                            do {
                                let item = try document.data(as: ExampleModel.self)
                                fetchedItems.append(item)

                            } catch {
                                print("Error decoding favorited item: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.favoritedItems = fetchedItems
                }
            }
        }
    }
    
    func isItemFavorited(_ item: ExampleModel) -> Bool {
        guard let itemId = item.id else {
            return false
        }
        
        let isItemFavorited = favoritedItems.contains { $0.id == itemId }
        print("isItemFavorited: \(isItemFavorited)")
        return isItemFavorited
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}

struct ExampleModel: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var stringField: String
    var intField: Int
    var doubleField: Double
    var boolField: Bool
    var dateField: Date
    var arrayField: [String]
    var dictionaryField: [String: String]
    
    var isFavorite: Bool?
    
    init(id: String? = nil, stringField: String, intField: Int, doubleField: Double, boolField: Bool, dateField: Date, arrayField: [String], dictionaryField: [String: String]) {
        self.id = id
        self.stringField = stringField
        self.intField = intField
        self.doubleField = doubleField
        self.boolField = boolField
        self.dateField = dateField
        self.arrayField = arrayField
        self.dictionaryField = dictionaryField
    }
    
}

struct FavoritedExamples: Codable {
    var favoritedItems: [DocumentReference]
}

struct FirestoreCRUD: View {
    @StateObject private var viewModel = FirestoreViewModel()
    @State private var newItemTitle = ""
    @State private var selectedItem: ExampleModel?
    @State private var showAlert = false
    @State private var foundItem: ExampleModel?
    @State private var alertItem: ExampleModel?
    @State private var isFavorited = false

    var body: some View {
        VStack {
            
            Button("Query Item") {
                queryItem()
            }
            .padding()
            .disabled(selectedItem == nil)
            
            Toggle(isOn: $isFavorited) {
                Text("Favorite Item")
            }
            .padding()
            .disabled(selectedItem == nil)
            .onChange(of: isFavorited) { newValue in
                toggleFavorite(newValue)
            }
            
            TextField("Enter item title", text: $newItemTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("Add Item") {
                    addItem()
                }
                .padding()
                
                Button("Update Item") {
                    updateItem()
                }
                .padding()
                .disabled(selectedItem == nil)
                
                Button("Delete Item") {
                    deleteItem()
                }
                .padding()
                .disabled(selectedItem == nil)
            }
            
            List(viewModel.items) { item in
                VStack(alignment: .leading) {
                    Text(item.stringField)
                        .font(.headline)
                    Text("Id: \(item.id ?? "no id")")
                    Text("String: \(item.stringField)")
                    Text("Int: \(item.intField)")
                    Text("Double: \(item.doubleField)")
                    Text("Bool: \(item.boolField.description)")
                    Text("Date: \(item.dateField.description)")
                    Text("Array: \(item.arrayField.joined(separator: ", "))")
                    Text("Dictionary: \(item.dictionaryField.description)")
                }
                .onTapGesture {
                    selectedItem = item
                    newItemTitle = item.stringField
                    print("favoritedItems.count: \(viewModel.favoritedItems.count)")
                    isFavorited = viewModel.isItemFavorited(item)
                }
                .foregroundColor(viewModel.isItemFavorited(item) ? .red : .primary)
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
        .alert(isPresented: $showAlert) {
            if let foundItem = foundItem {
                return Alert(
                    title: Text("Found Item"),
                    message: Text("ID: \(foundItem.id ?? "")\nString: \(foundItem.stringField)\nInt: \(foundItem.intField)\nDouble: \(foundItem.doubleField)\nBool: \(foundItem.boolField.description)\nDate: \(foundItem.dateField.description)\nArray: \(foundItem.arrayField.joined(separator: ", "))\nDictionary: \(foundItem.dictionaryField.description)"),
                    dismissButton: .default(Text("OK"))
                )
            } else {
                return Alert(
                    title: Text("Item not found"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .alert(item: $alertItem) { item in
            Alert(
                title: Text("Query Result"),
                message: Text("Item ID: \(item.id ?? "")"),
                dismissButton: .default(Text("OK")) {
                    clearAlert()
                }
            )
        }
    }
    
    private func addItem() {
        let newItem = ExampleModel(
            stringField: newItemTitle,
            intField: Int.random(in: 1...100),
            doubleField: Double.random(in: 1...10),
            boolField: Bool.random(),
            dateField: Date(),
            arrayField: ["red", "green", "blue"],
            dictionaryField: ["key1": "value1", "key2": "42"]
        )
        
        viewModel.addItem(newItem)
        newItemTitle = ""
    }
    
    private func updateItem() {
        guard let selectedItem = selectedItem else { return }
        
        let updatedItem = ExampleModel(
            id: selectedItem.id,
            stringField: newItemTitle,
            intField: selectedItem.intField,
            doubleField: selectedItem.doubleField,
            boolField: selectedItem.boolField,
            dateField: selectedItem.dateField,
            arrayField: selectedItem.arrayField,
            dictionaryField: selectedItem.dictionaryField
        )
        
        viewModel.updateItem(updatedItem)
        clearSelection()
    }
    
    private func deleteItem() {
        guard let selectedItem = selectedItem else { return }
        
        viewModel.deleteItem(selectedItem)
        clearSelection()
    }
    
    private func clearSelection() {
        selectedItem = nil
        newItemTitle = ""
    }
    
    private func queryItem() {
        guard let selectedItem = selectedItem, let itemId = selectedItem.id else { return }
        viewModel.fetchItem(withID: itemId) { item in
            foundItem = item
            showAlert = true
        }
    }
    
    private func clearAlert() {
        showAlert = false
        alertItem = nil
    }
    
    private func favoriteItem(_ item: ExampleModel) {
        
        viewModel.favoriteItem(item) { success in
            if success {
                showAlert = true
                alertItem = selectedItem
                if selectedItem == item {
                    isFavorited = true
                }
            } else {
                print("Failed to favorite item.")
            }
        }
    }
    
    private func unfavoriteItem(_ item: ExampleModel) {
        
        viewModel.unfavoriteItem(item) { success in
            if success {
                showAlert = true
                alertItem = selectedItem
                if selectedItem == item {
                    isFavorited = false
                }
            } else {
                print("Failed to unfavorite item.")
            }
        }
    }
    
    private func toggleFavorite(_ newValue: Bool) {
        guard let selectedItem = selectedItem else { return }
        
        if newValue {
            favoriteItem(selectedItem)
        } else {
            unfavoriteItem(selectedItem)
        }
    }
}

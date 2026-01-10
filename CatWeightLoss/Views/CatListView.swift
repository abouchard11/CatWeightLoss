import SwiftUI
import SwiftData

struct CatListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Cat.createdAt, order: .reverse) private var cats: [Cat]

    @State private var showingAddCat = false
    @State private var searchText = ""

    var filteredCats: [Cat] {
        if searchText.isEmpty {
            return cats
        }
        return cats.filter { cat in
            cat.name.localizedCaseInsensitiveContains(searchText) ||
            (cat.breed?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if cats.isEmpty {
                    emptyState
                } else {
                    catList
                }
            }
            .navigationTitle("My Cats")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddCat = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddCat) {
                AddCatView()
            }
            .searchable(text: $searchText, prompt: "Search cats")
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Cats Yet", systemImage: "cat.fill")
        } description: {
            Text("Add your first cat to start tracking their weight loss journey.")
        } actions: {
            Button {
                showingAddCat = true
            } label: {
                Text("Add Cat")
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var catList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredCats) { cat in
                    NavigationLink(destination: CatDetailView(cat: cat)) {
                        CatCard(cat: cat)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(role: .destructive) {
                            deleteCat(cat)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    private func deleteCat(_ cat: Cat) {
        NotificationService.shared.cancelAllReminders(for: cat)
        modelContext.delete(cat)
    }
}

#Preview {
    CatListView()
        .modelContainer(for: Cat.self, inMemory: true)
}

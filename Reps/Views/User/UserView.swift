import SwiftUI
import SwiftData

struct UserView: View {
    
    // TODO: Put in about section with how to get in touch
    // Done button
    
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    @Query private var routines: [Routine]
    @Query private var journalEntries: [JournalEntry]
    
    var body: some View {
        if !users.isEmpty {
            NavigationView {
                Form {
                    Section("Progressions") {
                        ForEach(ExerciseType.allCases, id: \.self) { exerciseType in
                            Section {
                                ProgressionPickersView(exerciseType: exerciseType)
                            }
                        }
                        Section("Admin") {
                            Button("Clear User Data") {
                                clearUser()
                            }
                            Button("Clear Routines") {
                                clearRoutines()
                            }
                            Button("Clear Journal") {
                                clearJournalEntries()
                            }
                        }
                    }
                    .navigationTitle("Settings")
                }
            }
        }
    }
    
    func clearUser() {
        for user in users {
            context.delete(user)
        }
    }
    
    func clearRoutines() {
        for routine in routines {
            context.delete(routine)
        }
    }
    
    func clearJournalEntries() {
        for entry in journalEntries {
            context.delete(entry)
        }
    }
}

#Preview {
    UserView()
        .modelContainer(DataController.previewContainer)
}

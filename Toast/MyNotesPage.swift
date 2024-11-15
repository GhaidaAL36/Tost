import SwiftUI

struct Note: Identifiable {
    let id = UUID()
    var text: String
}

struct MyNotesPage: View {
    @State private var notes: [Note] = [
        Note(text: "Note 1"),
        Note(text: "Note 2"),
        Note(text: "Note 3"),
        Note(text: "Note 4")
    ]
    @State private var isEditing = false
    @State private var noteToDelete: Note? = nil // Track the note to delete
    @State private var showDeleteAlert = false // Show the delete confirmation alert

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("My Notes")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Done" : "Edit")
                            .foregroundColor(.iconscolor)
                    }
                }
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                        ForEach(notes.indices, id: \.self) { index in
                            NoteView(note: $notes[index], isEditing: $isEditing, onDelete: {
                                // Trigger delete action
                                noteToDelete = notes[index]
                                showDeleteAlert = true
                            })
                        }
                    }
                    .padding()
                }
                
                // Small button to add a new note
                Button(action: {
                    let newNote = Note(text: "New Note") // Add a new note with default text
                    notes.append(newNote)
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                        Text("Add Note")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.button)
                    .cornerRadius(10)
                    .padding(.bottom)
                }
            }
            .navigationBarHidden(true)
            .background(Color.white) // background color
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Are you sure you want to delete this note?"),
                    primaryButton: .destructive(Text("Yes")) {
                        if let noteToDelete = noteToDelete,
                           let index = notes.firstIndex(where: { $0.id == noteToDelete.id }) {
                            notes.remove(at: index) // Delete the note from the array
                        }
                    },
                    secondaryButton: .cancel {
                        // Do nothing if the user cancels
                    }
                )
            }
        }
    }
}

struct NoteView: View {
    @Binding var note: Note
    @Binding var isEditing: Bool
    var onDelete: () -> Void // Action when delete button is tapped

    var body: some View {
        VStack {
            if isEditing {
                HStack {
                    TextField("Edit Note", text: $note.text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: onDelete) { // Trigger delete action
                        Image(systemName: "trash")
                            .foregroundColor(.iconscolor)
                    }
                    .padding(.trailing)
                }
                .background(Color(.box))
                .cornerRadius(8)
            } else {
                Text(note.text)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.box))
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    MyNotesPage()
}

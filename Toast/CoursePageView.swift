import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var subtitle: String
    var date: Date // Add date property
    var isCompleted: Bool = false
}

struct CoursePageView: View {
    @State private var tasks: [Task] = []
    @State private var isEditing = false
    @State private var editingTaskIndex: Int? = nil
    var course: Course // Passed Course object
    
    var body: some View {
     //   NavigationView {
           
            VStack {
                Text(course.name)
                    .font(.largeTitle)
                    .padding()

                List {
                    ForEach(tasks.indices, id: \.self) { index in
                        NavigationLink {
                            
                            TaskInfoPage(task: $tasks[index]) .toolbar(.hidden, for: .tabBar)
                            
                        } label: {
                          
                            TaskRowView(
                                task: $tasks[index],
                                isEditing: isEditing,
                                editingTaskIndex: $editingTaskIndex,
                                currentIndex: index,
                                deleteAction: { deleteTask(at: index) }
                            )
                        }
                    }
                    
                    NavigationLink{
                        AddNewTaskPage(tasks: $tasks).toolbar(.hidden, for: .tabBar)
                    } label: {
                        NewTaskButton()
                    }
                        
                    
                }
                
                NavigationLink{
                    MyNotesPage().toolbar(.hidden, for: .tabBar)
                }
                label:{
                    Text("See all my notes")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.button)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            
            .background(Color.background)
            .navigationTitle("My Tasks")
            .navigationBarItems(trailing: Button(action: {
                isEditing.toggle()
                editingTaskIndex = nil
            }) {
                Text(isEditing ? "Done" : "Edit")
                    .foregroundColor(.button)
            })
      //  }
    }

    private func deleteTask(at index: Int) {
        tasks.remove(at: index)
    }
}

struct TaskRowView: View {
    @Binding var task: Task
    var isEditing: Bool
    @Binding var editingTaskIndex: Int?
    var currentIndex: Int
    var deleteAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                task.isCompleted.toggle()
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.gray)
            }
            
            if editingTaskIndex == currentIndex {
                VStack(alignment: .leading) {
                    TextField("Task Title", text: $task.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Task Subtitle", text: $task.subtitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            } else {
                VStack(alignment: .leading) {
                    Text(task.title)
                        .strikethrough(task.isCompleted, color: .gray)
                        .foregroundColor(task.isCompleted ? .gray : .primary)
                    Text(task.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Due: \(task.date, formatter: DateFormatter.shortDateFormatter)") // Display the task's date
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            if isEditing {
                Button(action: {
                    editingTaskIndex = (editingTaskIndex == currentIndex) ? nil : currentIndex
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.pink)
                }
                
                Button(action: deleteAction) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct TaskInfoPage: View {
    @Binding var task: Task

    var body: some View {
        ZStack{
            Color.background
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text(task.title)
                    .font(.largeTitle)
                    .padding()
                
                Text("Due: \(task.date, formatter: DateFormatter.fullDateTimeFormatter)")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()
                
                Button(action: {
                    task.isCompleted.toggle()
                }) {
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.isCompleted ? .green : .gray)
                        Text(task.isCompleted ? "Mark as Incomplete" : "Mark as Complete")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color(.button))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
            }}
        
        .background(Color.background)
    }
}

extension DateFormatter {
    static var fullDateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}


struct NewTaskButton: View {
    var body: some View {
        HStack {
            Image(systemName: "plus.circle")
            Text("New Task")
        }
        .foregroundColor(.iconscolor)
    }
}

extension DateFormatter {
    static var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
}


import SwiftUI

struct AddNewTaskPage: View {
    @State private var description: String = ""
    @State private var title: String = ""
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var showAlert = false  // State to control alert visibility
    
    @Binding var tasks: [Task]

    var body: some View {
        ZStack {
            // Background color
            Color(.background)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Top Title Section
                    Text("Create New Task")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Task Title and Description Box
                    ZStack {
                        Rectangle()
                            .fill(Color(.box))
                            .cornerRadius(10)
                            .frame(width: 375, height: 200)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Title")
                                .padding(.horizontal)
                                .fontWeight(.bold)
                            
                            TextField("Enter task title", text: $title)
                                .padding(.horizontal)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Divider()
                                .padding(.horizontal)
                            
                            Text("Description")
                                .padding(.horizontal)
                                .fontWeight(.bold)
                            
                            TextField("Enter task description", text: $description)
                                .padding(.horizontal)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                    
                    // Date and Time Toggles with Pickers
                    VStack(spacing: 10) {
                        Toggle("Date", isOn: $showDatePicker)
                            .padding(.horizontal)
                        
                        if showDatePicker {
                            DatePicker(
                                "Select Date",
                                selection: $selectedDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding(.horizontal)
                        }
                        
                        Toggle("Time", isOn: $showTimePicker)
                            .padding(.horizontal)
                        
                        if showTimePicker {
                            DatePicker(
                                "Select Time",
                                selection: $selectedTime,
                                displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(WheelDatePickerStyle())
                            .padding(.horizontal)
                        }
                    }
                    
                    // Create Task Button
                    Button(action: {
                        let combinedDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: selectedTime),
                                                                  minute: Calendar.current.component(.minute, from: selectedTime),
                                                                  second: 0,
                                                                  of: selectedDate) ?? selectedDate
                        let newTask = Task(title: title, subtitle: description, date: combinedDate) // Use the selected date and time
                        tasks.append(newTask) // Append to tasks
                        print("Task Created: \(title) - \(description)")
                        
                        // Show alert after task is created
                        showAlert = true
                    }) {
                        Text("Create Task")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.button) // Replace with your color or define .button
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Task Created"),
                message: Text("Your new task has been successfully added."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// Sample Task for preview
struct AddNewTaskPage_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTaskPage(tasks: .constant([])) // Provide a constant for preview
    }
}

import SwiftUI

struct CreateCoursePage: View {
    @Binding var courses: [Course]  // Binding to courses array
    @State private var courseName: String = ""
    @State private var selectedColor: Color? = nil
    @State private var selectedToast: String? = nil
    @State private var showAlert = false   // Alert for missing information
    @State private var showSuccessAlert = false  // Alert for successful course creation
    
    private let colors: [Color] = [.red, .green, .blue, .yellow, .purple, .orange]
    private let toastImages: [String] = ["toast-1", "toast-2", "toast-3", "toast-4", "toast-5", "toast-6"]
    
    @Environment(\.presentationMode) var presentationMode // Used to go back to the previous screen
    
    var body: some View {
        VStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                Circle()
                    .fill(selectedColor ?? Color.box)
                    .frame(width: 90, height: 90)
                    .shadow(radius: 10)
                
                if let selectedToast = selectedToast {
                    Image(selectedToast)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }
            
            // Course Name Label and Input
            VStack(alignment: .leading) {
                Text("Course Name")
                    .font(.headline)
                    .padding(.top)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.box)
                        .frame(height: 40)
                    
                    TextField("Enter course name", text: $courseName)
                        .padding(.horizontal)
                        .textFieldStyle(PlainTextFieldStyle())
                }
            }
            
            // Color Selection Box
            Text("Pick a Color for the Course Icon")
                .font(.headline)
                .padding(.top)
            
            VStack {
                ForEach(colors.chunked(into: 3), id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                                .padding(4)
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                }
            }
            .frame(width: 250, height: 100)
            .padding()
            .background(Color.box)
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Toast Selection Box
            Text("Pick a Toast Image")
                .font(.headline)
                .padding(.top)
            
            VStack {
                ForEach(toastImages.chunked(into: 3), id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { toast in
                            Image(toast)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding(10)
                                .onTapGesture {
                                    selectedToast = toast
                                }
                        }
                    }
                }
            }
            .frame(width: 250, height: 100)
            .padding()
            .background(Color.box)
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Done Button
            Button(action: {
                if courseName.isEmpty || selectedColor == nil || selectedToast == nil {
                    showAlert = true
                } else {
                    let newCourse = Course(name: courseName, color: selectedColor, toastIcon: selectedToast)
                    courses.append(newCourse)
                    
                    // Clear inputs after adding the course
                    courseName = ""
                    selectedColor = nil
                    selectedToast = nil
                    
                    // Show success alert
                    showSuccessAlert = true
                }
            }) {
                Text("Done")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 100, height: 60)
                    .background(courseName.isEmpty || selectedColor == nil || selectedToast == nil ? Color.gray : Color.button)
                    .cornerRadius(10)
            }
            .disabled(courseName.isEmpty || selectedColor == nil || selectedToast == nil)
            
        }
        .padding()
        .navigationTitle("Create New Course")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Missing Information"),
                message: Text("Please enter a course name, select a color, and pick a toast image."),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Course Created"),
                message: Text("Your course has been successfully added."),
                dismissButton: .default(Text("OK"), action: {
                    // After the success alert is dismissed, go back to the previous screen
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
        .padding(.bottom, 25)
        .background(Color(.background))
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for index in stride(from: 0, to: self.count, by: size) {
            let chunk = Array(self[index..<Swift.min(index + size, self.count)])
            chunks.append(chunk)
        }
        return chunks
    }
}

struct CreateCoursePage_Previews: PreviewProvider {
    static var previews: some View {
        CreateCoursePage(courses: .constant([]))
    }
}

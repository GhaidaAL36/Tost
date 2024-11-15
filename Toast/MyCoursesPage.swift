import SwiftUI

struct MyCoursesPage: View {
    @Binding var courses: [Course] // Use Binding to share state
    @State private var showDeleteAlert = false
    @State private var selectedCourse: Course?

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Color.background
                        .edgesIgnoringSafeArea(.all)

                    if courses.isEmpty {
                        VStack {
                            Text("Ready to learn? Add a course to begin!")
                                .font(.title2)
                                .padding()
                                .multilineTextAlignment(.center)

                            NavigationLink(destination: CreateCoursePage(courses: $courses)) {
                                Text("Add new course")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.button)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                        .background(Color.box)
                        .cornerRadius(20)
                        .padding()
                    } else {
                        VStack {
                            List {
                                ForEach(courses) { course in
                                    NavigationLink(
                                        destination: CoursePageView(course: course),
                                        label: {
                                            HStack {
                                                // Displaying the Course Icon along with the Name
                                                ZStack {
                                                    Circle()
                                                        .fill(course.color ?? Color.box) // Display selected color
                                                        .frame(width: 40, height: 40)
                                                        .shadow(radius: 5)
                                                    
                                                    if let toastImage = course.toastIcon {
                                                        Image(toastImage)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 30, height: 30)
                                                    }
                                                }
                                                .padding(.trailing, 50) // Space between icon and name
                                                
                                                Text(course.name)
                                                    .foregroundColor(.black)
                                                    .padding()

                                                Spacer()

                                                Button(action: {
                                                    selectedCourse = course
                                                    showDeleteAlert = true
                                                }) {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.red)
                                                }
                                                .buttonStyle(BorderlessButtonStyle())
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.box)
                                            .cornerRadius(10)
                                            .padding(.vertical, 5)
                                        }
                                    )
                                }
                                .onDelete(perform: deleteCourse)
                            }
                            .listStyle(PlainListStyle())

                            NavigationLink(destination: CreateCoursePage(courses: $courses)) {
                                Text("Add new course")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.button)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("My Courses")
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Confirm Delete"),
                    message: Text("Are you sure you want to delete \(selectedCourse?.name ?? "this course")?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let courseToDelete = selectedCourse {
                            deleteCourse(course: courseToDelete)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    private func deleteCourse(at offsets: IndexSet) {
        courses.remove(atOffsets: offsets)
    }

    private func deleteCourse(course: Course) {
        if let index = courses.firstIndex(where: { $0.id == course.id }) {
            courses.remove(at: index)
        }
    }
}

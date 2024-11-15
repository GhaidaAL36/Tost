import SwiftUI

struct ContentView: View {
    @State private var courses = [Course]() // State to hold the courses

    
    var body: some View {
        
    
        TabView() {
        
            MainPage()
                .tabItem {
                    
                    Image(systemName: "square.split.2x2")
                    Text("Main")
               
                }
             
            
            MyCoursesPage(courses: $courses) // Pass courses as a Binding
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait")
                    Text("Courses")
            
                }
               
            TimerPage()
                .tabItem {
                    
                    Image(systemName: "timer")
                    Text("Timer")

                }
             
        }
        .accentColor(.red)
    }
}

#Preview {
    ContentView()
}

import SwiftUI

struct MainPage: View {


    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background
                    .edgesIgnoringSafeArea(.all) // Full screen background color
                
                VStack(alignment: .leading, spacing: 20) {
        
                    ZStack {
                        Rectangle()
                            .fill(Color.box)
                            .frame(width: 375, height: 200)
                            .cornerRadius(10)
                        
                        VStack {
                            HStack(spacing: 140) {
                                Text("9h")
                                    .font(.system(size: 20))
                                Text("5")
                                    .font(.system(size: 20))
                            }
                            HStack(spacing: 60) {
                                Text("This week")
                                    .font(.system(size: 20))
                                Text("Total toasts")
                                    .font(.system(size: 20))
                            }
                        }
                        
                        
                        NavigationLink(destination: TimerPage()) {
                            HStack {
                                Text("Let’s start toasting")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                Image("TOAST")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 70)
                                    .cornerRadius(10)
                                Spacer()
                            }
                            .frame(width: 299, height: 20)
                            .padding()
                            .background(Color.button)
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.top, 120)
                        .padding(.leading, 10)
                    }
                    
                    // Today’s Tasks Section

                    Text("Today’s Tasks")
                        .font(.system(size: 25))
                        .bold()

                    // No tasks yet
                    ZStack {
                        Rectangle()
                            .fill(Color.box)
                            .frame(width: 375, height: 117)
                            .cornerRadius(10)
                            
                        VStack {
                            Text("No tasks yet!")
                                .font(.system(size: 20))
                            Text("Add some to get started.")
                                .font(.system(size: 20))
                                .buttonStyle(PlainButtonStyle())
                        }
                    }


                    
                    // My Courses Section
                    Text("My Courses")
                        .font(.system(size: 25))
                        .bold()
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.box)
                            .frame(width: 375, height: 117)
                            .cornerRadius(10)
                            
                        VStack {
                            Text("Ready to learn?")
                                .font(.system(size: 20))
                            Text("Add a course to begin!")
                                .font(.system(size: 20))
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                   
                }
                .padding()
            }
            .navigationTitle("Main Page")
        }
    }
}

#Preview {
    ContentView()
}

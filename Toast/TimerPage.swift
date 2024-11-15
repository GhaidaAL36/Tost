import SwiftUI

struct TimerPage: View {
    @State private var timerValue: Int = 10 // Initial timer value in seconds
    @State private var isTimerRunning: Bool = false
    @State private var isTimerPaused: Bool = false // Track if the timer is paused
    @State private var timer: Timer?

    // State variables for setting time
    @State private var hours: Int = 0
    @State private var minutes: Int = 0

    // Toggle for showing the time picker
    @State private var showTimePicker: Bool = false

    // Flag to track if the time has been set
    @State private var timeSet: Bool = false

    // User input for focus
    @State private var userFocus: String = ""
    
    // State variable to track hover state
    @State private var isHovering: Bool = false

    // New state to track the toast entering the toaster
    @State private var isToastInToaster: Bool = false
    
    // State for showing the stop confirmation alert
    @State private var showStopConfirmation: Bool = false

    // State for showing the burned toast overlay
    @State private var showBurnedToastOverlay: Bool = false

    // State for showing the celebration overlay
    @State private var showCelebrationOverlay: Bool = false
    
    @State private var navigateToMyNotes: Bool = false


    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(spacing: 10) { // Adjusted spacing between elements
                        // Dynamic Title: Show user-entered focus when timer starts
                        Text(isTimerRunning && !userFocus.isEmpty ? userFocus : "TOASTING")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 80)  // Adjusted top padding for title (moves it below the status bar)

                        Text("\(timerValue / 60):\(String(format: "%02d", timerValue % 60))") // Timer display
                            .font(.system(size: 40))

                        if !isTimerRunning && !isTimerPaused  {
                            Button(action: {
                                // Toggle visibility of the time picker
                                showTimePicker.toggle()
                            }) {
                                Text("Set Time")
                                    .frame(width: 90, height: 30)
                                    .padding(5)
                                    .background(isHovering ? Color.iconscolor : Color(.button))  // Change color on hover
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                
                                
                            }
                            .onHover { hovering in
                                isHovering = hovering // Track hover state
                            }
                        }

                        if showTimePicker && !isTimerRunning {
                            VStack {
                                HStack {
                                    // Picker for Hours
                                    Picker("Hours", selection: $hours) {
                                        ForEach(0..<24, id: \.self) { hour in
                                            Text("\(hour) hr").tag(hour)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .accentColor(.iconscolor)

                                    Picker("Minutes", selection: $minutes) {
                                        ForEach(0..<60, id: \.self) { minute in
                                            Text("\(minute) min").tag(minute)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .accentColor(.iconscolor)
                                }

                                // Button to confirm the selected time
                                Button(action: {
                                    // Set the timer value in seconds
                                    timerValue = (hours * 3600) + (minutes * 60)
                                    showTimePicker = false // Hide the picker after setting the time
                                    timeSet = true // Mark time as set
                                }) {
                                    Text("Confirm Time")
                                        .padding()
                                        .background(Color.button)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        }

                        // Images for creativity stacked with one behind the other
                        ZStack(alignment: .center) {
                            // TOASTER image in the front
                            Image("TOASTER") // Replace with your image name
                                .resizable()
                                .scaledToFit()
                                .frame(width: 390, height: 350) // Size for the toaster
                                .offset(y: -1) // Move toaster up to show the bottom half of toast

                            // Animate the toast when the timer starts
                            if !isToastInToaster {
                                Image("TOAST") // Replace with your image name
                                    .resizable()
                                    .scaledToFit()
                                
                                    .frame(width: 400, height: 150)
                                    .offset(y: -120)
                                    .opacity(0.8)
                                    .transition(.move(edge: .bottom))
                            } else {
                                Image("TOAST2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 400, height: 150)
                                    .offset(y: -2)
                                    .animation(.easeInOut(duration: 1), value: isToastInToaster)
                            }
                            Image("TOASTER") // Replace with your image name
                                .resizable()
                                .scaledToFit()
                                .frame(width: 390, height: 350) // Size for the toaster
                                .offset(y: -1)
                        }

                        HStack {
                            if isTimerRunning {
                                Button(action: {
                                    // Show confirmation alert when user clicks Stop Timer
                                    showStopConfirmation = true
                                }) {
                                    Text("Stop Timer")
                                    
                                        .frame(width: 95, height: 30)
                                        .padding(5)
                                        .background(isHovering ? Color.iconscolor : Color.red)  // Change color on hover
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    
                                    
                                    
                                }
                                
                                .onHover { hovering in
                                    isHovering = hovering // Track hover state
                                    
                                }
                            }
                            HStack(){
                            Button(action: {
                                if isTimerRunning {
                                    pauseTimer() // Pause the timer
                                } else if isTimerPaused {
                                    resumeTimer() // Resume the timer from paused state
                                } else {
                                    startTimer() // Start the timer if it was not started before
                                }
                            }) {
                                Text(isTimerPaused ? "Resume" : isTimerRunning ? "Pause Timer" : "Start Timer")
                                    .frame(width: 100, height: 30)
                                
                                    .padding(5)
                                    .background(isHovering ? Color.iconscolor : Color.button)
                                
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(-5)
                                
                            }
                            
                            .padding(-3)
                            .onHover { hovering in
                                isHovering = hovering // Track hover state
                            }}.padding([.leading, .trailing], 20)
                        }

                        // Focus Section (hidden when timer starts or paused)
                        if !isTimerRunning && !isTimerPaused {
                            VStack {
                                ZStack{
                                    Rectangle()
                                        .fill(Color(.box))
                                        .frame(width:70, height: 10)
                                        .cornerRadius(10)
                                    VStack(){
                                       
                                        Text("What do you want to focus on?")
                                            .padding(-1)
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .padding(-1)
                                        TextField("Enter your focus here...", text: $userFocus)
                                            .padding()
                                            .background(Color.box)
                                            .cornerRadius(10)
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                    }
                                }
                                .padding(8)

                               
                                .padding(.top, 10)
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background(Color(.background)) // Apply background color
                }
            }
            
            // Overlay for burned toast with message
            if showBurnedToastOverlay {
                ZStack {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    Rectangle()
                        .fill(Color(.background)) // Second Rectangle
                        .frame(width: 375, height: 300)
                        .cornerRadius(10)
                    VStack {
                        Image("TOASTBURN") // Replace with your burned toast image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)

                        Text("YOU BURNED THE TOAST!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        Button(action: {
                            resetToNormalState()
                            showBurnedToastOverlay = false
                        }) {
                            Text("Try again")
                                .background(Color.button)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(Color.button)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top, -55)
                }
            }

            // Overlay for celebrating success
            if showCelebrationOverlay {
                NavigationStack {
                    ZStack {
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                        Rectangle()
                            .fill(Color(.background)) // Second Rectangle
                            .frame(width: 375, height: 300)
                            .cornerRadius(10)
                        VStack {
                            Image("TOASTPARTY")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .offset(y: 30)

                            Text("WELL DONE! \nYou Made It! 🎉🎉")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .offset(y: -20)

                            Text("Do you want to add a note?")
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .offset(y: -20)

                            HStack {
                                // NavigationLink setup without manual state management
                                NavigationLink("Yes", value: "Yes")
                                    .frame(width: 60, height: 40)
                                    .background(Color.button)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.bottom, 80)

                                Button(action: {
                                    // Handle "No" response
                                    resetToNormalState()
                                    showCelebrationOverlay = false
                                }) {
                                    Text("No")
                                        .frame(width: 60, height: 40)
                                        .background(Color.button)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .padding(.bottom, 80)
                                }
                            }
                        }
                    }
                    // Define the navigation destination for "Yes"
                    .navigationDestination(for: String.self) { value in
                        if value == "Yes" {
                            MyNotesPage()
                        }
                    }
                }


            }
        }
        .background(Color(.background)) // Apply background color to the entire view
        .edgesIgnoringSafeArea(.top) // Apply safe area edge ignoring only to the top
        .alert(isPresented: $showStopConfirmation) {
            Alert(
                title: Text("Are you sure you want to stop toasting?"),
                primaryButton: .destructive(Text("Yes") ){
                    stopTimer() // Stop the timer if "Yes" is clicked
                    showBurnedToastOverlay = true // Show the burned toast overlay
                },
                secondaryButton: .cancel {
                    // Do nothing, just dismiss the alert
                }
            )
        }
    }

    func startTimer() {
        if !isTimerRunning {
            isTimerRunning = true
            // Trigger animation for toast entering toaster after a short delay (to simulate it cooking)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    isToastInToaster = true // Change the toast position to inside the toaster
                }
            }

            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.timerValue > 0 {
                    self.timerValue -= 1
                } else {
                    self.timer?.invalidate()
                    self.isTimerRunning = false
                    showCelebrationOverlay = true // Show celebration overlay when timer finishes
                }
            }
        }
    }

    func pauseTimer() {
        timer?.invalidate() // Stop the timer
        isTimerRunning = false
        isTimerPaused = true // Indicate that the timer is paused
        
        // Animate toast out of the toaster
        withAnimation {
            isToastInToaster = false
        }
    }

    func resumeTimer() {
        // Restart the timer
        startTimer()
        
        // Animate toast back into the toaster
        withAnimation {
            isToastInToaster = true
        }
        
        isTimerPaused = false
    }

    func stopTimer() {
        timer?.invalidate()
        isTimerRunning = false
        isTimerPaused = false // Reset paused state
        // Allow time to be reset after stopping
        timeSet = false // Reset time set flag
        timerValue = 60 // Reset timer value (adjust if necessary)
    }

    func resetToNormalState() {
        // Reset state for "Try again"
        isToastInToaster = false
        timerValue = 60
        timeSet = false
        showBurnedToastOverlay = false
        showCelebrationOverlay = false // Hide celebration overlay
        isTimerRunning = false
        isTimerPaused = false
        userFocus = ""
    }
}

#Preview {
    TimerPage()
}

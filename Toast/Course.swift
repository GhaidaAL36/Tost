import SwiftUI

// Course model to represent a course
struct Course: Identifiable {
    let id = UUID()
    var name: String
    var color: Color?
    var toastIcon: String?
}

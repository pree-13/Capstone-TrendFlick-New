import SwiftUI

class OnboardingViewModel: ObservableObject {
  @Published var isOnboardingComplete: Bool {
    didSet {
      UserDefaults.standard.set(isOnboardingComplete, forKey: "OnboardingComplete")
    }
  }
  init() {
    self.isOnboardingComplete = UserDefaults.standard.bool(forKey: "OnboardingComplete")
  }
}

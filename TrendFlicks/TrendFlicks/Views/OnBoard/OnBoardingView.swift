import SwiftUI

struct OnboardingView: View {
  @StateObject private var viewModel = OnboardingViewModel()

  var body: some View {
    if viewModel.isOnboardingComplete {
      ContentView(dataStore: DataStore())
    } else {
      OnBoardUserView(viewModel: viewModel)
    }
  }
}

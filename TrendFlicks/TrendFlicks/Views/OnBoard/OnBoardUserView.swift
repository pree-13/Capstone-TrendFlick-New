import SwiftUI

struct OnBoardUserView: View {
  @ObservedObject var viewModel: OnboardingViewModel
  @State private var currentTabIndex: Int = 0

  var body: some View {
    TabView(selection: $currentTabIndex) {
      OnboardingScreen(
        imageName: "LaunchImage",
        title: "Welcome to TrendFlicks",
        isLastScreen: true
      ) {
        viewModel.isOnboardingComplete = true
      }
      .tag(0)
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    .onAppear {
      currentTabIndex = 0
    }
  }
}

struct OnboardingScreen: View {
  var imageName: String
  var title: String
  var isLastScreen: Bool
  var action: () -> Void

  @Environment(\.verticalSizeClass)
  var verticalSizeClass
  @Environment(\.horizontalSizeClass)
  var horizontalSizeClass

  var body: some View {
    if verticalSizeClass == .compact {
      HStack {
        Image(imageName)
          .resizable()
          .scaledToFit()
          .frame(width: 380, height: 320)

        VStack {
          Text(title)
            .font(.title)
            .padding()
            .accessibilityIdentifier("welcomeLabel")

          if isLastScreen {
            Button(action: action) {
              Text("Get Started Now")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(10)
                .accessibilityIdentifier("getStartedButton")
            }
            .padding(.bottom, 40)
          }
        }
      }
    } else {
      VStack {
        Image(imageName)
          .resizable()
          .scaledToFill()
          .frame(width: 320, height: 480)

        Text(title)
          .font(.title)
          .padding()
          .accessibilityIdentifier("welcomeLabel")

        if isLastScreen {
          Button(action: action) {
            Text("Get Started Now")
              .font(.headline)
              .foregroundColor(.white)
              .padding()
              .background(Color.accentColor)
              .cornerRadius(10)
              .accessibilityIdentifier("getStartedButton")
          }
          .padding(.bottom, 40)
        }
      }
    }
  }
}


struct OnBoardUserView_Previews: PreviewProvider {
  static var previews: some View {
    OnBoardUserView(viewModel: OnboardingViewModel())
  }
}

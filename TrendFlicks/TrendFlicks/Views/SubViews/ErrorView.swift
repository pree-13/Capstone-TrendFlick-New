import SwiftUI

struct ErrorView: View {
  let error: String

  var body: some View {
    VStack(alignment: .center, spacing: 12) {
      Image("error")
        .resizable()
        .scaledToFit()
        .padding(.leading, 20)
        .frame(width: 150, height: 150)
        .accessibilityIdentifier("errorImage")
      Text("Ooops!")
        .font(.largeTitle)
        .bold()
        .accessibilityIdentifier("errorTitle")
      Text(error)
        .multilineTextAlignment(.center)
        .accessibilityIdentifier("errorMessage")
    }
    .frame(maxWidth: .infinity)
    .listRowSeparator(.hidden)
    .padding()
    .accessibilityIdentifier("errorView")
  }
}

struct ErrorView_Previews: PreviewProvider {
  static var previews: some View {
    ErrorView(error: "This is Error")
  }
}

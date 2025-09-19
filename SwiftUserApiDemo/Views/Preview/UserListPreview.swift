#if DEBUG
import SwiftUI
import UIKit
import Combine

struct UserListPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let viewModel = UserListViewModel(fetchUseCase: FetchUsersUseCaseMock())
            let vc = UserListViewController(viewModel: viewModel)
            return UINavigationController(rootViewController: vc)
        }
        .previewDevice("iPhone 16 Pro")
    }
}

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    
    // 這個 closure 回傳你要預覽的 UIViewController
    let viewController: () -> ViewController

    func makeUIViewController(context: Context) -> ViewController {
        viewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // 不需要做任何更新
    }
}

class FetchUsersUseCaseMock: FetchUsersUseCaseProtocol {
    func execute() -> AnyPublisher<[User], any Error> {
        let users = [
            User(id: 1, name: "Tom Chen", username: "tom123", email: "tom@example.com", phone: "12345678", website: "example.com", address: User.Address(street: "123 Main St", suite: "Apt 456", city: "New York", zipcode: "10001", geo: User.Address.Geo(lat: "", lng: "")), company: User.Company(name: "", catchPhrase: "", bs: "")),
            User(id: 2, name: "Alice Lin", username: "alice456", email: "alice@example.com", phone: "87654321", website: "alice.com", address: User.Address(street: "123 Main St", suite: "Apt 456", city: "New York", zipcode: "10001", geo: User.Address.Geo(lat: "", lng: "")), company: User.Company(name: "", catchPhrase: "", bs: "")),
            User(id: 3, name: "Bob Wang", username: "bob789", email: "bob@example.com", phone: "11122233", website: "bob.com", address: User.Address(street: "123 Main St", suite: "Apt 456", city: "New York", zipcode: "10001", geo: User.Address.Geo(lat: "", lng: "")), company: User.Company(name: "", catchPhrase: "", bs: ""))
        ]
        return Just(users)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

    }
}


#endif

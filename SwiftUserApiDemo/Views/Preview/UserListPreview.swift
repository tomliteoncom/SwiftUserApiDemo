#if DEBUG
import SwiftUI
import UIKit
import Combine
import Foundation

struct UserListPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // 從 Bundle 中讀取 users.json 的 mock
            let jsonMock = FetchUsersUseCaseJSONMock(fileName: "users", bundle: .main)
            let viewModel = UserListViewModel(fetchUseCase: jsonMock)
            let vc = UserListViewController(viewModel: viewModel)
            return UINavigationController(rootViewController: vc)
        }
        .previewDevice("iPhone 16 Pro")
        .previewDisplayName("Users from users.json")
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

// 以 JSON 檔案為資料來源的 UseCase mock
final class FetchUsersUseCaseJSONMock: FetchUsersUseCaseProtocol {
    private let fileName: String
    private let bundle: Bundle

    init(fileName: String = "users", bundle: Bundle = .main) {
        self.fileName = fileName
        self.bundle = bundle
    }

    func execute() -> AnyPublisher<[User], Error> {
        Deferred {
            Future { promise in
                do {
                    let users = try JSONLoader.loadUsers(from: self.bundle, fileName: self.fileName)
                    promise(.success(users))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// 簡單的 JSON 載入工具
private enum JSONLoader {
    enum JSONLoaderError: LocalizedError {
        case fileNotFound(String)

        var errorDescription: String? {
            switch self {
            case .fileNotFound(let name):
                return "找不到 \(name).json，請確認檔案已加入 Target 的 Copy Bundle Resources。"
            }
        }
    }

    static func loadUsers(from bundle: Bundle = .main, fileName: String = "users") throws -> [User] {
        // 先從指定 bundle 尋找，找不到再嘗試用此檔案所屬的 bundle
        let url =
            bundle.url(forResource: fileName, withExtension: "json")
            ?? Bundle(for: BundleToken.self).url(forResource: fileName, withExtension: "json")

        guard let url else {
            throw JSONLoaderError.fileNotFound(fileName)
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        // 預設鍵名與 User 結構相符（id/name/username/email/phone/website/address/company）
        return try decoder.decode([User].self, from: data)
    }

    // 用來定位當前檔案的 bundle
    private final class BundleToken {}
}

#endif

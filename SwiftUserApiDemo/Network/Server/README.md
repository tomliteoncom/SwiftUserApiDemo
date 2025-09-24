# SwiftUserApiDemo

一個使用 UIKit + MVVM + Repository + Combine 的示範專案。App 會從遠端 API（或本機 Flask 伺服器）抓取 users 列表，支援：
- 清單顯示與點進詳細頁
- 右上角 Refresh 手動重新整理
- 週期性自動更新（預設每 30 秒）
- SwiftUI Preview 可從 users.json 匯入假資料

---

## 環境需求
- Xcode 15 以上（建議 15.4+ 或 16）
- iOS 16+（Deployment Target 可自行調整）
- 若使用本機伺服器：Python 3.9+、Flask

---

## 技術棧與架構
- 語言：Swift
- UI：UIKit（程式碼化）
- 非同步：Combine（Publisher/Subscriber）
- 架構：MVVM + Repository + UseCase
- 預覽：SwiftUI Preview（僅 DEBUG）

資料流向：
ViewController ↔ ViewModel → UseCase → Repository → APIClient → 網路/本機
                         ↑（觀察 users 週期更新）

---

## 專案結構（重點檔案）
- Domain / Model
  - User.swift
- Domain / UseCase
  - FetchUsersUseCaseProtocol.swift
- Data
  - UserRepository.swift
  - UserRepositoryImpl.swift（切換遠端或本機 URL）
  - APIClient / APIClientProtocol（未列於此說明，但由 Repository 依賴）
- Presentation
  - UserListViewModel.swift
  - UserListViewController.swift
  - UserDetailViewController.swift
- Composition
  - SceneFactory.swift（組裝場景）
- Preview（DEBUG）
  - UserListPreview.swift（從 users.json 載入假資料）
- Backend（可選）
  - app.py（Flask）
  - users.json（假資料）

---

## 快速開始（iOS App）

1) 下載專案並以 Xcode 開啟
2) 設定資料來源（二擇一）：
   - 使用線上示例（預設）  
     在 UserRepositoryImpl.swift 內：
     ```swift
     private let usersURL = URL(string: "https://jsonplaceholder.typicode.com/users")!

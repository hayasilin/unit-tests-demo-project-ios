# iOS單元測試範例專案

這是我的[iOS單元測試規範的](https://github.com/hayasilin/unit-tests-ios-guide)的後續repo。

此Repo包含了模擬真實世界的iOS範例專案，示範如何在iOS專案寫充足的單元測試，並達到良好的程式碼覆蓋率。

- 此專案是用Xcode 11開發。
- 此專案使用MVVM模式開發（並無使用Coordinator）

## 程式碼覆蓋率結果

程式碼覆蓋率是**77%**

<img src="https://github.com/hayasilin/unit-tests-ios-demo-project/blob/master/resources/code_coverage_77.png">

## 更高的程式碼覆蓋率

如果我移除了此專案沒有使用到的程式碼，比如在AppDelegate.swift裡的iOS系統返回(Callback)以及Core Data程式碼，並移除在ApiClient.swift裡的extension程式碼，程式碼覆蓋率可以更高，達到**92%**。

<img src="https://github.com/hayasilin/unit-tests-ios-demo-project/blob/master/resources/code_coverage_92.png">

# CompanionVoiceSDK

## 📖 概要
**CompanionVoiceSDK** は、AIコンパニオンの「声」を定義・生成・保存するための専用モジュールです。  
スタイル・トーン・話速といった音声プロファイルを明確に分離し、再現性の高い設計で **声の保存・推定・編集** を可能にします。  

---

## ✨ 特徴
- **VoiceProfile**  
  コンパニオンごとの声のスタイル・トーン・速度を統合的に管理。  
- **VoiceExtensions**  
  ファイル名生成、アセットフォルダ保証、AVSpeechUtterance へのマッピング。  
- **VoiceGenerator**  
  スタイル・トーン・速度に基づき音声ファイルを生成。  
- **VoiceInference**  
  顔特徴量などから声のプロファイルを自動推定。  
- **VoiceStorage / VoiceManager**  
  プロファイルの保存・切り替え・アクティブ管理。  

---

## 📦 インストール
Swift Package Manager (SPM) を利用してプロジェクトに追加できます。

```swift
dependencies: [
    .package(url: "https://github.com/Juke16gt4/CompanionVoiceSDK.git", from: "1.0.0")
]
```

---

## 🚀 使用例

### ファイル名生成
```swift
let profile = VoiceProfile(style: .gentle, tone: .neutral, speed: .normal)
let filename = VoiceExtensions.filename(for: profile)
// → "gentle_neutral_normal.m4a"
```

### 音声生成
```swift
VoiceGenerator.shared.generate(style: .energetic, tone: .bright, speed: .fast) { url in
    print("生成された音声ファイル: \(url?.path ?? "失敗")")
}
```

### 話速・トーンのマッピング
```swift
let rate = VoiceExtensions.mapSpeedToRate(.slow)   // 0.40
let pitch = VoiceExtensions.mapToneToPitch(.bright) // 1.20
```

---

## 📂 構成
```
CompanionVoiceSDK/
 ├─ Models/
 │   ├─ VoiceStyle.swift
 │   ├─ VoiceTone.swift
 │   ├─ VoiceSpeed.swift
 │   └─ VoiceProfile.swift
 ├─ Utilities/
 │   └─ VoiceExtensions.swift
 ├─ Managers/
 │   └─ VoiceManager.swift
 ├─ Services/
 │   └─ VoiceInference.swift
 ├─ Generators/
 │   └─ VoiceGenerator.swift
 ├─ Storage/
 │   └─ VoiceStorage.swift
 └─ Tests/
     └─ CompanionVoiceSDKTests.swift
```

---

## 🌐 他SDKとの連携
- **CompanionSpeechSDK**: 音声認識・合成を統合し、VoiceProfile を反映。  
- **EmotionSDK**: 感情ログを保存し、VoiceProfile に基づいた声で振り返りを再生。  
- **CompanionsSDK**: UIとプロフィール管理を担当し、VoiceProfile をユーザー設定に反映。  

---

## 📜 ライセンス
CompanionVoiceSDK は MIT ライセンスの下で公開されています。詳細は [LICENSE](./LICENSE) を参照してください。  


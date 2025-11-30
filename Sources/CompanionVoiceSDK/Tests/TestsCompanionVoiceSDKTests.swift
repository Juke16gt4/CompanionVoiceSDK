//
//  TestsCompanionVoiceSDKTests.swift
//  CompanionVoiceSDKTests
//
//  📂 格納場所:
//      CompanionVoiceSDK/Tests/TestsCompanionVoiceSDKTests.swift
//
//  🎯 ファイルの目的:
//      CompanionVoiceSDK の主要機能をユニットテストする。
//      - VoiceProfile の保存/復元
//      - VoiceExtensions のマッピング
//      - VoiceInference の推定
//      - VoiceManager のアクティブ管理
//
//  🔗 依存:
//      - XCTest
//      - CompanionVoiceSDK
//
//  👤 作成者: 津村 淳一
//  📅 作成日: 2025年11月30日
//

import XCTest
@testable import CompanionVoiceSDK

final class TestsCompanionVoiceSDKTests: XCTestCase {

    func testVoiceStorageSaveAndLoad() {
        let profile = VoiceProfile(
            companionID: UUID(),
            style: .gentle,
            tone: .neutral,
            speed: .normal,
            assetFolderURL: URL(fileURLWithPath: "/tmp")
        )
        VoiceStorage.saveActive(profile)
        let loaded = VoiceStorage.loadActive(companionID: profile.companionID)
        XCTAssertEqual(loaded?.style, .gentle)
        XCTAssertEqual(loaded?.tone, .neutral)
        XCTAssertEqual(loaded?.speed, .normal)
    }

    func testVoiceExtensionsFilename() {
        let profile = VoiceProfile(
            companionID: UUID(),
            style: .energetic,
            tone: .bright,
            speed: .fast,
            assetFolderURL: URL(fileURLWithPath: "/tmp")
        )
        let filename = VoiceExtensions.filename(for: profile)
        XCTAssertTrue(filename.contains("energetic_bright_fast"))
    }

    func testVoiceExtensionsMapping() {
        XCTAssertEqual(VoiceExtensions.mapSpeedToRate(.slow), 0.40)
        XCTAssertEqual(VoiceExtensions.mapToneToPitch(.bright), 1.20)
    }

    func testVoiceInferenceProfile() {
        let features = FacialFeatures(jawSharpness: 0.8, eyeSize: 0.5, softness: 0.3, energy: 0.9)
        let inference = VoiceInference()
        let profile = inference.inferProfile(for: UUID(), features: features, assetFolderURL: URL(fileURLWithPath: "/tmp"))
        XCTAssertEqual(profile.style, .energetic)
        XCTAssertEqual(profile.speed, .fast)
    }

    func testVoiceManagerSwitchCompanion() {
        let id1 = UUID()
        let id2 = UUID()
        let profile1 = VoiceProfile(companionID: id1, style: .calm, tone: .neutral, speed: .normal, assetFolderURL: URL(fileURLWithPath: "/tmp"))
        VoiceStorage.saveActive(profile1)

        VoiceManager.shared.bootstrapActiveVoice(for: id1)
        XCTAssertEqual(VoiceManager.shared.getActiveVoice()?.style, .calm)

        VoiceManager.shared.switchCompanion(to: id2)
        XCTAssertNil(VoiceManager.shared.getActiveVoice())
    }
}

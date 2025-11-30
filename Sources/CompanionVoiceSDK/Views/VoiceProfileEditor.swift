//
//  VoiceProfileEditor.swift
//  QuestMe
//
//  📂 格納場所:
//      QuestMe/Views/Companion/VoiceProfileEditor.swift
//
//  🎯 ファイルの目的:
//      コンパニオンの VoiceProfile（Style/Tone/Speed）を編集・プレビュー・保存する共通ビュー。
//      - AVSpeechSynthesizer によるプレビュー再生。
//      - 保存時に VoiceGenerator で音声ファイルを生成し、コンパニオンのアセットフォルダへ保存。
//      - VoiceManager/VoiceRepository 経由でアクティブ音声として永続化。
//      - CompanionOverlay へ即時反映可能なフックを用意。
//
//  🔗 依存:
//      - SwiftUI
//      - AVFoundation
//      - CompanionVoiceSDK（VoiceProfile/VoiceStyle/VoiceTone/VoiceSpeed/VoiceGenerator/VoiceManager/VoiceRepository/VoiceExtensions）
//      - EmotionType.swift（ヘルプ音声などの発話感情）
//      - CompanionOverlay（保存時の通知発話に利用）
//
//  🔗 関連/連動ファイル:
//      - CompanionSettingsView.swift（編集画面として組み込み）
//      - ProfileCreationFlow.swift（初期生成後の編集へ遷移）
//      - CompanionProfileRepository.swift（プロフィール保存）
//
//  👤 作成者: 津村 淳一
//  📅 作成日: 2025年11月24日
//

import SwiftUI
import AVFoundation

struct VoiceProfileEditor: View {
    // 対象コンパニオンのIDと、アセットフォルダ（画像と同居）を受け取る
    let companionID: UUID
    let assetFolderURL: URL

    // 編集対象の現在のプロファイル（起動時は VoiceManager から復元）
    @State private var style: VoiceStyle
    @State private var tone: VoiceTone
    @State private var speed: VoiceSpeed

    // プレビュー用
    @State private var synthesizer = AVSpeechSynthesizer()
    @State private var isSpeaking = false
    @State private var isSaving = false
    @Environment(\.dismiss) private var dismiss

    init(companionID: UUID, assetFolderURL: URL, initialProfile: VoiceProfile?) {
        self.companionID = companionID
        self.assetFolderURL = assetFolderURL

        let base = initialProfile ?? VoiceManager.shared.getActiveVoice()
        _style = State(initialValue: base?.style ?? .gentle)
        _tone  = State(initialValue: base?.tone  ?? .neutral)
        _speed = State(initialValue: base?.speed ?? .normal)
    }

    var body: some View {
        Form {
            Section(NSLocalizedString("VoiceStyleSection", comment: "声のタイプ")) {
                Picker(NSLocalizedString("VoiceStylePicker", comment: "スタイル"), selection: $style) {
                    ForEach(VoiceStyle.allCases, id: \.self) { s in
                        Text(label(for: s)).tag(s)
                    }
                }
            }

            Section(NSLocalizedString("VoiceToneSection", comment: "声色")) {
                Picker(NSLocalizedString("VoiceTonePicker", comment: "トーン"), selection: $tone) {
                    ForEach(VoiceTone.allCases, id: \.self) { t in
                        Text(label(for: t)).tag(t)
                    }
                }
            }

            Section(NSLocalizedString("VoiceSpeedSection", comment: "話速")) {
                Picker(NSLocalizedString("VoiceSpeedPicker", comment: "速度"), selection: $speed) {
                    ForEach(VoiceSpeed.allCases, id: \.self) { v in
                        Text(label(for: v)).tag(v)
                    }
                }
            }

            Section {
                HStack {
                    Button(NSLocalizedString("Preview", comment: "プレビュー再生")) {
                        let profile = VoiceProfile(
                            companionID: companionID,
                            style: style,
                            tone: tone,
                            speed: speed,
                            assetFolderURL: assetFolderURL
                        )
                        speakSample(for: profile)
                        isSpeaking = true
                        CompanionOverlay.shared.speak(NSLocalizedString("VoicePreviewPlaying", comment: "プレビューを再生します。"), emotion: .neutral)
                    }
                    Spacer()
                    Button(NSLocalizedString("Save", comment: "保存")) {
                        saveProfile()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isSaving)
                }
                if isSpeaking {
                    Text("🎧 \(NSLocalizedString("Playing", comment: "再生中…"))").foregroundColor(.blue)
                }
                if isSaving {
                    Text("💾 \(NSLocalizedString("Saving", comment: "保存中…"))").foregroundColor(.gray)
                }
            }
        }
        .navigationTitle(NSLocalizedString("EditCompanionVoice", comment: "コンパニオンの声を編集"))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(NSLocalizedString("Back", comment: "もどる")) { dismiss() }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(NSLocalizedString("Help", comment: "ヘルプ")) {
                    CompanionOverlay.shared.speak(NSLocalizedString("VoiceEditHelp", comment: "スタイル・声色・速度を選び、プレビューして保存してください。"), emotion: .gentle)
                }
            }
        }
    }

    private func speakSample(for profile: VoiceProfile) {
        let utterance = AVSpeechUtterance(string: NSLocalizedString("VoiceSampleText", comment: "こんにちは、私はあなたの寄り添うコンパニオンです。"))
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = VoiceExtensions.mapSpeedToRate(profile.speed)
        utterance.pitchMultiplier = VoiceExtensions.mapToneToPitch(profile.tone)
        synthesizer.speak(utterance)
    }

    private func saveProfile() {
        isSaving = true
        let baseProfile = VoiceProfile(
            companionID: companionID,
            style: style,
            tone: tone,
            speed: speed,
            assetFolderURL: VoiceExtensions.ensureCompanionAssetFolder(assetFolderURL)
        )
        VoiceGenerator.shared.generate(profile: baseProfile) { updated in
            // アクティブ音声へ反映・永続化
            VoiceManager.shared.setActiveVoice(updated)
            VoiceRepository().saveActive(updated)

            CompanionOverlay.shared.speak(NSLocalizedString("VoicePrefSaved", comment: "声の設定を保存しました。"), emotion: .happy)
            isSaving = false
        }
    }

    private func label(for style: VoiceStyle) -> String {
        switch style {
        case .calm:      return NSLocalizedString("VoiceStyleCalm", comment: "落ち着いた")
        case .energetic: return NSLocalizedString("VoiceStyleEnergetic", comment: "元気")
        case .gentle:    return NSLocalizedString("VoiceStyleGentle", comment: "優しい")
        case .lively:    return NSLocalizedString("VoiceStyleLively", comment: "軽快")
        case .sexy:      return NSLocalizedString("VoiceStyleSexy", comment: "セクシー")
        case .mentor:    return NSLocalizedString("VoiceStyleMentor", comment: "メンター")
        case .friendly:  return NSLocalizedString("VoiceStyleFriendly", comment: "フレンドリー")
        case .coach:     return NSLocalizedString("VoiceStyleCoach", comment: "コーチ")
        }
    }

    private func label(for tone: VoiceTone) -> String {
        switch tone {
        case .neutral: return NSLocalizedString("VoiceToneNeutral", comment: "ノーマル")
        case .husky:   return NSLocalizedString("VoiceToneHusky", comment: "ハスキー")
        case .bright:  return NSLocalizedString("VoiceToneBright", comment: "高め")
        case .deep:    return NSLocalizedString("VoiceToneDeep", comment: "低め")
        case .soft:    return NSLocalizedString("VoiceToneSoft", comment: "柔らかめ")
        }
    }
}

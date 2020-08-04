//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

import Foundation
import PromiseKit

@objc
public enum StickerType: UInt {
    case webp
    case signalLottie

    public static func stickerType(forContentType contentType: String?) -> StickerType {
        if let contentType = contentType {
            switch contentType {
            case OWSMimeTypeWebp:
                return .webp
            case OWSMimeTypeLottieSticker:
                return .signalLottie
            default:
                owsFailDebug("Unknown content type: \(contentType)")
                return .webp
            }
        } else {
            // Unknown contentType, assume webp.
            return .webp
        }
    }

    public var contentType: String {
        switch self {
        case .webp:
            return OWSMimeTypeWebp
        case .signalLottie:
            return OWSMimeTypeLottieSticker
        }
    }

    public var fileExtension: String {
        switch self {
        case .webp:
            return "webp"
        case .signalLottie:
            return "lottieSticker"
        }
    }
}

// MARK: - StickerMetadata

@objc
public class StickerMetadata: NSObject {
    @objc
    public let stickerInfo: StickerInfo

    @objc
    public var packId: Data {
        return stickerInfo.packId
    }

    @objc
    public var packKey: Data {
        return stickerInfo.packKey
    }

    @objc
    public var stickerId: UInt32 {
        return stickerInfo.stickerId
    }

    @objc
    public let stickerType: StickerType

    @objc
    public let stickerDataUrl: URL

    // May contain multiple emoji.
    @objc
    public let emojiString: String?

    @objc
    public required init(stickerInfo: StickerInfo,
                         stickerType: StickerType,
                         stickerDataUrl: URL,
                         emojiString: String?) {
        self.stickerInfo = stickerInfo
        self.stickerType = stickerType
        self.stickerDataUrl = stickerDataUrl
        self.emojiString = emojiString
    }

    @objc
    public var firstEmoji: String? {
        StickerManager.firstEmoji(inEmojiString: emojiString)
    }

    @objc
    public var contentType: String {
        stickerType.contentType
    }

    @objc
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? StickerMetadata else {
            return false
        }
        return stickerInfo.asKey() == other.stickerInfo.asKey()
    }

    @objc
    public override var hash: Int {
        stickerInfo.asKey().hashValue
    }
}

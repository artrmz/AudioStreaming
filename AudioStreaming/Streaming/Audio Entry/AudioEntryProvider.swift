//
//  Created by Dimitrios Chatzieleftheriou on 11/11/2020.
//  Copyright © 2020 Decimal. All rights reserved.
//

import AVFoundation

protocol AudioEntryProviding {
    func provideAudioEntry(url: URL) -> AudioEntry?
}

final class AudioEntryProvider: AudioEntryProviding {
    private let underlyingQueue: DispatchQueue
    private let outputAudioFormat: AVAudioFormat

    init(underlyingQueue: DispatchQueue,
         outputAudioFormat: AVAudioFormat)
    {
        self.underlyingQueue = underlyingQueue
        self.outputAudioFormat = outputAudioFormat
    }

    func provideAudioEntry(url: URL) -> AudioEntry? {
        guard let source = self.source(for: url) else {
            return nil
        }
        
        return AudioEntry(source: source,
                          entryId: AudioEntryId(id: url.absoluteString),
                          outputAudioFormat: outputAudioFormat)
    }

    func provideFileAudioSource(url: URL) -> CoreAudioStreamSource {
        FileAudioSource(url: url, underlyingQueue: underlyingQueue)
    }

    func source(for url: URL) -> CoreAudioStreamSource? {
        guard url.isFileURL else {
            return nil
        }
        
        return provideFileAudioSource(url: url)
    }
}

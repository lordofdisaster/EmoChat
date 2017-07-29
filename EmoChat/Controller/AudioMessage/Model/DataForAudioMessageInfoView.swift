//
//  File.swift
//  EmoChat
//
//  Created by Nikolay Dementiev on 09.07.17.
//  Copyright © 2017 SoftServe. All rights reserved.
//

import UIKit

struct DataForAudioMessageInfoView: DataForMediaMessageInfoProtocol {

    var captionLabel: String?
    var url: String?

    init(url: String?) {
        self.url = url
    }

    init(captionLabel: String?,
         url: String?) {

        self.captionLabel = captionLabel
        self.url = url
    }

    init(dict dicTemData: [String: Any?]) {
        self.captionLabel = dicTemData["captionLabel"] as? String ?? ""
        self.url =  dicTemData["url"] as? String ?? ""
    }
}

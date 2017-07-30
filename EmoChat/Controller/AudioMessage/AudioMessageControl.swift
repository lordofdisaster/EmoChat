//
//  AudioMessageControl.swift
//  EmoChat
//
//  Created by Nikolay Dementiev on 25.07.17.
//  Copyright © 2017 SoftServe. All rights reserved.
//

import UIKit
import AVFoundation


class AudioMessageControl: NSObject, AVAudioRecorderDelegate {//UIViewController,

    weak var audioMessageWaveForm: AudioMessageWaveForm?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var settings = [String : Int]()
    var player = AVPlayer()

    var audioSecondsVal: Double {
        get {
            //            var valueForReturn: Double = 0.0
            //            if let tempVal = player.currentItem?.duration {
            //                valueForReturn = CMTimeGetSeconds(tempVal)
            //            }
            let valueForReturn = calcLenthOfAudioFile()
            return valueForReturn.roundTo(places: 2)
        }
    }

    static func cInit() -> AudioMessageControl {
        let newInstance = AudioMessageControl()
        newInstance.initiateSVariable()

        return newInstance
    }

    func initiateSVariable() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in

                DispatchQueue.main.async {
                    if allowed {
//                        print("Allow")
                    } else {
                        print("RecordPermission: Dont Allow")
                    }
                }
            }
        } catch {
            print("failed to record!")
        }

        // Audio Settings

        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

    }

    //MARK - directoryURL

    func directoryURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
//        print(soundURL)
        return soundURL as URL?
    }

    //MARK - StartRecording
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,
                                                settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            finishRecording(success: false)
        }
        do {
            try audioSession.setActive(true)
            audioRecorder.record()

        } catch {
        }
    }

    //MARK - finishRecording

    func finishRecording(success: Bool) {
        guard let notNullAudioRecorder =  audioRecorder else {
            print("Somthing Wrong.")
            return
        }

        notNullAudioRecorder.stop()
        if success {
            print("success")

//            audioMessageToAnalyze(url: audioRecorder.url)
//            self.WaveFormView.setNeedsDisplay()
        } else {
            audioRecorder = nil
            print("Somthing Wrong.")
        }
    }

    func startAudioRecorder() {
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
        }

        DispatchQueue.main.async {
            self.startRecording()
        }
    }

    func stopAudioRecorder() {
        self.finishRecording(success: true)
    }

    //MARK - audioRecorderDidFinishRecording

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }


    //MARK - Play

    func urlOfCurrentlyPlayingInPlayer(player: AVPlayer) -> URL? {
        return ((player.currentItem?.asset) as? AVURLAsset)?.url
    }

    func urlOfCurrentlyPlayingInPlayer() -> URL? {
        return  urlOfCurrentlyPlayingInPlayer(player: self.player)
    }

    func calcLenthOfAudioFile() -> Double {
        var valueForReturn: Double = 0
        if let urlFromPlayer = urlOfCurrentlyPlayingInPlayer(player: self.player) {
            let asset: AVURLAsset = AVURLAsset.init(url: urlFromPlayer)
            let durationInSeconds: Double = CMTimeGetSeconds(asset.duration)

            valueForReturn = durationInSeconds
        }
        return valueForReturn
    }

//    func showCalcLenthOfAudioFile() {
//        self.audioSecondsValLabel.text = String(audioSecondsVal)
//    }

    func initPlayer (url: URL) {
        print("URL: \(url)")

        self.player = AVPlayer(url: url)
//        self.player.prepareToPlay() //!
        self.player.volume = 1.0
        // self.player.play()
//        self.PSButtonOutfit.setImage(#imageLiteral(resourceName: "PlayAudioMessage"), for: .normal)
        self.audioRecorder = nil

//        showCalcLenthOfAudioFile()
    }

    //MARK - audioMessageToAnalyze

    func audioMessageToAnalyze(url: URL) {
        // let url = Bundle.main.url(forResource: url.absoluteString, withExtension: "m4a")
        let file = try! AVAudioFile(forReading: url)//Read File into AVAudioFile
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false)//Format of the file

        let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: UInt32(file.length))//Buffer
        try! file.read(into: buf)//Read Floats
        //Store the array of floats in the struct
        audioMessageWaveForm?.readFile.arrayFloatValues = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))
    }

}


//MARK:- AudioRecordProtocol
extension AudioMessageControl: AudioRecordProtocol {

    func startRecordingAudio() {
        startAudioRecorder()
    }

    func finishRecordingAudio() -> URL? {
        stopAudioRecorder()

        return audioRecorder.url//urlOfCurrentlyPlayingInPlayer(player: player)
    }
}

//MARK:- AudioRecordPlayback
extension AudioMessageControl: AudioRecordPlaybackProtocol {

    func analyzeAudioMessage(url: URL, waveFormView: AudioMessageWaveForm?) {
        //try to link wave form, if needed
        if self.audioMessageWaveForm == nil
            &&  waveFormView != nil {
            self.audioMessageWaveForm = waveFormView
        }
        
        audioMessageToAnalyze(url: url)
    }

    func playAudio(urlFromFireBase url: URL?) {

        guard let notNullUrl = url else {
            print("url for audio playing can't be nil !")
            return
        }
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
        }


        //DispatchQueue.main.async {
        self.initPlayer(url: notNullUrl)


//        let playerItem = AVPlayerItem(url: notNullUrl)
//        self.player.replaceCurrentItem(with: playerItem)

        self.player.play()

        if urlOfCurrentlyPlayingInPlayer() != notNullUrl {
            audioMessageToAnalyze(url: notNullUrl)
        }

        //}
    }

}

//
//  ModelObserver.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-03-26.
//
import Foundation
import SceneKit

class ModelObserver: NSObject {
    var articleView: ArticleView?
    var loadingTimer: Timer?

    init(articleView: ArticleView) {
        self.articleView = articleView
    }

    func observeModelLoading(modelUrl: URL) {
        loadingTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkLoadingStatus), userInfo: modelUrl, repeats: true)
    }

    @objc func checkLoadingStatus(timer: Timer) {
        guard let modelUrl = timer.userInfo as? URL else {
            return
        }

        DispatchQueue.global().async {
            do {
                let scene = try SCNScene(url: modelUrl, options: nil)
                DispatchQueue.main.async {
                    self.articleView?.scene = scene
                    self.articleView?.isModelDisplayed = true
                    self.loadingTimer?.invalidate()
                }
            } catch {
                print("Fel vid laddning av modell: \(error.localizedDescription)")
            }
        }
    }
}

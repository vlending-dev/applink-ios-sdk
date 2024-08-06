//
//  ViewController.swift
//  AppLinkExample
//
//  Created by Hyunjoon Ko on 8/1/24.
//

import UIKit
import AppLink

extension ViewController: UITextFieldDelegate {
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonGenerateLink: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonReceiveInfo: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    fileprivate var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textField.delegate = self
        textField.text = "{yout domain uri}m0LCrJ5Dnm"
    }
    
    func share(url: URL) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let shareActivities = UIActivityViewController(activityItems: [url.absoluteString], applicationActivities: nil)
//            shareActivities.completionWithItemsHandler = { type, success, data, error in
//            }
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                shareActivities.popoverPresentationController?.sourceView = self.buttonGenerateLink
                shareActivities.popoverPresentationController?.sourceRect = self.buttonGenerateLink.bounds
            }
            self.present(shareActivities, animated: true)
        }
    }
    
    // MARK: - actions

    @IBAction func onButton(generate sender: UIButton) {
        guard !isLoading else { return }
        isLoading = true
        
        var request = AppLinkRequest(scheme: "{your scheme}", title: "Test Title", description: "Test description", url: "https://www.google.com/")
        request.imageURL = "https://{your thumnail image url}.png"
        request.deeplinkAction = "{action without scheme}"
        AppLink.request(link: request) { [weak self] url, error in
            self?.isLoading = false
            if let u = url {
                self?.share(url: u)
            }
            guard let error = error else {
                return
            }
            print("Generate link error: \(error)")
        }
    }
    
    
    @IBAction func onButton(receiveInfo sender: UIButton) {
        textView.text = nil
        guard !isLoading, let text = textField.text, !text.isEmpty, let url = URL(string: text) else { return }
        isLoading = true
        
        AppLink.parse(url: url) { [weak self] information, identifier, queries, error in
            var infoText = ""
            if let e = error {
                infoText = "Error: " + e.localizedDescription
            } else {
                infoText = "Link Identifier: " + identifier
                if let urlQuery = queries {
                    infoText += "\n" + "URL query: \(urlQuery)"
                }
                if let title = information?.title, !title.isEmpty {
                    infoText += "\n" + "Preview Title: " + title
                }
                if let desc = information?.contents, !desc.isEmpty {
                    infoText += "\n" + "Preview Content Description: " + desc
                }
                if let image = information?.thumbnail, !image.isEmpty {
                    infoText += "\n" + "Preview Image URL: " + image
                }
                if let scheme = information?.scheme, !scheme.isEmpty {
                    infoText += "\n" + "Custom Scheme: " + scheme
                }
                if let action = information?.deeplinkAction, !action.isEmpty {
                    infoText += "\n" + "Custom action: " + action
                }
                if let web = information?.webURL, !web.isEmpty {
                    infoText += "\n" + "Web URL: " + web
                }
                if let utm = information?.utm {
                    if let source = utm.source {
                        infoText += "\n" + "UTM source: " + source
                    }
                    if let medium = utm.medium {
                        infoText += "\n" + "UTM medium: " + medium
                    }
                    if let campaign = utm.campaignName {
                        infoText += "\n" + "UTM campaign: " + campaign
                    }
                }
            }
            self?.textView.text = infoText
            self?.isLoading = false
        }
    }
}


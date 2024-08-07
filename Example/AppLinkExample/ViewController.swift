//
//  ViewController.swift
//  AppLinkExample
//
//  Created by Hyunjoon Ko on 8/1/24.
//  Copyright © 2024 Vlending Co., Ltd. All rights reserved.
//

import UIKit
import AppLink

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == false {
            receiveAppLinkInfo()
        }
        textField.resignFirstResponder()
        return true
    }
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
        
        textField.clipsToBounds = true
        textField.delegate = self
        textField.text = nil
        textField.clearButtonMode = .whileEditing
        textField.textColor = .white
        textField.tintColor = .white
        textField.keyboardType = .URL
        textField.returnKeyType = .done
        textField.backgroundColor = .purple
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        
        textView.text = nil
        textView.isEditable = false
        textView.isSelectable = false
        textView.textColor = .black
        textView.tintColor = .black
    }
    
    func share(url: URL) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let shareActivities = UIActivityViewController(activityItems: [url.absoluteString], applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
                shareActivities.popoverPresentationController?.sourceView = self.buttonGenerateLink
                shareActivities.popoverPresentationController?.sourceRect = self.buttonGenerateLink.bounds
            }
            self.present(shareActivities, animated: true)
        }
    }
    
    func receiveAppLinkInfo() {
        textField.resignFirstResponder()
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
                if let image = information?.imageURL, !image.isEmpty {
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
    
    // MARK: - actions

    @IBAction func onButton(generate sender: UIButton) {
        textField.resignFirstResponder()
        guard !isLoading else { return }
        isLoading = true
        
        // TODO: AppLink request setting
        var request = AppLinkRequest(scheme: "{your scheme}", title: "Test Title", description: "Test description", url: "https://www.google.com/")
        request.imageURL = "https://{your thumbnail image url}.png"
        request.deeplinkAction = "{action without scheme}"
        request.utm = AppLinkUTM(source: "{utm source}", medium: "{utm medium}", campaign: "{utm campaign}")
        AppLink.request(link: request) { [weak self] url, error in
            self?.isLoading = false
            if let u = url {
                self?.share(url: u)
            }
            guard let error = error else {
                return
            }
            self?.textView.text = "Generate link: " + error.localizedDescription
            print("Generate link error: \(error)")
        }
    }
    
    
    @IBAction func onButton(receiveInfo sender: UIButton) {
        receiveAppLinkInfo()
    }
}


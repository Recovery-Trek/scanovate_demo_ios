//
//  ViewController.swift
//  Scanovate Demo
//
//  Created by Alex Ho on 2/18/21.
//

import UIKit
import SafariServices
import AVFoundation

//public let scheme = "recoverytrek"
 let kSFViewControllerCloseNotification = "recoverytrek"
class ViewController: UIViewController {
    
    private var urlString:String = ""
    lazy var safariVC = SFSafariViewController(url: URL(string: urlString)!)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    @IBAction func btnPresentSafariViewControllerTapped(_ sender: UIButton) {

        // Add NSNotification Observer to close SFSafariViewController when reaching to finish scheme
        NotificationCenter.default.addObserver(self, selector: #selector(dismissSFViewController(_:)), name:NSNotification.Name(rawValue: kSFViewControllerCloseNotification), object: nil)

        safariVC.delegate = self

        self.present(safariVC, animated: true, completion: nil)
    }

    // Check camera permission
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let mediaType = AVMediaType.video
        let authStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        if authStatus == .authorized {
        } else if authStatus == .denied {
        } else if authStatus == .restricted {
        } else if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { granted in
                if granted {
                } else {
                }
            })
        } else {
        }
    }

    // Selector func for kSafariViewControllerCloseNotification, we add Observer when Presenting
    @objc private func dismissSFViewController(_ notification: NSNotification?) {
        // get the url from the auth callback
        if let url = notification?.object as? NSURL {

            if let tokenValue = self.getQueryStringParameter(url: (url.absoluteString ?? ""), param: "token")
            {
                print("successURL: \(url.description)");
                print("tokenValue: \(tokenValue)");
            }

            // Remove kSafariViewControllerCloseNotification Observer
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kSFViewControllerCloseNotification), object: nil)

            // Finally dismiss the Safari View Controller with:
            self.safariVC.dismiss(animated: true, completion: nil)
        }
    }

    // helper func
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

// SFSafariViewControllerDelegate
extension ViewController: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("safariViewControllerDidFinish")
    }

    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print("safariViewController initialLoadDidRedirectTo URL: \(URL)")

    }

    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("safariViewController didCompleteInitialLoad didLoadSuccessfully: \(didLoadSuccessfully)")
    }

}

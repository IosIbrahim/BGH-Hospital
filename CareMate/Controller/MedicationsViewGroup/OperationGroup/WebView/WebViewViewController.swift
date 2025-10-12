//
//  WebViewViewController.swift
//  CareMate
//
//  Created by m3azy on 21/09/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit
import WebKit
import PDFKit

class WebViewViewController: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var btnShare: UIButton!
    
    var url = ""
    var name = "Report\(Int.random(in: 0...10000)).pdf"
    var showShare = true
    var pageTitle = ""
    
    init(_ url: String, showShare: Bool = true) {
        self.url = url
        self.showShare = showShare
        super.init(nibName: "WebViewViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if pageTitle == "" {
            initHeader(title: showShare ? UserManager.isArabic ? "النتيجة" : "Result" : UserManager.isArabic ? "إعرف طبيبك" : "Know your doctor")
        } else {
            initHeader(title: pageTitle)
        }
        webView.navigationDelegate = self
        webView.uiDelegate = self
        btnShare.isHidden = !showShare
        guard let url = URL(string: url) else { return }
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
        
    }

    @IBAction func share(_ sender: Any) {
        let _ = self.webView.exportAsPdfFromWebView(name: name)
        var pdfURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        pdfURL = pdfURL.appendingPathComponent(name) as URL
        self.sharePdf(path: pdfURL)
    }
    
    func sharePdf(path:URL) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path.path) {
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [path], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            print("document was not found")
            let alertController = UIAlertController(title: "Error", message: "Document was not found!", preferredStyle: .alert)
            let defaultAction = UIAlertAction.init(title: "ok", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(defaultAction)
        }
    }
}

extension WebViewViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showIndicator()

    }// show indicator

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        hideIndicator()

    }  // hide indicator

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideIndicator()
        

    } // hide indicator*
}

extension WKWebView {
    
    // Call this function when WKWebView finish loading
    func exportAsPdfFromWebView(name: String) -> String {
        let pdfData = createPdfFile(printFormatter: self.viewPrintFormatter())
        return self.saveWebViewPdf(data: pdfData, name: name)
    }
    
    func createPdfFile(printFormatter: UIViewPrintFormatter) -> NSMutableData {
        
        let originalBounds = self.bounds
        self.bounds = CGRect(x: originalBounds.origin.x, y: bounds.origin.y, width: self.bounds.size.width, height: self.scrollView.contentSize.height)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.scrollView.contentSize.height)
        let printPageRenderer = UIPrintPageRenderer()
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        printPageRenderer.setValue(NSValue(cgRect: UIScreen.main.bounds), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: pdfPageFrame), forKey: "printableRect")
        self.bounds = originalBounds
        return printPageRenderer.generatePdfData()
    }
    
    // Save pdf file in document directory
    func saveWebViewPdf(data: NSMutableData, name: String) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent(name)
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}

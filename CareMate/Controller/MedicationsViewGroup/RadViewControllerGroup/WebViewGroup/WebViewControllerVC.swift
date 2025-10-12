//
//  WebviewController.swift
//  CareMate
//
//  Created by Yo7ia on 4/2/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import SCLAlertView
import UIKit
import WebKit
class WebViewControllerVC: BaseViewController
{
    @IBOutlet weak var webView: WKWebView!
    var reportText  = ""
    var pdfUrl:URL?

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

        let contentSize:CGSize = webView.scrollView.contentSize
        let viewSize:CGSize = self.view.bounds.size
//
        let rw:Float = Float(viewSize.width / contentSize.width)

        webView.scrollView.minimumZoomScale = CGFloat(rw)
        webView.scrollView.maximumZoomScale = CGFloat(rw)
        webView.scrollView.zoomScale = CGFloat(rw)
        
//        webView.scalesPageToFit = true
        webView.contentMode = UIViewContentMode.scaleAspectFit
        
     
//        webView.exportAsPdfFromWebView()
        
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "استعراض التقرير" : "Report View", hideBack: false)

       createPdfFromHTML()
        
//
    }
    
    @IBAction func shareWithWhatsapp(_ sender: Any) {
        
        var pdfURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        pdfURL = pdfURL.appendingPathComponent("RadPdF.pdf") as URL
     
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
//            UIViewController.hk_currentViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func exportAsPdfFromWebView() -> String {
       let pdfData = createPdfFile(printFormatter: webView.viewPrintFormatter())
       return saveWebViewPdf(data: pdfData)
    }
    
    
    func saveWebViewPdf(data: NSMutableData) -> String {
       
       let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       let docDirectoryPath = paths[0]
       let pdfPath = docDirectoryPath.appendingPathComponent("webViewPdf.pdf")
        pdfUrl = pdfPath
       if data.write(to: pdfPath, atomically: true) {
           return pdfPath.path
       } else {
           return ""
       }
     }
    
    
    
    func createPdfFile(printFormatter: UIViewPrintFormatter) -> NSMutableData {
       
       let originalBounds = webView.bounds
        webView.bounds = CGRect(x: originalBounds.origin.x, y: webView.bounds.origin.y, width: webView.bounds.size.width, height: webView.scrollView.contentSize.height)
       let pdfPageFrame = CGRect(x: 0, y: 0, width: webView.bounds.size.width, height: webView.scrollView.contentSize.height)
       let printPageRenderer = UIPrintPageRenderer()
       printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
       printPageRenderer.setValue(NSValue(cgRect: UIScreen.main.bounds), forKey: "paperRect")
       printPageRenderer.setValue(NSValue(cgRect: pdfPageFrame), forKey: "printableRect")
        webView.bounds = originalBounds
       return printPageRenderer.generatePdfData()
    }
    
    
   
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = UserManager.isArabic ? "التقرير" : "Report"
        print(reportText)
        webView.loadHTMLString(reportText, baseURL: nil)
    }
    
    func createPdfFromHTML(){
        let html = reportText
        let fmt = UIMarkupTextPrintFormatter(markupText: html)

    
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)

   
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        render.setValue(page, forKey: "paperRect")
        render.setValue(page, forKey: "printableRect")


        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 0..<render.numberOfPages {
            UIGraphicsBeginPDFPage();
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }

        UIGraphicsEndPDFContext();

        guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("RadPdF").appendingPathExtension("pdf")
            else {
                
                fatalError("Destination URL not created")
                
                
            }

        pdfData.write(to: outputURL, atomically: true)
        print("open \(outputURL.path)")
    }
    
}
extension WKWebView {

// Call this function when WKWebView finish loading



 // Save pdf file in document directory
 
}

extension UIPrintPageRenderer {

 func generatePdfData() -> NSMutableData {
     let pdfData = NSMutableData()
     UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
     self.prepare(forDrawingPages: NSMakeRange(0, self.numberOfPages))
     let printRect = UIGraphicsGetPDFContextBounds()
     for pdfPage in 0 ..< self.numberOfPages {
         UIGraphicsBeginPDFPage()
         self.drawPage(at: pdfPage, in: printRect)
     }
     UIGraphicsEndPDFContext();
     return pdfData
 }
}


import Foundation
import VisionKit

@objc public class DocScanner: NSObject, VNDocumentCameraViewControllerDelegate {
    
    private var viewController: UIViewController?
    
    private var onScanned: ([String]) -> Void = { _ in }
    private var onError: (String) -> Void = { _ in }
    
    
    public func start(_viewController:UIViewController,
                            success: @escaping ([String]) -> Void = {_ in },
                            error: @escaping (String) -> Void = {_ in }){
        self.viewController = _viewController
        self.onScanned = success
        self.onError = error
        
        self.openScan()
    }
    
    private func openScan(){
        if (!VNDocumentCameraViewController.isSupported) {
            self.onError("Document Scan is not supported")
            return
        }
        DispatchQueue.main.async {
            let vc = VNDocumentCameraViewController()
        
            vc.delegate = self
            self.viewController?.present(vc, animated: true)
        }
    }
    
    
    private func exitCameraViewController(vc:VNDocumentCameraViewController){
        DispatchQueue.main.async {
            vc.dismiss(animated: true)
        }
    }
    
    // Delegate methods
    
    public func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFinishWith scan: VNDocumentCameraScan
    ) {
        var scans:[String] = []
        
        for page in 0...scan.pageCount-1 {
            guard let imageData:Data = scan.imageOfPage(at: page)
                .jpegData(compressionQuality: CGFloat(100)) else {
                    exitCameraViewController(vc: controller)
                    self.onError("Cannot get image data")
                    return;
                }
            
            let base64 = imageData.base64EncodedString()
            scans.append(base64)
            
        }
        exitCameraViewController(vc: controller)
        self.onScanned(scans)
    }
    
    
    public func documentCameraViewControllerDidCancel(
            _ controller: VNDocumentCameraViewController
        ) {
            exitCameraViewController(vc: controller)
            self.onError("User canceled")
    }
    
    public func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFailWithError error: Error
        ) {
            
        exitCameraViewController(vc: controller)
        self.onError(error.localizedDescription)
    }
}

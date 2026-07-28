import Foundation
import VisionKit

@objc public class DocScanner: NSObject, VNDocumentCameraViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
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
            vc.modalPresentationStyle = .pageSheet
            vc.delegate = self
            vc.presentationController?.delegate = self
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
        
        for page in 0..<scan.pageCount {
            var image = scan.imageOfPage(at: page)
            
            image = resizeImage(image: image, maxDimension: 1080.0) ?? image
            
            guard let imageData:Data = image.jpegData(compressionQuality: 0.8) else {
                exitCameraViewController(vc: controller)
                self.onError("Cannot get image data")
                return
            }
            
            let base64 = imageData.base64EncodedString()
            scans.append(base64)
        }
        exitCameraViewController(vc: controller)
        self.onScanned(scans)
    }
    
    private func resizeImage(image: UIImage, maxDimension: CGFloat) -> UIImage? {
        let size = image.size
        let maxSide = max(size.width, size.height)
        
        if maxSide <= maxDimension {
            return image
        }
        
        let scale = maxDimension / maxSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
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
    
    // UIAdaptivePresentationControllerDelegate method for swipe-to-dismiss
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.onError("User canceled")
    }
}

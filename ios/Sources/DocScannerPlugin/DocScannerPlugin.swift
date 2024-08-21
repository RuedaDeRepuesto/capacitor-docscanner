import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(DocScannerPlugin)
public class DocScannerPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "DocScannerPlugin"
    public let jsName = "DocScanner"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "scan", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = DocScanner()
    
    @objc func scan(_ call:CAPPluginCall){
        implementation.start(_viewController: (self.bridge?.viewController)!,
            success: { (images: [String]) in
                call.resolve(["images":images])
        }, error: { (error:String) in
            call.reject(error)
        })
    }
}

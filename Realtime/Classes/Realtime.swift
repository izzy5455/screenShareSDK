import Foundation
import FirebaseCore


public struct RealtimeConfig {
    public init() {
        
    }
    
}

@objc open class Realtime: NSObject {
    var renderingEngine: RenderingEngine
    public init(config:RealtimeConfig){
        FirebaseApp.configure()
        renderingEngine = RenderingEngine(viewsToHide: [])
        renderingEngine.start()
        super.init()
        
        
        
    }
    
}

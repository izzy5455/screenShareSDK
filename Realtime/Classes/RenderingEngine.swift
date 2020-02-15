//
//  RenderingEngine.swift
//  FBSnapshotTestCase
//
//  Created by Alex otero on 2/9/20.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import PromiseKit

public class RenderingEngine: NSObject {
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var tasks:[StorageUploadTask]
    let session:DocumentReference
    var updloadedImages:[Upload] = []
    public init(viewsToHide:[UIView]){
        session = db.collection("sessions").document() // creates a new session.
        tasks = []
        
        
    }
    
    
    func start(){
        DispatchQueue.global().async {
                    
                    var dots = ""
                    while(true){
                        dots += "."
                        
                        print("rendering\(dots)")
                        
                        self.takeScreenshot { (image) in
                            
                        }
                        do {sleep(1)}
                    }
                }
    }
    
    
    
    internal func takeScreenshot(completion:@escaping (_ : Data) -> Void){
        DispatchQueue.main.async {
            guard  let window = UIApplication.shared.keyWindow  else { return }
            UIGraphicsBeginImageContextWithOptions(window.frame.size, false, 1.0);
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true);
            
            guard let output = UIGraphicsGetImageFromCurrentImageContext(), let data = UIImageJPEGRepresentation(output, 0.90)  else {
                UIGraphicsEndImageContext()
                return
            }

           UIGraphicsEndImageContext()
            
            let date = Date()
//            self.updloadedImages.insert()
            let upload = Upload(name: "\(self.session.documentID)/images/\(date)", data: data)
            self.updloadedImages.append(upload)
            self.storage.child(upload.name).putData(upload.data, metadata: nil){ (metadata,error) in
                let names = self.updloadedImages.map{$0.name}
                self.session.setData(["images": names ])
            }

                   
        }
        
       
    }
   
}



struct Upload:Hashable {
    var name:String
    var data:Data
}






func resizeImage(image: UIImage, newSize: CGFloat) -> UIImage {
    let scale = newSize / max(image.size.width, image.size.height)
    let newWidth = image.size.width * scale
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}

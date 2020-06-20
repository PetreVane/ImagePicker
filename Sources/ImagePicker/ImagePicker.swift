
import UIKit
import AVFoundation

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage)
}

public class ImagePicker: NSObject {
    
    public var imagePickerController: UIImagePickerController
    public weak var presentingController: UIViewController?
    public weak var delegate: ImagePickerDelegate?
    
    public init(presentingController: UIViewController, delegate: ImagePickerDelegate) {
        self.imagePickerController = UIImagePickerController()
        super.init()
        self.presentingController = presentingController
        self.delegate = delegate
        self.imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.mediaTypes = ["public.image"]
    }
    
    public func selectImageFrom(source type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return nil }
        return UIAlertAction(title: title, style: .default) { [unowned self] (action) in
            
            self.imagePickerController.sourceType = type
            self.presentingController?.present(self.imagePickerController, animated: true, completion: nil)
            
        }
    }
    
    public func presentAlert(from view: UIView) {
        
        let alertController = UIAlertController(title: "Pick your Image", message: "Select where your image is saved", preferredStyle: .alert)
        
        if let cameraAction = self.selectImageFrom(source: .camera, title: "Camera") {
            
            if allowedCameraAccess() {
                alertController.addAction(cameraAction)
            }
        }
        
        if let photoLibraryAction = self.selectImageFrom(source: .photoLibrary, title: "Photo Library") {
            alertController.addAction(photoLibraryAction)
        }
        
        if let savedPhotosAction = self.selectImageFrom(source: .savedPhotosAlbum, title: "Saved Photos") {
            alertController.addAction(savedPhotosAction)
        }
        
        self.presentingController?.present(alertController, animated: true, completion: nil)
    }
    
    public func imagePicker(didSelect image: UIImage?, _ controller: UIImagePickerController) {
        
        if let selectedImage = image {
            self.delegate?.didSelect(image: selectedImage)
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func allowedCameraAccess() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        // The user has previously granted access to the camera.
        case .authorized: return true
        // The user has not yet been asked for camera access.
        case .notDetermined:
            var accessPermited: Bool = false
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { accessPermited = true }
            }
            return accessPermited
        // The user has previously denied access.
        case .denied: return false
        // The user can't grant access due to restrictions.
        case .restricted: return false
        @unknown default:
            print("Unknown case added")
            return false
        }
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker(didSelect: nil, picker)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return self.imagePicker(didSelect: nil, picker) }
        self.imagePicker(didSelect: image, picker)
    }
    
}


extension ImagePicker: UINavigationControllerDelegate { }


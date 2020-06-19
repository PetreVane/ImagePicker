# ImagePicker

This package contains an ImagePicker. 

Usage:

1. your viewController should have a reference of type ImagePicker
    
        var imagePicker: ImagePicker?
        
2. make your viewController conform to ImagePicker delegate

    
        // MARK: - Adopts ImagePicker delegate
        extension ChatViewController: ImagePickerDelegate {
            func didSelect(image: UIImage) {
                let message = Message(image: image, user: currentlyLoggedInUser!, messageID: UUID().uuidString, date: Date())
                cloudFirestore.upload(message: message, from: chatRoom!)
                print("Image has been selected and upload triggered")
            }
        }
        
        // MARK: - Sets itself as ImagePicker delegate
            private func configureImagePicker() {
                   imagePicker = ImagePicker(presentingController: self, delegate: self)
            }
        


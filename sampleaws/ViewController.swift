//
//  ViewController.swift
//  sampleaws
//
//  Created by Aditya Saxena on 11/10/18.
//  Copyright © 2018 aditya saxena. All rights reserved.
//

import UIKit
import AWSCore
import AWSMachineLearning
import AWSRekognition
import SwiftyJSON
import Cloudinary
import CoreImage
import Photos
import BSImagePicker
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var c = 0
    var d = 0
    
    @IBOutlet weak var imh1: UIImageView!
    @IBOutlet weak var imh2: UIImageView!
    @IBOutlet weak var imh3: UIImageView!
    
    @IBOutlet weak var imh4: UIImageView!
    @IBOutlet weak var imh5: UIImageView!
    @IBOutlet weak var imh6: UIImageView!
    
    @IBOutlet weak var imh7: UIImageView!
    @IBOutlet weak var imh8: UIImageView!
    @IBOutlet weak var imh9: UIImageView!
    
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    
    @IBAction func chooseImage(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: . actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            self.d += 1
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            self.d += 1
            self.camera((Any).self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func btonMag(_ sender: Any) {
        //print(imh1.image)
        
//        if (d >= 3) {
        performSegue(withIdentifier: "gotocomic", sender: self)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotocomic" {
             let destination = segue.destination as! ComicVC
                destination.tmv = imh1
                destination.umv = imh2
                destination.mmv = imh3
                destination.count = d
//                destination.img2.image = imh2.image
//                destination.img3.image = imh3.image
        }
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
//        for device in devices {
//            if device.position == AVCaptureDevice.Position.back {
//
//                do {
//                    let input = try AVCaptureDeviceInput(device: device)
//
//                    if captureSession
//
//                }
//                catch {
//                    print("Error!")
//                }
//
//            }
//        }
//    }
    
    
//    private func apply(image: UIImage, filterEffect: Filter) -> UIImage? {
//
//        guard let cgImage = image.cgImage,
//                let openGLContext = EAGLContext(api: .openGLES3) else {
//            return nil
//        }
//
//        let context = CIContext(eaglContext: openGLContext)
//
//        let ciImage = CIImage(cgImage: cgImage)
//        let filter = CIFilter(name: filterEffect.filterName)
//
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//
//        if let filterEffectValue = filterEffect.filterEffectValue,
//            let filterEffectValueName = filterEffect.filterEffectValueName {
//             filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
//        }
//
//        var filteredimage: UIImage?
//
//        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
//            let cgiImageResult = context.createCGImage(output, from: output.extent){
//              filteredimage = UIImage(cgImage: cgiImageResult)
//        }
//
//        return filteredimage
//
//    }
    
    //@IBOutlet weak var mainLbl: UILabel!
    
    
    
    @IBAction func camera(_ sender: Any) {
        
        let vc = BSImagePickerViewController()
        
        self.bs_presentImagePickerController(vc, animated: true,
                                             select: { (asset: PHAsset) -> Void in
                                                
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
                
            }
            
            self.convertAssetToImages()
            
        }, completion: nil)
        
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//            //temp()
//        }
        
    }
    
    func convertAssetToImages() -> Void {
        
        if SelectedAssets.count != 0{
            
            
            for i in 0..<SelectedAssets.count{
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                
                
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                    
                })
                
                let data = UIImageJPEGRepresentation(thumbnail, 0.7)
                let newImage = UIImage(data: data!)
                
                c += 1
                self.PhotoArray.append(newImage! as UIImage)
                
                if(c == 1) {
                    imh1.image = newImage
                } else if(c == 2) {
                    imh2.image = newImage
                } else if(c == 3) {
                    imh3.image = newImage
                    imh4.isHidden = false
                    imh5.isHidden = false
                    imh6.isHidden = false
                } else if(c == 4) {
                    imh4.image = newImage
                } else if(c == 5) {
                    imh5.image = newImage
                } else if(c == 6) {
                    imh6.image = newImage
                    imh7.isHidden = false
                    imh8.isHidden = false
                    imh9.isHidden = false
                } else if(c == 7) {
                  
                    imh7.image = newImage
                } else if(c == 8) {
                    imh8.image = newImage
                } else {
                    imh9.image = newImage
                }
                
            }
            
        }
        
        PhotoArray = []
        SelectedAssets = []
    }
    
    func opencamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
        
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
                    //temp()
                }
        
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            c += 1
            print(c)
            
            if(c == 1) {
                imh1.contentMode = .scaleAspectFit
                imh1.image = pickedImage
            } else if(c == 2) {
                imh2.contentMode = .scaleAspectFit
                imh2.image = pickedImage
            } else if(c == 3) {
                imh3.contentMode = .scaleAspectFit
                imh3.image = pickedImage
                imh4.isHidden = false
                imh5.isHidden = false
                imh6.isHidden = false
            } else if(c == 4) {
                imh4.contentMode = .scaleAspectFit
                imh4.image = pickedImage
            } else if(c == 5) {
                imh5.contentMode = .scaleAspectFit
                imh5.image = pickedImage
            } else if(c == 6) {
                imh6.contentMode = .scaleAspectFit
                imh6.image = pickedImage
                imh7.isHidden = false
                imh8.isHidden = false
                imh9.isHidden = false
            } else if(c == 7) {
                imh7.contentMode = .scaleAspectFit
                imh7.image = pickedImage
                //imh7.image = newImage
            } else if(c == 8) {
                imh8.contentMode = .scaleAspectFit
                imh8.image = pickedImage
            } else {
                imh9.contentMode = .scaleAspectFit
                imh9.image = pickedImage
            }
            
            
            //imageView.contentMode = .scaleToFill
            //imageView.image = pickedImage
        }
        
        //temp()
    }

    
    
//    func temp() {
//
//       // imageView.image?.imageOrientation = UIImageOrientation
//        let sourceImage = UIImage(named: "eat")
//        //imageView.image = sourceImage
//        let rekognitionClient = AWSRekognition.default()
//        //mainLbl.text = ""
//
//        let image = AWSRekognitionImage()
//        image!.bytes = UIImageJPEGRepresentation(sourceImage!, 0.7)
//
//        guard let request = AWSRekognitionDetectLabelsRequest() else {
//            print("Unable to initialize AWSRekognitionDetectLabelsRequest.")
//            return
//        }
//
//        request.image = image
//        request.maxLabels = 20
//        request.minConfidence = 90
//
//        rekognitionClient.detectLabels(request) {
//            (result, error) in
//            if error != nil {
//                print(error!)
//                return
//            }
//
//            if result != nil {
//                print(result!.labels!)
//                //let Swf = JSON(result!.labels["name"]!)
//
//                print("\n\n")
//                var strarray = [String]()
//                var str = " "
//
//                for (index, val) in result!.labels!.enumerated() {
//
//                    print(val.name!)
//                    strarray.append(val.name!)
//                    if index == 0 {
//
//                       str = str + val.name!
//                    } else {
//                       str = str + ", " + val.name!
//                    }
//                }
//
//                print(strarray)
//                //self.mainLbl.text = str
//
//            } else {
//                print("No result")
//            }
//
//        }
//
//
//        //        imageView.image = apply(image: img, filterEffect: Filter(filterName: "CIPhotoEffectChrome", filterEffectValue: nil, filterEffectValueName: nil))
//
//
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imh4.isHidden = true
        imh5.isHidden = true
        imh6.isHidden = true
        
        imh7.isHidden = true
        imh8.isHidden = true
        imh9.isHidden = true
        
        //temp()
        
        //let getMlModelInput = AWSMachineLearningGetMLModelInput()
//        let sourceImage = UIImage(named: "eat")
//        imageView.image = sourceImage
//        let rekognitionClient = AWSRekognition.default()
//
//        let image = AWSRekognitionImage()
//        image!.bytes = UIImageJPEGRepresentation(sourceImage!, 0.7)
//
//        guard let img = imageView.image else {
//            return
//        }
//
////        imageView.image = apply(image: img, filterEffect: Filter(filterName: "CIPhotoEffectChrome", filterEffectValue: nil, filterEffectValueName: nil))
//
//        imageView.image = apply(image: img, filterEffect: Filter(filterName: "CIComicEffect", filterEffectValue: nil, filterEffectValueName: nil))
//
////        guard let img1 = imageView.image else {
////            return
////        }
////
////          imageView.image = apply(image: img1, filterEffect: Filter(filterName: "CILimeOverlay", filterEffectValue: nil, filterEffectValueName: nil))
//
////        let fileURL = NSBundle.mainBundle().URLForResource("download", withExtension: "jpeg")
//
//
////        let config = CLDConfiguration(cloudName="demo")!
////        let cloudinary = CLDCloudinary(configuration: config)
////
////imageView.cldSetImage(cloudinary.createUrl().setTransformation(CLDTransformation()
////            .setEffect("cartoonify").chain()
////            .setRadius("max").chain()
////            .setEffect("outline:100").setColor("lightblue").chain()
////            .setBackground("lightblue").chain()
////            .setOverlay("text:times_120:James%20Stewart").setGravity("south_east").setY(30).setAngle(315)).generate("download.jpeg")!, cloudinary: cloudinary)
//
//        guard let request = AWSRekognitionDetectLabelsRequest() else {
//            print("Unable to initialize AWSRekognitionDetectLabelsRequest.")
//            return
//        }
//
//        request.image = image
//        request.maxLabels = 20
//        request.minConfidence = 90
//
//        rekognitionClient.detectLabels(request) {
//            (result, error) in
//            if error != nil {
//                print(error!)
//                return
//            }
//
//            if result != nil {
//                print(result!.labels!)
//                //let Swf = JSON(result!.labels["name"]!)
//
//                print("\n\n")
//                var strarray = [String]()
//
//                for (index, val) in result!.labels!.enumerated() {
//
//                       print(val.name!)
//                       strarray.append(val.name!)
//
//                }
//
//               print(strarray)
//
//            } else {
//                print("No result")
//            }
//
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


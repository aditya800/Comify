//
//  ComicVC.swift
//  sampleaws
//
//  Created by Aditya Saxena on 11/11/18.
//  Copyright © 2018 aditya saxena. All rights reserved.
//

import UIKit
import CoreImage
import AWSCore
import AWSCore
import AWSMachineLearning
import AWSRekognition
import SwiftyJSON
import Cloudinary
import CoreImage
import Photos
import BSImagePicker
import AVFoundation

class ComicVC: UIViewController {
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textView3: UITextView!
    @IBOutlet weak var textView4: UITextView!
    @IBOutlet weak var textView5: UITextView!
    @IBOutlet weak var textView6: UITextView!
    
    var tmv: UIImageView?
    var umv: UIImageView?
    var mmv: UIImageView?
    var count = 0
    var Start = ""
    var Protagonist = ""
    var mainArray = [[" "]]
    
    var Setting = ""
    var Activity = ""
    var Adventure = ""
    var Story = ""
    var thing = ""
    var completeStory = [" "]
    var i = 0
    var countt = 0
    let intros = ["Once upon a time there was a ",
                  "On a Dark and stormy night there was a ",
                  "In a galaxy far far away there was a ",
                  "There once was a ",
                  "Contrary to popular belief, a ",
                  "Listen closely, I once heard of a " ,
                  "Many, many years ago, a ",
                  "It was the best of times, it was the worst of times, a ",
                  "A story old as time, a ",
                  "Hear ye,  hear ye, a "]
    
    struct Filter {
        
        let filterName: String
        var filterEffectValue: Any?
        var filterEffectValueName: String?
        
        init(filterName: String, filterEffectValue: Any?, filterEffectValueName: String?) {
            
            self.filterName = filterName
            self.filterEffectValue = filterEffectValue
            self.filterEffectValueName = filterEffectValueName
            
        }
        
    }
    
    
    private func apply(image: UIImage, filterEffect: Filter) -> UIImage? {
        
        guard let cgImage = image.cgImage,
            let openGLContext = EAGLContext(api: .openGLES3) else {
                return nil
        }
        
        let context = CIContext(eaglContext: openGLContext)
        
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterEffect.filterName)
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filterEffectValue = filterEffect.filterEffectValue,
            let filterEffectValueName = filterEffect.filterEffectValueName {
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
        }
        
        var filteredimage: UIImage?
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
            let cgiImageResult = context.createCGImage(output, from: output.extent){
            filteredimage = UIImage(cgImage: cgiImageResult)
        }
        
        return filteredimage
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        comify(imageView: img1)
//        comify(imageView: img2)
//        comify(imageView: img3)
//    }
    
    func temp(image: UIImage) {
        
        // imageView.image?.imageOrientation = UIImageOrientation
        
        let sourceImage = image
        //imageView.image = sourceImage
        let rekognitionClient = AWSRekognition.default()
        //mainLbl.text = ""
        
        let image = AWSRekognitionImage()
        image!.bytes = UIImageJPEGRepresentation(sourceImage, 0.7)
        
        guard let request = AWSRekognitionDetectLabelsRequest() else {
            print("Unable to initialize AWSRekognitionDetectLabelsRequest.")
            return }
        
        var str = " "
        
        request.image = image
        request.maxLabels = 20
        request.minConfidence = 90
        
        rekognitionClient.detectLabels(request) {
            (result, error) in
            if error != nil {
                print(error!)
                return
            }
            
            if result != nil {
                //print(result!.labels!)
                //let Swf = JSON(result!.labels["name"]!)
                
                print("\n\n")
                self.countt += 1
                var strarray = [String]()
                
                for (index, val) in result!.labels!.enumerated() {
                    
                    //print(val.name!)
                    strarray.append(val.name!)
                    if index == 0 {
                        
                        str = str + " " + val.name!
                    } else {
                        str = str + " " + val.name!
                    }
                }
                
                //print(strarray)
                self.mainArray.append(strarray)
                print(self.mainArray)
                
                if(self.countt %  3==0) {
                    let tj = self.Madlib(objectsall: self.mainArray)
                   print(tj)
            
//                    return tj
                    if(self.countt >= 3) {
                    self.textView1.text = tj[0]
                    self.textView2.text = tj[1]
                    self.textView3.text = tj[2]
                       
//                        self.textView4.text = tj[3]
//                        self.textView5.text = tj[4]
//                        self.textView6.text = tj[5]
//
                    }
//                    else if(self.count == 6)
//                    {
//                        self.textView1.text = tj[0]
//                        self.textView2.text = tj[1]
//                        self.textView3.text = tj[2]
////                        self.textView4.text = tj[0]
////                        self.textView2.text = tj[1]
////                        self.textView3.text = tj[2]
//
//                    }
                }
                //return strarray
                //self.mainLbl.text = str
                
            } else {
                print("No result")
            }
            
        }
        
        
        //        imageView.image = apply(image: img, filterEffect: Filter(filterName: "CIPhotoEffectChrome", filterEffectValue: nil, filterEffectValueName: nil))
        
        
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        img1.image = UIImage(named: "gv")
//        img2.image = UIImage(named: "hh")
//        img3.image = UIImage(named: "ss")
        
        
        if(count == 3) {
            textView4.isHidden = true
            img4.isHidden = true
            
            textView5.isHidden = true
            img5.isHidden = true
            
            textView6.isHidden = true
            img6.isHidden = true
        }
        
        if(count == 4) {
            
            textView5.isHidden = true
            img5.isHidden = true
            
            textView6.isHidden = true
            img6.isHidden = true
        }
        
        if(count == 5) {
            textView6.isHidden = true
            img6.isHidden = true
        }
        
        img1.image = tmv!.image
        img2.image = umv!.image
        img3.image = mmv!.image
        
//        img1.image?.imageOrientation = UIImageOrientation.up
//        img2.image?.imageOrientation = UIImageOrientation.up
//        img3.image?.imageOrientation = UIImageOrientation.up
        
        temp(image: img1.image!)
        //print(strarray)
       // var rm = [strarray]
        
        //strarray = []
        temp(image: img2.image!)
        temp(image: img3.image!)
        mainArray.remove(at: 0)
        print("main array: ")
        //print(mainArray)
        
        //let tj = Madlib(objectsall: strArray)
        //print(tj)
        
        //temp(image: img2.image!)
        //temp(image: img3.image!)
        
        guard let img = img1.image else {
            return
        }
        
        //        imageView.image = apply(image: img, filterEffect: Filter(filterName: "CIPhotoEffectChrome", filterEffectValue: nil, filterEffectValueName: nil))
        
        img1.image = apply(image: img, filterEffect: Filter(filterName: "CIComicEffect", filterEffectValue: nil, filterEffectValueName: nil))
        
        guard let img1 = img2.image else {
            return
        }
        
        //        imageView.image = apply(image: img, filterEffect: Filter(filterName: "CIPhotoEffectChrome", filterEffectValue: nil, filterEffectValueName: nil))
        
        img2.image = apply(image: img1, filterEffect: Filter(filterName: "CIComicEffect", filterEffectValue: nil, filterEffectValueName: nil))
        
        guard let img2 = img3.image else {
            return
        }
        
        //        imageView.image = apply(image: img, filterEffect: Filter(filterName: "CIPhotoEffectChrome", filterEffectValue: nil, filterEffectValueName: nil))
        
        img3.image = apply(image: img2, filterEffect: Filter(filterName: "CIComicEffect", filterEffectValue: nil, filterEffectValueName: nil))

       
        
        // Do any additional setup after loading the view.
    }
    
    func comify(imageView: UIImageView) {
        guard let img = imageView.image else {
            return
        }
        
        //        imageView.image = apply(image: img, filterEffect: Filter(filterName: "CIPhotoEffectChrome", filterEffectValue: nil, filterEffectValueName: nil))
        
        imageView.image = apply(image: img, filterEffect: Filter(filterName: "CIComicEffect", filterEffectValue: nil, filterEffectValueName: nil))
        
    }
    

    public func Madlib(objectsall: [[String]] ) -> [String]{
        print("Test 2 \n")
        //loop through objects in each image
        i = -1
        for objects in objectsall{
            i = i+1
            print(objects)
            //print("\n")
            //print(i)
            //if it's the first image
            if (i==0){
                //choose a intro from the list of intros
                //var Int Random = Int.Random(in 0..< (intros.count)
                print("Choosing intro \n")
                Story = Story + (intros.randomElement()!);
                
                //time to pick the main character of the story, arguably the most importan
                //element of the whole story
                if (objects.contains("People")){
                    Protagonist = "Family"
                }
                else if (objects.contains("Person") || objects.contains("Human")){
                    if (objects.contains("Female")){
                        if (objects.contains("Fashion") || objects.contains("Dress") || objects.contains("Princess")){
                            Protagonist = "Princess"
                        }
                        else{
                            Protagonist = "Heroine"
                        }
                    }
                        
                    else if (objects.contains("Male")){
                        if (objects.contains("Fashion") || objects.contains("Suit") || objects.contains("Prince")){
                            Protagonist = "Prince"
                        }
                        else{
                            Protagonist = "Hero"
                        }
                    }
                    else{
                        Protagonist = "cool person"
                    }
                    
                }
                else if (objects.contains("Animal") || objects.contains("Pet")) {
                    if(objects.contains("Dog")){
                        Protagonist = "Dog"
                    }
                    else if(objects.contains("Cat")){
                        Protagonist = "Cat"
                    }
                    else if(objects.contains("Hamster")){
                        Protagonist = "Hamster"
                    }
                    else if(objects.contains("Gerbil")){
                        Protagonist = "Gerbil"
                    }
                    else if(objects.contains("Snake")){
                        Protagonist = "Snake"
                    }
                    else{
                        Protagonist = "Animal"
                    }
                }
                else{
                    Protagonist = "person"
                }
                
                Story = Story + Protagonist
                completeStory.removeAll()
                completeStory.append(Story)
                continue
            }
                
                //check if it's the second image
            else if (i==1)
            {
                var dictPlaces = ["Grass": "Park",
                                  "Field": "Stadium",
                                  "Stadium": "Stadium",
                                  "Classroom": "Classroom",
                                  "Tree": "Forest",
                                  "Jungle": "Forest",
                                  "Shopping Mall": "Shopping Mall",
                                  "Building": "Building",
                                  "City": "City",
                                  "Urban": "City",
                                  "Sea": "Sea"
                ]
                //Story = Story + ", in a "
                //Discover the setting our fantastical tale, where does it take place?
                /*if(objects.contains("Building") ||
                 objects.contains("City") ||
                 objects.contains("Urban")){
                 Setting = "City"
                 }
                 else if(objects.contains("Forest") ||
                 objects.contains("Woods") ||
                 objects.contains("Jungle") ||
                 objects.contains("Nature")){
                 Setting = "Forest"
                 }
                 else if(objects.contains("Classroom") || objects.contains("Chairs")){
                 Setting = "Classroom"
                 }
                 else{
                 Setting = (intros.randomElement()!)
                 }*/
                for object in objects{
                    if let val = dictPlaces[object] { // possible problem
                        Setting = val;
                        
                        break;
                    }
                    else{
                        Setting = "unknown galaxy"
                    }
                }
                Story = Story + ", in a(n) " + Setting + ", "
                //Story = Story
                completeStory.append(", in a(n) " + Setting + ", ")
                continue
            }
                
                //if it's the last image
            else if (i==(objectsall.count-1)) {
                //The Adventure our Protagonist goes on at the end of this little Story
                print("Choosing adventure and end!")
                var dictAdventures = ["Pencil":"had to take a test" ,
                                      "Paper": "had to take a test",
                                      "Test": "had to take a test",
                                      "Reading": "had to take a test",
                                      "Dragon": "fought a dragon",
                                      "Lizard": "fought a dragon",
                                      "Water": "dove into the water to save their love",
                                      "Pool": "dove into the water to save their love",
                                      "Sea": "dove into the water to save their love",
                                      "Ocean": "dove into the water to save their love",
                                      "Snow": "had to skii down",
                                      "Screen": "had to hack the mainframe",
                                      "Crowd": "had to stop their love from leaving them",
                                      "Standing":"Standing",
                                      "Computer": "had to hack the mainframe",
                                      "Electronics": "had to hack the mainframe",
                                      "Rowing" : "had to row a boat.",
                                      "tightrope walking" : "decided to try out tightrope walking",
                                      "judo" : "decided to learn judo",
                                      "blood sport" : "decided to try blood sport",
                                      "gymnastics" : "tried gymnastics",
                                      "gymnastic exercise" : "tried gymnastics",
                                      "water sport" : "had to use his water sport skills",
                                      "aquatics" : "started a research on aquatic animals",
                                      "track and field" : "decided to make a career in track",
                                      "outdoor sport" : "loved outdoor sport",
                                      "field sport" : "loved field sport",
                                      "contact sport" : "began to love field sport",
                                      "team sport" : "was excellent in team sport",
                                      "racing" : "loved racing",
                                      "athletic" : "became very athletic",
                                      "riding" : "went riding",
                                      "horseback riding" : "loved horses",
                                      "archery" : "loved archery and had to shoot the arrow right on point to save his life",
                                      "cycling" : "cycled the fastest he could so that he reached his destination on time",
                                      "sledding" : "had to sled down a mountain",
                                      "skating" : "had to skate the best they could",
                                      "rock climbing" : "had to save themself from falling off huge rock" ,
                                      "spectator sport" : "had to make their team win alone"
                ]
                for object in objects{
                    if let val = dictAdventures[object] { // possible problem
                        Adventure = val;
                        
                        break;
                    }
                    else{
                        Adventure = "could not breathe and felt like somebody was choking them. Ahhh...   (but it was dream, Phew!)"
                    }
                }
                
                Story = Story + Adventure + ". And it was happily ever after!"
                //Story = Story
                completeStory.append(Adventure + ". And it was happily ever after!")
                continue
                
            }
                //if there's a huge number of images then end the sentence
            else if (objectsall.count>=5 && i==(objectsall.count/2)-1 )
            {
                
                //The Adventure our Protagonist goes on at the end of this little Story
                var dictAdventures = ["Pencil":"had to take a test" ,
                                      "Paper": "had to take a test",
                                      "Test": "had to take a test",
                                      "Reading": "had to take a test",
                                      "Dragon": "fought a dragon",
                                      "Lizard": "fought a dragon",
                                      "Water": "dove into the water to save their love",
                                      "Pool": "dove into the water to save their love",
                                      "Sea": "dove into the water to save their love",
                                      "Ocean": "dove into the water to save their love",
                                      "Snow": "had to skii down",
                                      "Screen": "had to hack the mainframe",
                                      "Crowd": "had to stop their love from leaving them",
                                      "Standing":"Standing",
                                      "Computer": "had to hack the mainframe",
                                      "Electronics": "had to hack the mainframe",
                                      "Rowing" : "had to row a boat.",
                                      "tightrope walking" : "decided to try out tightrope walking",
                                      "judo" : "decided to learn judo",
                                      "blood sport" : "decided to try blood sport",
                                      "gymnastics" : "tried gymnastics",
                                      "gymnastic exercise" : "tried gymnastics",
                                      "water sport" : "had to use his water sport skills",
                                      "aquatics" : "started a research on aquatic animals",
                                      "track and field" : "decided to make a career in track",
                                      "outdoor sport" : "loved outdoor sport",
                                      "field sport" : "loved field sport",
                                      "contact sport" : "began to love field sport",
                                      "team sport" : "was excellent in team sport",
                                      "racing" : "loved racing",
                                      "athletic" : "became very athletic",
                                      "riding" : "went riding",
                                      "horseback riding" : "loved horses",
                                      "archery" : "loved archery and had to shoot the arrow right on point to save his life",
                                      "cycling" : "cycled the fastest he could so that he reached his destination on time",
                                      "sledding" : "had to sled down a mountain",
                                      "skating" : "had to skate the best they could",
                                      "rock climbing" : "had to save themself from falling off huge rock" ,
                                      "spectator sport" : "had to make their team win alone"
                ]
                for object in objects{
                    if let val = dictAdventures[object] { // possible problem
                        Adventure = val;
                        break;
                    }
                    else{
                        Adventure = "could not breathe and felt like somebody was choking them. Ahhh...   (but it was dream, Phew!)"
                    }
                }
                /*
                 if(objects.contains("Pencil") ||
                 objects.contains("Paper") ||
                 objects.contains("Test")){
                 Adventure = "had to take a test"
                 }
                 else if(objects.contains("Dragon") ||
                 objects.contains("Lizard")){
                 Adventure= "Fought a Dragon"
                 }
                 else if(objects.contains("Water") || objects.contains("Pool") || objects.contains("Sea") || objects.contains("Ocean")||objects.contains("Boat")){
                 Adventure = "swam to the depths of water"
                 }
                 else if(objects.contains("Snow")){
                 Adventure= "Skiing"
                 }
                 else{
                 Adventure = let Int Random = Int.Random(in 0..< (objects.count)
                 While(Adventure==Protagonist || Adventure==Activity || Adventure==Setting){
                 Adventure  = let Int Random = Int.Random(in 0..< (objects.count)
                 }
                 //Adventure = "did  " + Adventure
                 }*/
                Story = Story +  " who " + Adventure + "."
                //Story = Story
                completeStory.append(" who " + Adventure + ".")
                continue
            }
                //since there's a huge number of images add a filler sentence.
            else if (objectsall.count>=5 && i==(objectsall.count/2) ){
                var dictObjects = ["accordion": " ",
                                   "candleholder": " ",
                                   "drainer": " ",
                                   "funnel": " ",
                                   "lightbulb": " ",
                                   "pillar": " ",
                                   "sheep": " ",
                                   "tire": " ",
                                   "aeroplane": " ",
                                   "cap": " ",
                                   "dray": " ",
                                   "furnace": " ",
                                   "lighter": " ",
                                   "pillow": " ",
                                   "shell": " ",
                                   "toaster": " ",
                                   "airconditioner": " ",
                                   "car": " ",
                                   "drinkdispenser": " ",
                                   "gamecontroller": " ",
                                   "line": " ",
                                   "pipe": " ",
                                   "shoe": " ",
                                   "toilet": " ",
                                   "antenna": " ",
                                   "card": " ",
                                   "drinkingmachine": " ",
                                   "gamemachine": " ",
                                   "lion": " ",
                                   "pitcher": " ",
                                   "shoppingcart": " ",
                                   "tong": " ",
                                   "ashtray": " ",
                                   "cart": " ",
                                   "drop": " ",
                                   "gascylinder": " ",
                                   "lobster": " ",
                                   "plant": " ",
                                   "shovel": " ",
                                   "tool": " ",
                                   "babycarriage": " ",
                                   "case": " ",
                                   "drug": " ",
                                   "gashood": " ",
                                   "lock": " ",
                                   "plate": " ",
                                   "sidecar": " ",
                                   "toothbrush": " ",
                                   "bag": " ",
                                   "casetterecorder": " ",
                                   "drum": " ",
                                   "gasstove": " ",
                                   "machine": " ",
                                   "player": " ",
                                   "sign": " ",
                                   "towel": " ",
                                   "ball": " ",
                                   "cashregister": " ",
                                   "drumkit": " ",
                                   "giftbox": " ",
                                   "mailbox": " ",
                                   "pliers": " ",
                                   "signallight": " ",
                                   "toy": " ",
                                   "balloon": " ",
                                   "cat": " ",
                                   "duck": " ",
                                   "glass": " ",
                                   "mannequin": " ",
                                   "plume": " ",
                                   "sink": " ",
                                   "toycar": " ",
                                   "barrel": " ",
                                   "cd": " ",
                                   "dumbbell": " ",
                                   "glassmarble": " ",
                                   "map": " ",
                                   "poker": " ",
                                   "skateboard": " ",
                                   "train": " ",
                                   "baseballbat": " ",
                                   "cdplayer": " ",
                                   "earphone": " ",
                                   "globe": " ",
                                   "mask": " ",
                                   "pokerchip": " ",
                                   "ski": " ",
                                   "trampoline": " ",
                                   "basket": " ",
                                   "cellphone": " ",
                                   "earrings": " ",
                                   "glove": " ",
                                   "mat": " ",
                                   "pole": " ",
                                   "sled": " ",
                                   "trashbin": " ",
                                   "basketballbackboard": " ",
                                   "cello": " ",
                                   "egg": " ",
                                   "gravestone": " ",
                                   "matchbook": " ",
                                   "pooltable": " ",
                                   "slippers": " ",
                                   "tray": " ",
                                   "bathtub": " ",
                                   "chain": " ",
                                   "electricfan": " ",
                                   "guitar": " ",
                                   "mattress": " ",
                                   "postcard": " ",
                                   "snail": " ",
                                   "tricycle": " ",
                                   "bed": " ",
                                   "chair": " ",
                                   "electriciron": " ",
                                   "gun": " ",
                                   "menu": " ",
                                   "poster": " ",
                                   "snake": " ",
                                   "tripod": " ",
                                   "beer": " ",
                                   "chessboard": " ",
                                   "electricpot": " ",
                                   "hammer": " ",
                                   "meterbox": " ",
                                   "pot": " ",
                                   "snowmobiles": " ",
                                   "trophy": " ",
                                   "bell": " ",
                                   "chicken": " ",
                                   "electricsaw": " ",
                                   "handcart": " ",
                                   "microphone": " ",
                                   "pottedplant": " ",
                                   "sofa": " ",
                                   "truck": " ",
                                   "bench": " ",
                                   "chopstick": " ",
                                   "electronickeyboard": " ",
                                   "handle": " ",
                                   "microwave": " ",
                                   "printer": " ",
                                   "spanner": " ",
                                   "tube": " ",
                                   "bicycle": " ",
                                   "clip": " ",
                                   "engine": " ",
                                   "hanger": " ",
                                   "mirror": " ",
                                   "projector": " ",
                                   "spatula": " ",
                                   "turtle": " ",
                                   "binoculars": " ",
                                   "clippers": " ",
                                   "envelope": " ",
                                   "harddiskdrive": " ",
                                   "missile": " ",
                                   "pumpkin": " ",
                                   "speaker": " ",
                                   "tvmonitor": " ",
                                   "bird": " ",
                                   "clock": " ",
                                   "equipment": " ",
                                   "hat": " ",
                                   "model": " ",
                                   "rabbit": " ",
                                   "spicecontainer": " ",
                                   "tweezers": " ",
                                   "birdcage": " ",
                                   "closet": " ",
                                   "extinguisher": " ",
                                   "headphone": " ",
                                   "money": " ",
                                   "racket": " ",
                                   "spoon": " ",
                                   "typewriter": " ",
                                   "birdfeeder": " ",
                                   "cloth": " ",
                                   "eyeglass": " ",
                                   "heater": " ",
                                   "monkey": " ",
                                   "radiator": " ",
                                   "sprayer": " ",
                                   "umbrella": " ",
                                   "birdnest": " ",
                                   "coffee": " ",
                                   "fan": " ",
                                   "helicopter": " ",
                                   "mop": " ",
                                   "radio": " ",
                                   "squirrel": " ",
                                   "vacuumcleaner": " ",
                                   "blackboard": " ",
                                   "coffeemachine": " ",
                                   "faucet": " ",
                                   "helmet": " ",
                                   "motorbike": " ",
                                   "rake": " ",
                                   "stapler": " ",
                                   "vendingmachine": " ",
                                   "board": " ",
                                   "comb": " ",
                                   "faxmachine": " ",
                                   "holder": " ",
                                   "mouse": " ",
                                   "ramp": " ",
                                   "stick": " ",
                                   "videocamera": " ",
                                   "boat": " ",
                                   "computer": " ",
                                   "ferriswheel": " ",
                                   "hook": " ",
                                   "mousepad": " ",
                                   "rangehood": " ",
                                   "stickynote": " ",
                                   "videogameconsole": " ",
                                   "bone": " ",
                                   "cone": " ",
                                   "fireextinguisher": " ",
                                   "horse": " ",
                                   "musicalinstrument": " ",
                                   "receiver": " ",
                                   "stone": " ",
                                   "videoplayer": " ",
                                   "book": " ",
                                   "container": " ",
                                   "firehydrant": " ",
                                   "horse-drawncarriage": " ",
                                   "napkin": " ",
                                   "recorder": " ",
                                   "stool": " ",
                                   "videotape": " ",
                                   "bottle": " ",
                                   "controller": " ",
                                   "fireplace": " ",
                                   "hot-airballoon": " ",
                                   "net": " ",
                                   "recreationalmachines": " ",
                                   "stove": " ",
                                   "violin": " ",
                                   "bottleopener": " ",
                                   "cooker": " ",
                                   "fish": " ",
                                   "hydrovalve": " ",
                                   "newspaper": " ",
                                   "remotecontrol": " ",
                                   "straw": " ",
                                   "wakeboard": " ",
                                   "bowl": " ",
                                   "copyingmachine": " ",
                                   "fishtank": " ",
                                   "inflatorpump": " ",
                                   "oar": " ",
                                   "robot": " ",
                                   "stretcher": " ",
                                   "wallet": " ",
                                   "box": " ",
                                   "cork": " ",
                                   "fishbowl": " ",
                                   "ipod": " ",
                                   "ornament": " ",
                                   "rock": " ",
                                   "sun": " ",
                                   "wardrobe": " ",
                                   "bracelet": " ",
                                   "corkscrew": " ",
                                   "fishingnet": " ",
                                   "iron": " ",
                                   "oven": " ",
                                   "rocket": " ",
                                   "sunglass": " ",
                                   "washingmachine": " ",
                                   "brick": " ",
                                   "cow": " ",
                                   "fishingpole": " ",
                                   "ironingboard": " ",
                                   "oxygenbottle": " ",
                                   "rockinghorse": " ",
                                   "sunshade": " ",
                                   "watch": " ",
                                   "broom": " ",
                                   "crabstick": " ",
                                   "flag": " ",
                                   "jar": " ",
                                   "pack": " ",
                                   "rope": " ",
                                   "surveillancecamera": " ",
                                   "waterdispenser": " ",
                                   "brush": " ",
                                   "crane": " ",
                                   "flagstaff": " ",
                                   "kart": " ",
                                   "pan": " ",
                                   "rug": " ",
                                   "swan": " ",
                                   "waterpipe": " ",
                                   "bucket": " ",
                                   "crate": " ",
                                   "flashlight": " ",
                                   "kettle": " ",
                                   "paper": " ",
                                   "ruler": " ",
                                   "sweeper": " ",
                                   "waterskateboard": " ",
                                   "bus": " ",
                                   "cross": " ",
                                   "flower": " ",
                                   "key": " ",
                                   "paperbox": " ",
                                   "saddle": " ",
                                   "swimring": " ",
                                   "watermelon": " ",
                                   "cabinet": " ",
                                   "crutch": " ",
                                   "fly": " ",
                                   "keyboard": " ",
                                   "papercutter": " ",
                                   "saw": " ",
                                   "swing": " ",
                                   "whale": " ",
                                   "cabinetdoor": " ",
                                   "cup": " ",
                                   "food": " ",
                                   "kite": " ",
                                   "parachute": " ",
                                   "scale": " ",
                                   "switch": " ",
                                   "wheel": " ",
                                   "cage": " ",
                                   "curtain": " ",
                                   "forceps": " ",
                                   "knife": " ",
                                   "parasol": " ",
                                   "scanner": " ",
                                   "table": " ",
                                   "wheelchair": " ",
                                   "cake": " ",
                                   "cushion": " ",
                                   "fork": " ",
                                   "knifeblock": " ",
                                   "pen": " ",
                                   "scissors": " ",
                                   "tableware": " ",
                                   "window": " ",
                                   "calculator": " ",
                                   "cuttingboard": " ",
                                   "forklift": " ",
                                   "ladder": " ",
                                   "pencontainer": " ",
                                   "scoop": " ",
                                   "tank": " ",
                                   "windowblinds": " ",
                                   "calendar": " ",
                                   "disc": " ",
                                   "fountain": " ",
                                   "laddertruck": " ",
                                   "pencil": " ",
                                   "screen": " ",
                                   "tap": " ",
                                   "wineglass": " ",
                                   "camel": " ",
                                   "disccase": " ",
                                   "fox": " ",
                                   "ladle": " ",
                                   "person": " ",
                                   "screwdriver": " ",
                                   "tape": " ",
                                   "wire": " ",
                                   "camera": " ",
                                   "dishwasher": " ",
                                   "frame": " ",
                                   "laptop": " ",
                                   "photo": " ",
                                   "sculpture": " ",
                                   "tarp": " ",
                                   "cameralens": " ",
                                   "dog": " ",
                                   "fridge": " ",
                                   "lid": " ",
                                   "piano": " ",
                                   "scythe": " ",
                                   "telephone": " ",
                                   "can": " ",
                                   "dolphin": " ",
                                   "frog": " ",
                                   "lifebuoy": " ",
                                   "picture": " ",
                                   "sewer": " ",
                                   "telephonebooth": " ",
                                   "candle": " ",
                                   "door": " ",
                                   "fruit": " ",
                                   "light": " ",
                                   "pig": " ",
                                   "sewingmachine": " ",
                                   "tent": " "
                ]
                for object in objects{
                    if let val = dictObjects[object] { // possible problem
                        thing = object;
                        break;
                    }
                    else{
                        thing = "invisible unicorn"
                    }
                }
                
                // Get jake's continuation after full stop before new sentence
                Story = Story + " (By the way, there was also a(n) " + thing + " but that does not matter."
                completeStory.append(" (By the way, there was also a(n) " + thing + " but that does not matter.")
                continue
            }
            else{
                //Discover the activity our protagonist is participating in at the start
                //of our tale
                var dictActivities = ["Boat":"swimming" ,
                                      "Water": "swimming",
                                      "Sail": "swimming",
                                      "Reading": "Reading",
                                      "Book": "Reading",
                                      "Fighting": "Fighting",
                                      "Sword": "Fighting",
                                      "Eating": "Eating",
                                      "Food": "Eating",
                                      "Jogging": "Jogging",
                                      "Dancing": "Dancing",
                                      "Screen": "Hacking",
                                      "Sitting": "Sitting",
                                      "Standing":"Standing"]
                for object in objects{
                    if let val = dictActivities[object] { // possible problem
                        Activity = val;
                        break;
                    }
                    else{
                        Activity = "chilling"
                    }
                }
                Story = Story + " who was " + Activity
                completeStory.append(" who was " + Activity)
                continue
                /*
                 if(objects.contains("Reading") || objects.contains("Book")){
                 Activity = "Reading"
                 }
                 else if(objects.contains("Fighting") || objects.contains("Sword")){
                 Activity = "Fighting"
                 }
                 else if(objects.contains("Eating")){
                 Activity = "Eating"
                 
                 else if(objects.contains("Jogging") || objects.contains("Running")){
                 Activity = "Running"
                 }
                 else if(objects.contains("Dancing")){
                 Activity = "Dancing"
                 }
                 else if(objects.contains("Swimming") || objects.contains("Water")){
                 Activity = "Swimming"
                 }
                 else if(objects.contains("Screen")){
                 Activity = "Hacking"
                 }
                 else{
                 Activity  = let Int Random = Int.Random(in 0..< (objects.count)
                 While (Activity == Protagonist){
                 Activity  = let Int Random = Int.Random(in 0..< (objects.count)
                 }
                 }
                 */
            }
            
            
            //end this by printing out our story
            print(Story)
            //completeStory.append(Story)
        }
        print("\n \n")
        print(completeStory)
        //print(Story)
        return completeStory
        
    }
}

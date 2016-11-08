//
//  ViewController.swift
//  StrongWeak
//
//  Created by Jim Campagno on 11/5/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    
    var button: UIButton! //ok
    var movieLabels: [UILabel]! //ok
    var thankYouLabel: UILabel! //ok
    var movieImageView: UIImageView! //ok
    
    @IBOutlet weak var movieLabelOne: UILabel! //ok
    @IBOutlet weak var movieLabelTwo: UILabel! //ok
    @IBOutlet weak var movieLabelThree: UILabel! //ok
    @IBOutlet weak var movieLabelFour: UILabel! //ok
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad() //ok
        view.backgroundColor = UIColor(red:0.14, green:0.10, blue:0.36, alpha:1.00) //ok
        movieLabels = [movieLabelOne, movieLabelTwo, movieLabelThree ,movieLabelFour] //ok
        createButton() //ok
        createThankYouLabel() //ok
        createMovieImageView() //ok
        
    }
    
}


// MARK: - Actions
extension ViewController {
    
    func handleTap(sender: UIButton) {
        
        for label in movieLabels {
            if button.frame.intersects(label.frame) {
                fadeOutLabels() //ok
                searchFilm(label.text!)
                break
            }
        }
        
    }
    
    func movingView(sender: UIPanGestureRecognizer) { //ok
        
        let center = sender.location(in: view) //ok
        button.center = center //ok
        
    }
    
    func fadeOutLabels() { //ok
        
        movieLabels.forEach { label in //ok
            UIView.animate(withDuration: 0.8) { _ in //ok
                label.alpha = 0.0 //ok
            }
        }
        
    }
    
    func display(image: UIImage) {
        
        movieImageView.image = image
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            
            self.movieImageView.alpha = 1.0
            self.thankYouLabel.alpha = 1.0
            
        }) { _ in }
        
    }
    
}


// MARK: - Download
extension ViewController {
    
    func searchFilm(_ title: String) {
        
        let search = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let string = "http://www.omdbapi.com/?t=\(search)&y=&plot=short&r=json"
        
        let url = URL(string: string)!
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { [unowned self] data, response, error in
            
            guard let movieData = data else { return }
            
            let json = try! JSONSerialization.jsonObject(with: movieData, options: .allowFragments) as! [String : Any]
            
            let posterString = json["Poster"] as! String
            
            let posterURL = URL(string: posterString)!
            
            OperationQueue.main.addOperation {
                
                self.button.isHidden = true
                
                self.downloadImage(at: posterURL)
                
            }
            
            }.resume()
    }
    
    func downloadImage(at url: URL) {
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { [unowned self] data, response, error in
            
            guard let imageData = data else { return }
            
            let image = UIImage(data: imageData)!
            
            OperationQueue.main.addOperation {
                
                self.display(image: image)
                
            }
            
            }.resume()
    }
    
    
}


// MARK: - Creation
extension ViewController {
    
    func createButton() { //ok
        
        let frame = createSquareFrame(withSide: 100) //ok
        button = UIButton(type: .system) //ok
        button.frame = frame //ok
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside) //ok
        button.layer.cornerRadius = frame.size.height / 2 //ok
        button.clipsToBounds = true //ok
        view.addSubview(button) //ok
        button.backgroundColor = UIColor.red.withAlphaComponent(0.6) //ok
        createGestureRecognizer() //ok
        
    }
    
    func createThankYouLabel() { //ok
        
        thankYouLabel = UILabel() //ok
        thankYouLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 38.0) //ok
        thankYouLabel.textColor = UIColor.white //ok
        thankYouLabel.text = "Thanks Laura! 🎉" //ok
        thankYouLabel.alpha = 0.0 //ok
        thankYouLabel.translatesAutoresizingMaskIntoConstraints = false //ok
        view.addSubview(thankYouLabel) //ok
        thankYouLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //ok
        thankYouLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50.0).isActive = true //ok
        
    }
    
    func createMovieImageView() { //ok
        
        let height = view.frame.size.height * 0.4 //ok
        let width = (300 / 461) * height //ok
        let origin = randomXandY(height: height, width: width) //ok
        let frame = CGRect(x: origin.x, y: origin.y, width: width, height: height) //ok
        
        movieImageView = UIImageView(frame: frame) //ok
        view.addSubview(movieImageView) //ok
        movieImageView.contentMode = .scaleAspectFill //ok
        movieImageView.clipsToBounds = true //ok
        movieImageView.alpha = 0.0 //ok
        
    }
    
    func createSquareFrame(withSide side: CGFloat) -> CGRect { //ok
        
        let height = side //ok
        let width = side //ok
        let y = (view.frame.size.height / 2) - (side / 2) //ok
        let x = (view.frame.size.width / 2) - (side / 2) //ok
        return CGRect(x: x, y: y, width: width, height: height) //ok
        
    }
    
    func createGestureRecognizer() { //ok
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(movingView)) //ok
        button.addGestureRecognizer(gesture) //ok
        
    }
    
    func randomXandY(height: CGFloat, width: CGFloat) -> (x: CGFloat, y: CGFloat) { //ok
        
        let minX = 0 + (width / 2) //ok
        let maxX = view.frame.size.width - (width) //ok
        let minY = 0 + (height / 2) //ok
        let maxY = view.frame.size.height - (height) //ok
        
        let x = CGFloat(arc4random_uniform(UInt32(maxX - minX))) + minX //ok
        let y = CGFloat(arc4random_uniform(UInt32(maxY - minY))) + minY //ok
        
        return (x, y) //ok
        
    }
    
}

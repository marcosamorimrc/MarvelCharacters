//
//  CharacterAppearances.swift
//  Marvel
//
//  Created by Marcos Amorim on 24/07/19.
//  Copyright © 2019 Marcos Amorim. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage
import NVActivityIndicatorView

class CharacterAppearances: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var clipView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagesLabel: UILabel!
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    let COMICS_ID   = 1
    let SERIES_ID   = 2
    let STORIES_ID  = 3
    let EVENTS_ID   = 4
    
    var appearance_ID: Int!
    var totalAppearances: Int!
    var currentPage: Int!
    var stopSearching: Bool!
    var CharacterInfo: NSDictionary!
    var CharacterAppearances: NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = 1
        stopSearching = false
        scrollView.delegate = self
        
        formatLayout()
        loadCharacterAppearances(id: appearance_ID, offset: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.becomeTransparent()
        
    }
    
    func formatLayout(){
        
        var closeIcon = UIImage(named: "close-button.png")
        closeIcon = closeIcon?.resizeImage(newSize: CGSize(width: 27, height: 27))
        let closeButton = UIBarButtonItem.init(image: closeIcon, style: .done, target: self, action: #selector(closeViewController(_:)))
        closeButton.tintColor = .white
        
        self.navigationItem.rightBarButtonItems = [closeButton]
        
        let frame = CGRect(x: view.center.x - 15, y: view.center.y - 15, width: 30, height: 30)
        self.activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .lineSpinFadeLoader, color: .white, padding: nil)
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()
    }
    
    func loadCharacterAppearances(id: Int, offset: Int) {
        
        var appearanceType: String!
        
        switch id {
        case COMICS_ID:
            appearanceType = "comics"
        case SERIES_ID:
            appearanceType = "series"
        case STORIES_ID:
            appearanceType = "stories"
        case EVENTS_ID:
            appearanceType = "events"
        default:
            closeViewController(self)
        }
        
        let characterID: String! = "\(CharacterInfo["id"] ?? "")"
        let ts = NSDate().timeIntervalSince1970
        let key1 = "43e5847cc852d80327cc0131276d8942"
        let key2 = "6b5a8bd485c6e851ff51d69c7e9a13113216315f"
        let hash = "\(ts)\(key2)\(key1)".md5()
        let url = "https://gateway.marvel.com:443/v1/public/\(appearanceType!)?offset=\(offset)&characters=\(characterID!)&limit=10&ts=\(ts)&apikey=\(key1)&hash=\(hash!)"
        
        print("url : \(url)")
        Alamofire.request(url).validate().responseJSON  { response in
            switch response.result {
            case .success:
                print("Success")
                if let json = response.result.value {
                    
                    let data = (json as! NSDictionary)["data"]!
                    
                    let dataOffset = ((data as! NSDictionary)["offset"] as! Int)
                    let dataLimit = ((data as! NSDictionary)["limit"] as! Int)
                    let dataTotal = ((data as! NSDictionary)["total"] as! Int)
                    self.totalAppearances = dataTotal
                    
                    if dataTotal != 0{
                        
                        for element in ((data as! NSDictionary)["results"]! as! NSArray){
                            self.CharacterAppearances.add(element)
                        }
                        
                        if dataOffset+dataLimit >= dataTotal{
                            self.stopSearching = true
                        }else{
                            self.stopSearching = false
                        }
                        
                        self.pagesLabel.text = "\(self.currentPage!)/\(dataTotal)"
                        self.createAppearancesScrollView(offset: offset)
                    }else{
                        self.alertNoAppearances(appearanceType: appearanceType)
                    }
                    
                }
            case .failure(_):
                print("Failure")
                self.activityIndicatorView.stopAnimating()
                self.alertErrorLoading()
            }
        }
        
    }
    
    func createAppearancesScrollView(offset: Int) {
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(CharacterAppearances.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in offset ..< CharacterAppearances.count {
            
            let page: Appearance = Bundle.main.loadNibNamed("Appearance", owner: self, options: nil)?.first as! Appearance
            
            page.frame = CGRect(x: (scrollView.frame.width * CGFloat(i)) + (scrollView.frame.width * 0.1), y: 0, width: (scrollView.frame.width * 0.8 ), height: scrollView.frame.height)
            
            let title = "\(((self.CharacterAppearances.object(at: i) as! NSDictionary)["title"] as! String))"
            
            page.appearanceTitle.text = title

            
//            let thumbnail = (CharacterAppearances.object(at: i) as! NSDictionary)["thumbnail"]
            
            if let id = (CharacterAppearances.object(at: i) as! NSDictionary)["thumbnail"] as? NSNull {
                
                page.appearanceImage.image = UIImage(named: "unavailable_portrait_xlarge.jpg")
            }else{
                let thumbnail = (CharacterAppearances.object(at: i) as! NSDictionary)["thumbnail"] as! NSDictionary
                let imageUrl = "\(thumbnail["path"]!)/portrait_uncanny.\(thumbnail["extension"]!)"
                
                page.appearanceImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "square-placeholder.jpg"))
            }
            
            
            scrollView.addSubview(page)
        }
        activityIndicatorView.stopAnimating()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex: Int = Int(round(scrollView.contentOffset.x/scrollView.frame.width))+1
        pagesLabel.text = ("\(pageIndex)/\(totalAppearances ?? CharacterAppearances.count)")
        currentPage = pageIndex
        
        if pageIndex == CharacterAppearances.count - 2{
            if !stopSearching{
                stopSearching = true;
                loadCharacterAppearances(id: appearance_ID, offset: CharacterAppearances.count)
            }
        }
        
    }
    
    func alertNoAppearances(appearanceType: String) {
        
        let alert = UIAlertController(title: "No appearances", message: "No \(appearanceType) found for this character.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.closeViewController(self)
        }))
        self.present(alert, animated: true)
        
    }
    
    func alertErrorLoading() {
        
        let alert = UIAlertController(title: "Error", message: "Could not load appearances, check if you are connected to the internet.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.closeViewController(self)
        }))
        self.present(alert, animated: true)
        
    }
    
    @IBAction func closeViewController(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

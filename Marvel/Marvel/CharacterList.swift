//
//  CharacterList.swift
//  Marvel
//
//  Created by Marcos Amorim on 22/07/19.
//  Copyright © 2019 Marcos Amorim. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import CommonCrypto

class CharacterList: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    let CELL_HEIGHT_NORMAL = 160
    let CELL_HEIGHT_SMALL = 80

    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var charactersTableView: UITableView!
    
    
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 8, y: 0, width: 300, height: 30))
    var charactersArray: NSMutableArray = []
    var isSearching: Bool!
    var stopSearching: Bool!
    var data: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersTableView.delegate = self
        charactersTableView.dataSource = self
        isSearching = false
        stopSearching = false
        
        formataLayout()
        loadCharacters(offset: 0)
        
    }
    
    func formataLayout() {
        
        var logo = UIImage(named: "logomarvel.png")
        logo = logo?.resizeImage(newSize: CGSize(width: 82, height: 29))
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView

        var searchIcon = UIImage(named: "searchIcon.png")
        searchIcon = searchIcon?.resizeImage(newSize: CGSize(width: 27, height: 27))
        searchButton.image = searchIcon
        
        searchBar.delegate = self
        searchBar.placeholder = "Character name"
        searchBar.barTintColor = .black;
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        charactersTableView.tableHeaderView = UIView(frame: frame)
        
        charactersTableView.separatorInset = .zero
//        charactersTableView.layoutMargins = .zero
        
    }
    
    func loadCharacters(offset: Int){

        let ts = NSDate().timeIntervalSince1970
        let key1 = "43e5847cc852d80327cc0131276d8942"
        let key2 = "6b5a8bd485c6e851ff51d69c7e9a13113216315f"
        let hash = "\(ts)\(key2)\(key1)".md5()
        let url = "https://gateway.marvel.com:443/v1/public/characters?offset=\(offset)&ts=\(ts)&apikey=\(key1)&hash=\(hash!)"
        
        if offset == 0 {
            charactersTableView.separatorStyle = .none
            isSearching = false
            charactersArray.removeAllObjects()
        }
        
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
                    
                    if dataOffset+dataLimit >= dataTotal{
                        self.stopSearching = true
                    }else{
                        self.stopSearching = false
                    }
                    for element in ((data as! NSDictionary)["results"]! as! NSArray){
                        self.charactersArray.add(element)
                    }

                    self.charactersTableView.reloadData()
                }
            case .failure(_):
                print("Failure")
            }
        }
        
    }
    
    func loadCharacters(name: String, offset: Int){
        
        let ts = NSDate().timeIntervalSince1970
        let key1 = "43e5847cc852d80327cc0131276d8942"
        let key2 = "6b5a8bd485c6e851ff51d69c7e9a13113216315f"
        let hash = "\(ts)\(key2)\(key1)".md5()
        let url = "https://gateway.marvel.com:443/v1/public/characters?offset=\(offset)&nameStartsWith=\(name)&ts=\(ts)&apikey=\(key1)&hash=\(hash!)"
        
        if offset == 0 {
            charactersTableView.separatorStyle = .singleLine
            isSearching = true
            charactersArray.removeAllObjects()
        }
        
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
                    
                    if dataOffset+dataLimit >= dataTotal{
                        self.stopSearching = true
                    }else{
                        self.stopSearching = false
                    }
                    
                    for element in ((data as! NSDictionary)["results"]! as! NSArray){
                        self.charactersArray.add(element)
                    }
                    
                    self.charactersTableView.reloadData()
                }
            case .failure(_):
                print("Failure")
            }
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            self.loadCharacters(offset: 0)
        }else{
            self.loadCharacters(name: searchText, offset: 0)
        }
    }
    
    @IBAction func toggleSearch(_ sender: Any) {
        
        if navigationItem.titleView == searchBar {
            
            var logo = UIImage(named: "logomarvel.png")
            logo = logo?.resizeImage(newSize: CGSize(width: 82, height: 29))
            let imageView = UIImageView(image:logo)
            self.navigationItem.titleView = imageView
            
            var searchIcon = UIImage(named: "searchIcon.png")
            searchIcon = searchIcon?.resizeImage(newSize: CGSize(width: 27, height: 27))
            searchButton.image = searchIcon
            
            if searchBar.text == ""{
                self.loadCharacters(offset: 0)
            }
            
        }else{
            self.navigationItem.titleView = searchBar
            searchButton.image = nil
            searchBar.becomeFirstResponder()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactersArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isSearching {
            return CGFloat(CELL_HEIGHT_SMALL)
        }else{
            return CGFloat(CELL_HEIGHT_NORMAL)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastElement = charactersArray.count - 1
        if indexPath.row == lastElement {
            if !stopSearching{
                if isSearching{
                    loadCharacters(name: searchBar.text!, offset: charactersArray.count)
                }else{
                    loadCharacters(offset: charactersArray.count)
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if  isSearching{
            
            let width = Int(charactersTableView.frame.size.width)
            let height = CELL_HEIGHT_SMALL
            
            let cell: UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: indexPath.row*height, width: width, height: height))
            cell.contentView.backgroundColor = .darkGray
            
            let name = (self.charactersArray.object(at: indexPath.row) as! NSDictionary)["name"] as! String
            let nameLabel = UILabel.init(frame: CGRect(x: height+6, y: 0, width: width-(height+6), height: height))
            nameLabel.text = name
            nameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            nameLabel.textColor = .white
            
            let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: height, height: height))
            
            let thumbnail = (self.charactersArray.object(at: indexPath.row) as! NSDictionary)["thumbnail"] as! NSDictionary
            let url = "\(thumbnail["path"]!)/standard_large.\(thumbnail["extension"]!)"
            
//            cell.imageView!.frame = CGRect(x: 0, y: 0, width: height, height: height)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "square-placeholder.jpg"))
            

            cell.addSubview(imageView)
            cell.addSubview(nameLabel)
            
            cell.selectionStyle = .none
            
            cell.tag = indexPath.row
            
            return cell
            
        }else{
            
            let width = Int(charactersTableView.frame.size.width)
            let height = CELL_HEIGHT_NORMAL
            
            let cell: UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: indexPath.row*height, width: width, height: height))
            
            let name = (self.charactersArray.object(at: indexPath.row) as! NSDictionary)["name"] as! String
            
            let nameLabel = UILabel.init(frame: CGRect(x: 18, y: 80, width: 150, height: 40))
            nameLabel.backgroundColor = .white
            nameLabel.text = name
            nameLabel.textAlignment = .center
            nameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            nameLabel.adjustsFontSizeToFitWidth = true
            nameLabel.diagonalEdges()
            
            let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
            
            let thumbnail = (self.charactersArray.object(at: indexPath.row) as! NSDictionary)["thumbnail"] as! NSDictionary
            let url = "\(thumbnail["path"]!)/landscape_incredible.\(thumbnail["extension"]!)"
            
            imageView.sd_setImage(with: URL(string: url))
            imageView.contentMode = .bottom
            imageView.clipsToBounds = true
            cell.addSubview(imageView)
            cell.addSubview(nameLabel)
            
            cell.selectionStyle = .none
            
            cell.tag = indexPath.row
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchBar.resignFirstResponder()
        
        let selectedCharacter = charactersArray[indexPath.row]
        let destinationVC = CharacterDetails()
        destinationVC.CharacterInfo = (selectedCharacter as! NSDictionary)
        
        self.performSegue(withIdentifier: "showDetails", sender: tableView.cellForRow(at: indexPath))
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetails"{
            
            let destinationVC = segue.destination as! CharacterDetails
            let index = (sender as! UITableViewCell).tag
            let selectedCharacter = (charactersArray[index] as! NSDictionary)
            
            destinationVC.CharacterInfo = selectedCharacter
        }
    }

}



import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        //добавление картинки и ее расположение в своем профиле
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
    
        
    }
    
    var user : User?{
        didSet{
           setupProfileImage()
        }
    }
    fileprivate func setupProfileImage() {
        guard let profileImageURl = user?.profileImageURl else {return}
        guard let url = URL(string: profileImageURl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            //чек ошибки , затем загрузка картинки из базы
            if let err = err {
                print("Failed to fetch profile image:" , err )
                return
            }
            
            //проверка статуса (если 200 то все ОК)
            guard let data = data else {return}
            
            let image = UIImage(data: data)
            DispatchQueue.main.async{
                self.profileImageView.image = image
            }
            }.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

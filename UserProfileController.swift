
import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        navigationItem.title = FIRAuth.auth()?.currentUser?.uid
        
        fetchUser()
        
        //обязательно при создании хедера иначе будет падать приложение 
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        
        setupLogOutButton()
        
        fetchPosts()
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        let ref = FIRDatabase.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value)
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            dictionaries.forEach({ (key,value) in
                //print("Key: \(key) , Value: \(value)")
                guard let dictionary = value as? [String: Any] else {return}
                let imageUrl = dictionary["imageUrl"] as? String
                
                let post = Post(dictionary: dictionary)
                print(post.imageUrl)
                self.posts.append(post)
            })
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch posts: ", err)
            
        }
    }
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    func handleLogOut() {
        //создаем всплывающее окно
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        present(alertController, animated: true, completion: nil)
        
        //добавляем две кнопки для всплывающего окна
        alertController.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            //выходим из приложения
            do {
                try FIRAuth.auth()?.signOut()
                
                //переходим на логин контроллер
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            } catch let SignOutErr {
                print("Failed to sign out: " , SignOutErr)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
    }
    
    //указываем количество ячеек
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    //создание ячейки для одной фотографии
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
        cell.post = posts[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //расстояние между ячейками по горизонтали
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //чтобы была таблица по три элемента в строке
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        
        return header
    }
    
    //задаем размеры хедера в collectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    var user : User?
    
    //получаем ник зарегистрированного пользователя
    fileprivate func fetchUser() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            
            self.user = User(dictionary: dictionary )
            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch user:" , err)
        }
    }
}


struct User{
    let username : String
    let profileImageURl : String
    
    init(dictionary : [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURl = dictionary["profileImageURl"] as? String ?? ""
        
    }
}

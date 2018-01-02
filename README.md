# Json_Api_Model_NetworkGenerator

#### attempt to automate the process of generating the models for jsonApi.org.
we use three models for same purpose.

```Resource model``` -> its is used for fetchin posting updating the models. It inherites the Resource class.
```RealmModel``` -> this model is used for saving to the realm.
```normalModel``` -> this model is used app wide.

we need to write the converting functions too. which is easy but tedious and time consuming.
with few bugs i successfully was able to automate these things.

## Generates models for JsonApi.org specification along with Realm model for offline persistence of data.
Implements Spine library.

It generates three models.
```Resource model``` -> its is used for fetchin posting updating the models. It inherites the Resource class.
```RealmModel``` -> this model is used for saving to the realm.
```normalModel``` -> this model is used app wide.



## Syntax: 

```ruby generator --m=ModelName --a=VariableName:VariableType --a=VariableName1:VariableType1 --a...... as long as the models attributes```


## example:
first assign path to your project folder.(any folder will work)
At the top of the file, generator.rb

```@file_base_path = "/Users/shishirsapkota/office/B2BOrderingiOS/B2BOrdering/Model"```

this will generate models at this folder.


```ruby generators.rb --m=Profile --a=email:String --a=username:String --a=firstName:String --a=lastName:String```


will generate Profile.swift file





// resource class containing following code:
sorry for indentation proble. cmd+ a and ctrl+i will do magic.

# please read the errors in comments. they are bugs. Bot very big prob to solve.


```import Foundation
import RealmSwift

class Profile: Resource {
    
    // Attributes
    @objc dynamic var email: String? 
    @objc dynamic var username: String?
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var id: String?  // Error -> this should be removed
    
    
    
    // required blocks
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    required init() { super.init() }
    
    override class var resourceType: ResourceType {
        return "profiles"
    }
    
    
    override class var fields: [Field] {
        return fieldsFromDictionary([   
            "email":  Attribute().serializeAs("email")      // error there are no comas in the array.
            "username":  Attribute().serializeAs("username") // error there are no comas in the array.
            "firstName":  Attribute().serializeAs("firstName") // error there are no comas in the array.
            "lastName":  Attribute().serializeAs("lastName") // error there are no comas in the array.
            
            ])
    }
    
    
    func realmModel() -> ProfileRealmModel {
        let model = ProfileRealmModel()
        model.email = self.email ?? ""
        model.username = self.username ?? ""
        model.firstName = self.firstName ?? ""
        model.lastName = self.lastName ?? ""
        model.id = self.id ?? "-1"
        
        return model
    }
    
}

// realm class

class ProfileRealmModel: Object {
    
    // Attributes
    @objc dynamic var email: String = "" 
    @objc dynamic var username: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var id: String = "-1"
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func resourceModel() -> Profile {
        let model = Profile()
        model.email = self.email
        model.username = self.username
        model.firstName = self.firstName
        model.lastName = self.lastName
        model.id = self.id
        
        return model
    }
    
    func normalModel() -> ProfileModel {
        let model = ProfileModel()
        model.email = self.email
        model.username = self.username
        model.firstName = self.firstName
        model.lastName = self.lastName
        model.id = self.id
        
        return model
    }
    
}


// model class
class ProfileModel {
    var email: String? 
    var username: String?
    var firstName: String?
    var lastName: String?
    var id: String?
    
}


```
the part of the function to fetch the api  looks like this. we first get the ```resource model```. then convert to ```realmModel``` and save.
then we convert the ```realmModel``` and convert to ```profileModel```. ```ProfileModel``` is then feed to the app. and we use it every wehere.
while posting or updating. the normal model is converted to realm and further to recource model.

``` func fetchProfile(success: @escaping (ProfileModel) -> (), failure: @escaping  (Error) -> ()) {
        func sendSuccess() {
            let realmModels: [ProfileRealmModel] = self.fetch()
            if let models = realmModels.map({$0.normalModel()}).first {
                success(models)
            }
        }
        if NetworkReachabilityManager()?.isReachable == true {
            self.apiManager.fetch(completion: { (resource: ResourceCollection) in
                if let appInfos = resource.resources  as? [Profile] {
                    let oldRealmModels: [ProfileRealmModel] = self.fetch()
                    self.delete(models: oldRealmModels)
                    let realmModels = appInfos.map{$0.realmModel()}
                    self.save(models: realmModels)
                    sendSuccess()
                }
            }) { (error: Error) in
                failure(error)
                sendSuccess()
            }
        } else {
            let error = GlobalConstants.Errors.internetConnectionOffline
            sendSuccess()
            failure(error)
        }
    }

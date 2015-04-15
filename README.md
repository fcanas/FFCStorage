# FFCStorage

[![CI Status](http://img.shields.io/travis/fcanas/FFCStorage.svg?style=flat)](https://travis-ci.org/fcanas/FFCStorage)

Auth and Network handling so you can store models in a RESTful API.

```objc
// Configure a network client
FFCNetworkClient *networkClient = [[FFCNetworkClient alloc] initWithHost:@"api.example.com" path:@"v1"];
[networkClient makeDefaultClient];

// Get some models
FFCNetworkStore *networkStore = [[FFCNetworkStore alloc] init];
[networkStore getClass:[Foo class] completion:^(NSArray *foos, NSError *error) {
    // we have foos
}];
```

Model classes that can be CRUDed just need to implement a simple protocol:

```objc
@protocol FFCStoreModel <NSObject>

@property (nonatomic, assign) NSInteger id; // remote id

- (NSString *)route; // route for instance
+ (NSString *)route; // route for class

- (NSDictionary *)asJSON; // Serialize into dictionary if class is POST/PUTable
@end
```

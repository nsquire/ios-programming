//
//  AssetTypeViewController.h
//  Homepwner
//
//  Created by Nick on 11/22/12.
//
//

#import <UIKit/UIKit.h>

@interface AssetTypeViewController : UIViewController <UINavigationBarDelegate>
{
    __weak IBOutlet UITextField *labelTextField;
}

@property (nonatomic, copy) void (^dismissBlock)(void);

@end

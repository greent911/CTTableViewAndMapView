//
//  CTViewController.h
//  Cities
//
//  Created by  on 2013/4/6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface CTViewController : UIViewController<UIActionSheetDelegate>

@property (nonatomic, strong) NSDictionary *cityD;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *local;
@property (strong, nonatomic) IBOutlet UILabel *lat;
@property (strong, nonatomic) IBOutlet UILabel *lon;
@property (strong, nonatomic) IBOutlet UILabel *region;


- (IBAction)share:(id)sender;

@end

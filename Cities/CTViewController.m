//
//  CTViewController.m
//  Cities
//
//  Created by  on 2013/4/6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CTViewController.h"
#import "CTDataSource.h"

@implementation CTViewController

@synthesize cityD;
@synthesize imageView;
@synthesize local;
@synthesize lat;
@synthesize lon;
@synthesize region;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setLocal:nil];
    [self setLat:nil];
    [self setLon:nil];
    [self setRegion:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //NSLog(@"%@",[cityD description]);
    self.navigationItem.title=[cityD objectForKey:CTDataSourceDictKeyCity];
    UIImage *image = [UIImage imageNamed:[cityD objectForKey:CTDataSourceDictKeyImage]];
    
    self.imageView.image = image;
    
    self.local.text=[cityD objectForKey:CTDataSourceDictKeyLocal];
    self.lat.text=[cityD objectForKey:CTDataSourceDictKeyLatitude];
    self.lon.text=[cityD objectForKey:CTDataSourceDictKeyLongtitude];
    self.region.text=[cityD objectForKey:CTDataSourceDictKeyRegion];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)share:(id)sender {
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"Select social network service to post"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Facebook", @"Twitter", nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];

}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // We use SLComposer here. This will post on behalf of iOS or OS X.
    
    NSString *serviceType = nil;
    if (buttonIndex==0) {
        // Facebook
        serviceType = SLServiceTypeFacebook;
    } else if (buttonIndex==1) {
        // Twitter
        serviceType = SLServiceTypeTwitter;
    } else {
        return;
    }
    
    if (buttonIndex==0 || buttonIndex==1) {
        SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        NSString *text= [NSString stringWithFormat:@"%@\n",self.navigationItem.title];
        [composer setInitialText:text];
        [composer addImage:self.imageView.image];
        composer.completionHandler = ^(SLComposeViewControllerResult result) {
            NSString *title = nil;
            if (result==SLComposeViewControllerResultCancelled) title = @"Post canceled";
            else if (result==SLComposeViewControllerResultDone) title = @"Post sent";
            else title = @"Unknown";
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        };
        [self presentViewController:composer animated:YES completion:nil];
    }
}

@end

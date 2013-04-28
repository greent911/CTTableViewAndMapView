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

@end

//
//  SecondViewController.m
//  Cities
//
//  Created by  on 2013/4/7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "CTDataSource.h"
#import "CTViewController.h"
#import "CTTableViewCell.h"



@implementation SecondViewController

@synthesize continent;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[CTDataSource sharedDataSource] calculateMapViewRegion:continent];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=continent;
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"continent:%@",continent);
    // Return the number of sections.
    //NSLog(@"CountriesInContinents:%@",[[[CTDataSource sharedDataSource] arrayWithCountriesInContinents:continent] description]);
    return [[[CTDataSource sharedDataSource] arrayWithCountriesInContinent:continent] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[CTDataSource sharedDataSource] arrayWithCountriesInContinent:continent] objectAtIndex:section];
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *country = [[[CTDataSource sharedDataSource] arrayWithCountriesInContinent:continent] objectAtIndex:section];
    //NSLog(@"country:%@",country);
    return [[[CTDataSource sharedDataSource] arrayWithCitiesDictionaryInCountry:country andContinent:continent] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   // NSString *city = [[[CTDataSource sharedDataSource] dictionaryWithCityAtIndexPath:indexPath InContinent:continent] objectForKey:CTDataSourceDictKeyCity];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CTTableViewCell *cityCell = (CTTableViewCell *)cell;

    
    // Configure the cell...
    cityCell.nameLabel.text=[[[CTDataSource sharedDataSource] dictionaryWithCityAtIndexPath:indexPath InContinent:continent] objectForKey:CTDataSourceDictKeyCity];
    cityCell.regionLabel.text=[[[CTDataSource sharedDataSource] dictionaryWithCityAtIndexPath:indexPath InContinent:continent] objectForKey:CTDataSourceDictKeyRegion];
    cityCell.cityImageView.image=[UIImage imageNamed:[[[CTDataSource sharedDataSource] dictionaryWithCityAtIndexPath:indexPath InContinent:continent] objectForKey:CTDataSourceDictKeyImage]];
    
    return cell;
}
#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)sender;
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        // Fetch data by index path from data source
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSDictionary *cityD = [[CTDataSource sharedDataSource] dictionaryWithCityAtIndexPath:indexPath InContinent:continent];
        //NSLog(@"%@",[airport description]);
        
        // Feed data to the destination of the segue
        CTViewController *detailPage = segue.destinationViewController;
        detailPage.cityD = cityD;
    }
}

@end

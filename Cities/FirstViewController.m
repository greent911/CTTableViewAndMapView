//
//  FirstViewController.m
//  Cities
//
//  Created by  on 2013/4/6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "CTDataSource.h"
#import "SecondViewController.h"

@implementation FirstViewController


#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[CTDataSource sharedDataSource] arrayWithContinent] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Fetch continent data by index path from city list
    NSString *continent = [[CTDataSource sharedDataSource] ContinentAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text=continent;
    
    
    return cell;
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)sender;
    
    if ([segue.identifier isEqualToString:@"showCities"]) {
        // Fetch data by index path from data source
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSString *continent = [[CTDataSource sharedDataSource] ContinentAtIndexPath:indexPath];
        //NSLog(@"%@",[airport description]);
        
        // Feed data to the destination of the segue
        SecondViewController *secondPage = segue.destinationViewController;
        secondPage.continent = continent;
    }
}


@end

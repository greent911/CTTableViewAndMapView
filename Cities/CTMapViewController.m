//
//  CTMapViewController.m
//  Cities
//
//  Created by greent on 13/5/6.
//
//

#import "CTMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CTDataSource.h"
#import "CTViewController.h"


@interface CTMapViewController ()
{
    NSString *selectedAnnotationTitle;
}

@end

@implementation CTMapViewController

- (void)dealloc {
    
    self.mapView.delegate = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Load annotations
    [self reloadLocations:nil];
    
    
    
}

#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // Leave the UserLocation annotation default style
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    NSString * const ReuseIdentifier = @"PinAnnotation";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ReuseIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ReuseIdentifier];
    }
    
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)annotationView;
    pinAnnotationView.annotation = annotation;
    pinAnnotationView.pinColor = MKPinAnnotationColorPurple;
    pinAnnotationView.canShowCallout = YES;
    pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
    
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    //id<MKAnnotation> annotation = view.annotation;
    //DictionarywithCity(annotation.title)
    //NSLog(@"button");
    [self performSegueWithIdentifier:@"tapToDetail" sender:control];
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    id<MKAnnotation> annotation = view.annotation;
    selectedAnnotationTitle=annotation.title;
    //NSLog(@"%@",selectedAnnotationTitle);
}


- (IBAction)reloadLocations:(id)sender {
    [[CTDataSource sharedDataSource] reloadLocationData];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:[[CTDataSource sharedDataSource] annotations]];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"tapToDetail"]) {
        // Fetch data by index path from data source
        NSDictionary *cityD = [[CTDataSource sharedDataSource] dictionaryWithCity:selectedAnnotationTitle];
        // Feed data to the destination of the segue
        CTViewController *detailPage = segue.destinationViewController;
        detailPage.cityD = cityD;
    }
}


@end

//
//  CTMapViewController.h
//  Cities
//
//  Created by greent on 13/5/6.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CTMapViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)reloadLocations:(id)sender;

@end

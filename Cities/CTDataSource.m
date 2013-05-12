//
//  CTDataSource.m
//  Cities
//
//  Created by  on 2013/4/7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CTDataSource.h"
#import <CoreLocation/CoreLocation.h>


// Cache Keys
static NSString *CTDataSourceCacheKeyContinent = @"CTDataSource.Cache.Continent";
static NSString *CTDataSourceCacheKeyCountries = @"CTDataSource.Cache.%@.Countries";
static NSString *CTDataSourceCacheKeyCities = @"CTDataSource.Cache.%@.Cities";


// Dictionary Keys
NSString * const CTDataSourceDictKeyCityID=@"cityID";
NSString * const CTDataSourceDictKeyRegion=@"Region";
NSString * const CTDataSourceDictKeyLongtitude=@"Longitude";
NSString * const CTDataSourceDictKeyLocal=@"Local";
NSString * const CTDataSourceDictKeyLatitude=@"Latitude";
NSString * const CTDataSourceDictKeyContinent=@"Continent";
NSString * const CTDataSourceDictKeyCountry=@"Country";
NSString * const CTDataSourceDictKeyCity=@"City";
NSString * const CTDataSourceDictKeyImage=@"Image";

@interface CTDataSource ()
{
    NSMutableArray *annotations;
    MKCoordinateRegion region;
}

@end

@implementation CTDataSource



#pragma mark -
#pragma mark Object Lifecycle

+ (CTDataSource *)sharedDataSource {
    static dispatch_once_t once;
    static CTDataSource *sharedDataSource;
    dispatch_once(&once, ^ {
        sharedDataSource = [[self alloc] init];
    });
    return sharedDataSource;
}

- (id)init {
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"plist"];
        cityList = [NSArray arrayWithContentsOfFile:path];
        
        cache = [[NSCache alloc] init];
        
        annotations = [NSMutableArray array];

        [self reloadLocationData];
    }
    return self;
}

#pragma mark -
#pragma mark Interfaces

- (void)refresh {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"plist"];
    cityList = [NSArray arrayWithContentsOfFile:path];
    
    [self cleanCache];
}

- (void)cleanCache {
    [cache removeAllObjects];
}

- (MKCoordinateRegion)regionFromNow
{
    return region;
}


- (NSArray *)arrayWithContinent{
    NSArray *continents = [cache objectForKey:CTDataSourceCacheKeyContinent];
    
    if (!continents) {
        // Save continents into a set (remove duplicates result).
        NSMutableSet *continentsSet = [NSMutableSet set];
        for (NSDictionary *cities in cityList)
            [continentsSet addObject:[cities objectForKey:CTDataSourceDictKeyContinent]];
        
        // Convert set to array and sort the array.
        continents = [[continentsSet allObjects] sortedArrayUsingComparator:
                     ^NSComparisonResult(id obj1, id obj2) {
                         return [obj1 compare:obj2];
                     }];
        
        // Save the result into cache
        [cache setObject:continents forKey:CTDataSourceCacheKeyContinent];
    }
    //NSLog(@"arrayWithContinent:%@",[continents description]);
    
    return continents;
}
- (NSString *)ContinentAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = indexPath.row;
    NSString *continents = [[self arrayWithContinent] objectAtIndex:row];
    
    return continents;
}
- (NSArray *)arrayWithCountriesDictionaryInContinent:(NSString *) continent
{
    return [cityList filteredArrayUsingPredicate:
            [NSPredicate predicateWithBlock:
             ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                 NSDictionary *country = (NSDictionary *)evaluatedObject;
                 return [[country objectForKey:CTDataSourceDictKeyContinent] isEqualToString:continent];
             }]];

}
-(void) calculateMapViewRegion:(NSString *) continent
{
    NSArray *resultCities =[self arrayWithCountriesDictionaryInContinent:continent];
    
   
    
    CLLocationCoordinate2D upper;
    upper.latitude=[[[resultCities objectAtIndex:0] objectForKey:CTDataSourceDictKeyLatitude] doubleValue];
    upper.longitude=[[[resultCities objectAtIndex:0] objectForKey:CTDataSourceDictKeyLongtitude] doubleValue];
    CLLocationCoordinate2D lower;
    lower.latitude=[[[resultCities objectAtIndex:0] objectForKey:CTDataSourceDictKeyLatitude] doubleValue];
    lower.longitude=[[[resultCities objectAtIndex:0] objectForKey:CTDataSourceDictKeyLongtitude] doubleValue];
    
    
    for (NSDictionary *city in resultCities) {
       // CLLocationCoordinate2D latitude = [city[CTDataSourceDictKeyLatitude] intValue];
       // CLLocationCoordinate2D longitude = [city[CTDataSourceDictKeyLongtitude] intValue];
        
        if([city[CTDataSourceDictKeyLatitude] doubleValue] > upper.latitude) upper.latitude = [city[CTDataSourceDictKeyLatitude] doubleValue];
        if([city[CTDataSourceDictKeyLatitude] doubleValue] < lower.latitude) lower.latitude = [city[CTDataSourceDictKeyLatitude] doubleValue];
        if([city[CTDataSourceDictKeyLongtitude] doubleValue] > upper.longitude) upper.longitude= [city[CTDataSourceDictKeyLongtitude] doubleValue];
        if([city[CTDataSourceDictKeyLongtitude] doubleValue] < lower.longitude) lower.longitude = [city[CTDataSourceDictKeyLongtitude] doubleValue];
    }
    
    MKCoordinateSpan locationSpan;
    locationSpan.latitudeDelta = upper.latitude - lower.latitude;
    locationSpan.longitudeDelta = upper.longitude - lower.longitude;
    
    CLLocationCoordinate2D locationCenter;
    locationCenter.latitude = (upper.latitude + lower.latitude) / 2;
    locationCenter.longitude = (upper.longitude + lower.longitude) / 2;
    
    region = MKCoordinateRegionMake(locationCenter, locationSpan);

}

- (NSArray *)arrayWithCountriesInContinent:(NSString *) continent{
    NSString *cacheKey = [NSString stringWithFormat:CTDataSourceCacheKeyCountries, continent];
    NSArray *countries = [cache objectForKey:cacheKey];
   // NSLog(@"%@",[cityList description]);
    
    if (!countries) {
        // Filter array
        NSArray *resultCountries =[self arrayWithCountriesDictionaryInContinent:continent];
        //NSLog(@"%@",[resultCountries description]);
        
        // Save countries into a set (remove duplicates result).
        NSMutableSet *countriesSet = [NSMutableSet set];
        for (NSDictionary *countries in resultCountries)
            [countriesSet addObject:[countries objectForKey:CTDataSourceDictKeyCountry]];
        
        // Convert set to array and sort the array.
        countries = [[countriesSet allObjects] sortedArrayUsingComparator:
                      ^NSComparisonResult(id obj1, id obj2) {
                          return [obj1 compare:obj2];
                      }];
        
               
        // Save the result into cache
        [cache setObject:countries forKey:cacheKey];
    }
    //NSLog(@"countries in %@:%@",continent,[countries description]);
    
    return countries;

}
- (NSArray *)arrayWithCitiesDictionaryInCountry:(NSString *)country andContinent:(NSString *)continent{
    NSString *cacheKey = [NSString stringWithFormat:CTDataSourceCacheKeyCities, country];
    NSArray *cities = [cache objectForKey:cacheKey];
    
    if (!cities) {
        // Filter array
        NSArray *resultCountries =[self arrayWithCountriesDictionaryInContinent:continent];
        NSArray *resultCities=[resultCountries filteredArrayUsingPredicate:
                               [NSPredicate predicateWithBlock:
                                ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                    NSDictionary *city = (NSDictionary *)evaluatedObject;
                                    return [[city objectForKey:CTDataSourceDictKeyCountry] isEqualToString:country];
                                }]];

        
        // Sort array
        cities = [resultCities sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 objectForKey:CTDataSourceDictKeyCity] compare:[obj2 objectForKey:CTDataSourceDictKeyCity]];
        }];
        
        // Save the result into cache
        [cache setObject:cities forKey:cacheKey];
    }
    //NSLog(@"arrayWithCitiesDictionaryIn %@:%@",country,[cities description]);
    
    return cities;
}
- (NSDictionary *)dictionaryWithCityAtIndexPath:(NSIndexPath *)indexPath InContinent:(NSString*)continent{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    //NSString *country = [self arrayWithCountries][section];
    NSString *country = [[self arrayWithCountriesInContinent:continent] objectAtIndex:section];
    
    //NSDictionary *airport = [self arrayWithAirportInCountries:country][row];
    NSDictionary *city = [[self arrayWithCitiesDictionaryInCountry:country andContinent:continent] objectAtIndex:row];
    //NSLog(@"dictionaryWithCityAtIndexPath in %@:%@",continent,city);
    
    return city;

}
- (void)reloadLocationData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"plist"];
    cityList = [NSArray arrayWithContentsOfFile:path];
    //NSLog(@"%@",[cityList description]);
    
    // Remove old annotations
    [annotations removeAllObjects];
    
    for (NSDictionary *city in cityList) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationDegrees latitude = [city[CTDataSourceDictKeyLatitude] doubleValue];
        CLLocationDegrees longitude = [city[CTDataSourceDictKeyLongtitude] doubleValue];
        
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.title = city[CTDataSourceDictKeyCity];
        
        //may add changes there!!!!
        
        [annotations addObject:annotation];
        // NSLog(@"%@",[annotation title]);
       // NSLog(@"%@",[annotations description]);
        
    }
    
}

- (NSArray *)annotations {
    return [NSArray arrayWithArray:annotations];
}
-(NSDictionary *)dictionaryWithCity:(NSString *)city{
    
    NSDictionary *cityContent=nil;
    for (NSDictionary *cityD in cityList) {
        if ([[cityD objectForKey:CTDataSourceDictKeyCity] isEqualToString:city]) {
            cityContent=cityD;
        }
    }
    return cityContent;
    
}


@end

//
//  CTDataSource.h
//  Cities
//
//  Created by  on 2013/4/7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CTDataSourceDictKeyCityID;
extern NSString * const CTDataSourceDictKeyRegion;
extern NSString * const CTDataSourceDictKeyLongtitude;
extern NSString * const CTDataSourceDictKeyLocal;
extern NSString * const CTDataSourceDictKeyLatitude;
extern NSString * const CTDataSourceDictKeyContinent;
extern NSString * const CTDataSourceDictKeyCountry;
extern NSString * const CTDataSourceDictKeyCity;
extern NSString * const CTDataSourceDictKeyImage;

@interface CTDataSource : NSObject
{
    // Main data pool
    NSArray *cityList;
    // Cache data pool
    NSCache *cache;
}



+ (CTDataSource *)sharedDataSource;
- (void)refresh;
- (void)cleanCache;
- (NSArray *)arrayWithContinent;
- (NSString *)ContinentAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)arrayWithCountriesInContinent:(NSString *) continent;
- (NSArray *)arrayWithCountriesDictionaryInContinent:(NSString *) continent;

- (NSArray *)arrayWithCityInCountries:(NSString *)country Continent:(NSString *) continent;
- (NSDictionary *)DictionaryCityAtIndexPath:(NSIndexPath *)indexPath Continent:(NSString*)continent;







@end

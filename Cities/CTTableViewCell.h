//
//  CTTableViewCell.h
//  Cities
//
//  Created by greent on 13/5/13.
//
//

#import <UIKit/UIKit.h>

@interface CTTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *regionLabel;
@property (nonatomic, strong) IBOutlet UIImageView *cityImageView;

@end

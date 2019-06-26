//
//  MovieCell.h
//  FlixMovies
//
//  Created by clairec on 6/26/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *movTitle;
@property (weak, nonatomic) IBOutlet UILabel *movDesc;
@property (weak, nonatomic) IBOutlet UIImageView *movPoster;

@end

NS_ASSUME_NONNULL_END

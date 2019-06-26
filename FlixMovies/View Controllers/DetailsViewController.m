//
//  DetailsViewController.m
//  FlixMovies
//
//  Created by clairec on 6/26/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    
    NSString *backURLString = self.movie[@"backdrop_path"];
    NSString *totalBackURLString = [baseURLString stringByAppendingString:backURLString];
    
    NSURL *backURL = [NSURL URLWithString:totalBackURLString];
    
    [self.backView setImageWithURL:backURL];
    
    self.titleLabel.text = self.movie[@"title"];
    self.durLabel.text = self.movie[@"release_date"];
    self.descLabel.text = self.movie[@"overview"];
    
    [self.titleLabel sizeToFit];
    [self.descLabel sizeToFit];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

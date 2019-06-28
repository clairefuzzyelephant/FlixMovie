//
//  DetailsViewController.m
//  FlixMovies
//
//  Created by clairec on 6/26/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Foundation/Foundation.h>

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/original";
    
    NSString *backURLString = self.movie[@"backdrop_path"];
    NSString *totalBackURLString = [baseURLString stringByAppendingString:backURLString];
    
    NSURL *backURL = [NSURL URLWithString:totalBackURLString];
    
    [self.backView setImageWithURL:backURL];
    
    NSString *posterURLString = self.movie[@"poster_path"];
    
    NSString *totalPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:totalPosterURLString];
    
    [self.posterView setImageWithURL:posterURL];
    
    
    self.titleLabel.text = self.movie[@"title"];
    self.durLabel.text = self.movie[@"release_date"];
    self.descLabel.text = self.movie[@"overview"];
    
    [self.titleLabel sizeToFit];
    [self.descLabel sizeToFit];
    
    
    
}

- (IBAction)buttonTap:(id)sender {
    
    UIApplication *application = [UIApplication sharedApplication];
    
    NSString *movieName=self.movie[@"title"];
    movieName = [movieName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];

    NSString *movieString = [NSString stringWithFormat:@"https://www.fandango.com/search?q=%@&mode=movies",movieName];
    NSURL *URL=[NSURL URLWithString:movieString];
    
    //NSURL *URL = [NSURL URLWithString:@"http://www.google.com"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
    
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

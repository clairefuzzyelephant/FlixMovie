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
    
    NSString *baseURLOrig = @"https://image.tmdb.org/t/p/original";
    NSString *baseURLSmall = @"https://image.tmdb.org/t/p/w500";
    
    //original resolution url
    NSString *backURLString = self.movie[@"backdrop_path"];
    NSString *totalBackURLString = [baseURLOrig stringByAppendingString:backURLString];
    
    //small resolution url
    NSString *totalBackURLStringSmall = [baseURLSmall stringByAppendingString:backURLString];
    
    NSURL *urlSmall = [NSURL URLWithString:totalBackURLStringSmall];
    NSURL *urlLarge = [NSURL URLWithString:totalBackURLString];
    
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    
    __weak DetailsViewController *weakSelf = self;
    
    [self.backView setImageWithURLRequest:requestSmall
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                                       
                                       // smallImageResponse will be nil if the smallImage is already available
                                       // in cache (might want to do something smarter in that case).
                                       weakSelf.backView.alpha = 0.0;
                                       weakSelf.backView.image = smallImage;
                                       
                                       [UIView animateWithDuration:0.3
                                                        animations:^{
                                                            
                                                            weakSelf.backView.alpha = 1.0;
                                                            
                                                        } completion:^(BOOL finished) {
                                                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                            // per ImageView. This code must be in the completion block.
                                                            [weakSelf.backView setImageWithURLRequest:requestLarge
                                                                                      placeholderImage:smallImage
                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                                   weakSelf.backView.image = largeImage;
                                                                                               }
                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                   // do something for the failure condition of the large image request
                                                                                                   // possibly setting the ImageView's image to a default image
                                                                                               }];
                                                        }];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       // do something for the failure condition
                                       // possibly try to get the large image
                                   }];
    
    
    NSString *posterURLString = self.movie[@"poster_path"];
    
    NSString *totalPosterURLString = [baseURLOrig stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:totalPosterURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
    //fading in the image
    __weak UIImageView *weakSelf2 = self.posterView;
    [self.posterView setImageWithURLRequest:request placeholderImage:nil
                                   success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                       
                                       // imageResponse will be nil if the image is cached
                                       if (imageResponse) {
                                           NSLog(@"Image was NOT cached, fade in image");
                                           weakSelf2.alpha = 0.0;
                                           weakSelf2.image = image;
                                           
                                           //Animate UIImageView back to alpha 1 over 0.3sec
                                           [UIView animateWithDuration:0.3 animations:^{
                                               weakSelf2.alpha = 1.0;
                                           }];
                                       }
                                       else {
                                           NSLog(@"Image was cached so just update the image");
                                           weakSelf2.image = image;
                                       }
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                       // do something for the failure condition
                                   }];
    
    //[self.posterView setImageWithURL:posterURL];
    
    
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

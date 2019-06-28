//
//  MoviesGridViewController.m
//  FlixMovies
//
//  Created by clairec on 6/26/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSArray *movies;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *movieTitles;

@property (strong, nonatomic) NSArray *filteredData;
@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    
    CGFloat postersPerLine = 2;
    CGFloat width = self.collectionView.frame.size.width / postersPerLine;
    CGFloat height = 1.5 * width;
    layout.itemSize = CGSizeMake(width, height);
    
}

-(void)fetchMovies {
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // TODO: Get the array of movies
            self.movies = dataDictionary[@"results"];
            self.filteredData = self.movies;
            
            self.movieTitles = [[NSMutableArray alloc] init];
            
            for (NSDictionary *movie in self.movies){
                //NSLog(@"%@", movie[@"title"]);
                //NSLog(@"%@", movie[@"id"]);
                [self.movieTitles addObject:movie[@"title"]];
                NSLog(@"%@", self.movieTitles.firstObject);
            }
            [self.collectionView reloadData];

            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }
        [self.refreshControl endRefreshing];
    }];
    [task resume];
}




- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredData[indexPath.item];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *totalURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:totalURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
    
    //fading in the image
    __weak MovieCollectionCell *weakSelf = cell;
    [cell.movPoster setImageWithURLRequest:request placeholderImage:nil
                                   success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                       
                                       // imageResponse will be nil if the image is cached
                                       if (imageResponse) {
                                           NSLog(@"Image was NOT cached, fade in image");
                                           weakSelf.movPoster.alpha = 0.0;
                                           weakSelf.movPoster.image = image;
                                           
                                           //Animate UIImageView back to alpha 1 over 0.3sec
                                           [UIView animateWithDuration:0.3 animations:^{
                                               weakSelf.movPoster.alpha = 1.0;
                                           }];
                                       }
                                       else {
                                           NSLog(@"Image was cached so just update the image");
                                           weakSelf.movPoster.image = image;
                                       }
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                       // do something for the failure condition
                                   }];
    //cell.movPoster.image = nil;
    //[cell.movPoster setImageWithURL:posterURL];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    self.searchBar.showsCancelButton = YES;
    
    if (searchText.length != 0) {
        NSLog(@"entered search");
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject localizedCaseInsensitiveContainsString:searchText];
        }];
        NSArray *tempData = [self.movieTitles filteredArrayUsingPredicate:predicate];
        NSMutableArray *tempAdd = [[NSMutableArray alloc] init];
        
        //resetting filteredData by matching titles filtered by predicate to actual movie dictionaries
        for (NSDictionary *movieDict in self.movies){
            for (NSString *title in tempData){
                if (movieDict[@"title"] == title){
                    NSLog(@"added %@", title);
                    [tempAdd addObject:movieDict];
                }
            }
        }
        self.filteredData = tempAdd;
        
        NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.movies;
        
    }
    
    [self.collectionView reloadData];
    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.filteredData = self.movies;
    [self.collectionView reloadData];
    
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     UICollectionViewCell *tappedCell = sender;
     NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
     
     NSDictionary *movie = self.movies[indexPath.row];
     
     DetailsViewController *dvController = [segue destinationViewController];
     
     dvController.movie = movie;
 }
 

@end

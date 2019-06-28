//
//  MoviesViewController.m
//  FlixMovies
//
//  Created by clairec on 6/26/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *movieTitles;

@property (strong, nonatomic) NSArray *filteredData;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    // Start the activity indicator
    [self.activityIndicator startAnimating];
    
    [self fetchMovies];
    
    
    
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    
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
            NSLog(@"%@", dataDictionary);
            self.movies = dataDictionary[@"results"];
            self.filteredData = self.movies;
            
            self.movieTitles = [[NSMutableArray alloc] init];
            
            for (NSDictionary *movie in self.movies){
                //NSLog(@"%@", movie[@"title"]);
                //NSLog(@"%@", movie[@"id"]);
                [self.movieTitles addObject:movie[@"title"]];
                NSLog(@"%@", self.movieTitles.firstObject);
            }
            NSLog(@"%@", self.movieTitles);
            [self.tableView reloadData];
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }
        [self.refreshControl endRefreshing];
    }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredData.count;
    //return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.filteredData[indexPath.row];
    cell.movTitle.text = movie[@"title"];
    cell.movDesc.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *totalURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:totalURLString];
    cell.movPoster.image = nil;
    [cell.movPoster setImageWithURL:posterURL];
    //NSLog(@"%@", posterURL);
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
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
                    NSLog(@"added");
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
    
    [self.tableView reloadData];
    
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     UITableViewCell *tappedCell = sender;
     NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
     
     NSDictionary *movie = self.movies[indexPath.row];
     
     DetailsViewController *dvController = [segue destinationViewController];
     
     dvController.movie = movie;
 }


@end

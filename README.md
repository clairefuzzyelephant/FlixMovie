# Project 2 - FlixMovies

FlixMovies is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 13 hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [ ] User sees an error message when there's a networking error.
- [x] Movies are displayed using a CollectionView instead of a TableView.
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [x] User can view the large movie poster by tapping on a cell.
- [x] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] Customize the selection effect of the cell.
- [x] Customize the navigation bar.
- [x] Customize the UI.

The following **additional** features are implemented:

- [x] List anything else that you can get done to improve the app functionality!
**I made a button on the details view that leads to a fandango search webpage for each movie so that the user can buy movie tickets if they want. I also changed up the design a bit to make it more aesthetic.**

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. What might be useful to include in a settings tab
2. What other tabs may be useful 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

http://g.recordit.co/tLO3xmQF5s.gif

(It didn't let me embed because the gif was too long?)

GIF created with RecordIt.

## Notes

Describe any challenges encountered while building the app.

- The search bar took a bit more time because of the predicate matching - needed a bit more extra configuration than from the simple searching tutorial online.
- I tried for a while to get the actual tickets page of fandango for each movie instead of just a search results page, but the movie database didn't provide fandango movie id's. So I tried to do imdb id's, but it took quite a bit of frustration and I reverted back to working on the suggested bonus features that seemed more useful.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

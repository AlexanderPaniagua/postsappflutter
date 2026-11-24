# postsapp

Flutter app that shows posts from [JSONPlaceholder](https://jsonplaceholder.typicode.com).

- List of posts with search and pull to refresh
- Images of each post in a grid, tap one to see it full screen
- Comments of each post, with search, tap a comment to see all the text

State is handled with flutter_bloc.

## Run

```
flutter pub get
flutter run
```

Tests:

```
flutter test
```

## Endpoints

- `/posts`
- `/posts/{id}/comments`
- `/albums/{id}/photos` (each post has an album with the same id)

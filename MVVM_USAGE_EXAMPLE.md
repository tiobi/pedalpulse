# MVVM Usage Examples

This document shows how to use the new State/ViewModel architecture in your UI components.

## AuthViewModel Usage

### Setup with Provider

```dart
// In your main.dart or app initialization
MultiProvider(
  providers: [
    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(
        signInWithEmailAndPasswordUseCase: getIt<SignInWithEmailAndPasswordUseCase>(),
        signUpWithEmailAndPasswordUseCase: getIt<SignUpWithEmailAndPasswordUseCase>(),
        signInWithGoogleUseCase: getIt<SignInWithGoogleUseCase>(),
        signInWithAppleUseCase: getIt<SignInWithAppleUseCase>(),
        signOutUseCase: getIt<SignOutUseCase>(),
        sendPasswordResetEmailUseCase: getIt<SendPasswordResetEmailUseCase>(),
        isEmailVerifiedUseCase: getIt<IsEmailVerifiedUseCase>(),
        getCurrentUserUidUseCase: getIt<GetCurrentUserUidUseCase>(),
      ),
    ),
    // ... other providers
  ],
  child: MyApp(),
)
```

### Using in UI Components

```dart
class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          final state = authViewModel.state;
          
          // Handle different states
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (state.isAuthenticated) {
            // Navigate to home or return authenticated UI
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/home');
            });
          }
          
          return Column(
            children: [
              // Show error message if any
              if (state.hasError)
                ErrorBanner(message: state.errorMessage!),
                
              // Show success message if any
              if (state.hasSuccess)
                SuccessBanner(message: state.successMessage!),
                
              // Email field
              TextFormField(
                onChanged: (value) => email = value,
                decoration: InputDecoration(labelText: 'Email'),
                enabled: state.canPerformAuth,
              ),
              
              // Password field
              TextFormField(
                onChanged: (value) => password = value,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                enabled: state.canPerformAuth,
              ),
              
              // Sign In button
              ElevatedButton(
                onPressed: state.canPerformAuth ? () {
                  authViewModel.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                } : null,
                child: Text('Sign In'),
              ),
              
              // Social auth buttons
              Row(
                children: [
                  ElevatedButton(
                    onPressed: state.canPerformAuth ? () {
                      authViewModel.signInWithGoogle();
                    } : null,
                    child: Text('Google'),
                  ),
                  ElevatedButton(
                    onPressed: state.canPerformAuth ? () {
                      authViewModel.signInWithApple();
                    } : null,
                    child: Text('Apple'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
```

## UserViewModel Usage

### Setup with Provider

```dart
ChangeNotifierProvider<UserViewModel>(
  create: (context) => UserViewModel(
    getUserUseCase: getIt<GetUserUseCase>(),
    updateUserUseCase: getIt<UpdateUserUseCase>(),
    deleteUserUseCase: getIt<DeleteUserUseCase>(),
    getUserLikesUseCase: getIt<GetUserLikesUseCase>(),
    addUserLikesUseCase: getIt<AddUserLikesUseCase>(),
    removeUserLikeUseCase: getIt<RemoveUserLikeUseCase>(),
    updateUserProfileImageUseCase: getIt<UpdateUserProfileImageUseCase>(),
  ),
)
```

### Using in Profile Page

```dart
class ProfilePage extends StatefulWidget {
  final String userId;
  
  ProfilePage({required this.userId});
  
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load user data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().loadUser(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          final state = userViewModel.state;
          
          if (state.isLoading && !state.isInitialized) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (state.hasError && !state.hasUser) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.errorMessage}'),
                  ElevatedButton(
                    onPressed: () => userViewModel.loadUser(widget.userId),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (!state.hasUser) {
            return Center(child: Text('User not found'));
          }
          
          final user = state.currentUser!;
          
          return RefreshIndicator(
            onRefresh: () async => userViewModel.refresh(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Image Section
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.hasProfileImage 
                          ? NetworkImage(user.profileImageUrl)
                          : null,
                        child: !user.hasProfileImage 
                          ? Icon(Icons.person, size: 50)
                          : null,
                      ),
                      if (state.isUpdatingProfileImage)
                        Positioned.fill(
                          child: CircularProgressIndicator(),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: state.canPerformActions ? () {
                            _showImagePickerDialog(userViewModel);
                          } : null,
                          icon: Icon(Icons.camera_alt),
                        ),
                      ),
                    ],
                  ),
                  
                  // User Info
                  ListTile(
                    title: Text(user.username),
                    subtitle: Text(user.email),
                    trailing: state.isUpdatingProfile 
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          onPressed: state.canPerformActions ? () {
                            _showEditProfileDialog(userViewModel, user);
                          } : null,
                          icon: Icon(Icons.edit),
                        ),
                  ),
                  
                  // Bio
                  if (user.hasBio)
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(user.bio),
                    ),
                    
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem('Posts', user.stats.postsCount),
                      _StatItem('Likes', user.stats.likesCount),
                      _StatItem('Followers', user.stats.followersCount),
                      _StatItem('Following', user.stats.followingCount),
                    ],
                  ),
                  
                  // Error/Success Messages
                  if (state.hasError)
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.errorMessage!,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    ),
                    
                  if (state.hasSuccess)
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.successMessage!,
                        style: TextStyle(color: Colors.green.shade800),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _StatItem(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }
}
```

### Handling Post Likes

```dart
class PostCard extends StatelessWidget {
  final Post post;
  
  PostCard({required this.post});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        final isLiked = userViewModel.isPostLiked(post.uid);
        
        return Card(
          child: Column(
            children: [
              // Post content...
              
              Row(
                children: [
                  IconButton(
                    onPressed: userViewModel.state.canPerformActions ? () {
                      userViewModel.toggleLike(postUid: post.uid);
                    } : null,
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null,
                    ),
                  ),
                  Text('${post.likesCount} likes'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
```

## Key Benefits of This Architecture

1. **Separation of Concerns**: UI components only handle presentation, ViewModels handle business logic
2. **Testability**: ViewModels can be easily unit tested without UI dependencies
3. **State Management**: Clear, predictable state transitions with comprehensive coverage
4. **Error Handling**: Centralized error handling with user-friendly messages
5. **Loading States**: Granular loading indicators for better UX
6. **Optimistic Updates**: Immediate UI feedback with error recovery
7. **Code Reusability**: ViewModels can be reused across different UI components
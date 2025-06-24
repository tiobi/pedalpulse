# Clean Architecture Implementation Example Usage

## Overview

The new architecture follows strict layer separation:

```
View Layer (UI)
    ↓
Provider Layer (UI Logic & Navigation)
    ↓
View Model Layer (Business Logic Bridge)
    ↓
State Layer (Data Storage)
    ↓
Use Cases Layer (Business Logic)
    ↓
Repository Layer (Data Manipulation)
    ↓
Data Source Layer (Data Operations)
    ↓
Service Layer (External Services)
```

## Auth Feature Usage

### In your Widget (View Layer)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pedalpulse/features/auth/presentation/providers/auth_provider_new.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';
import 'package:pedalpulse/injection_container.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthProviderNew>(),
      child: Consumer<AuthProviderNew>(
        builder: (context, authProvider, _) {
          return Scaffold(
            body: Column(
              children: [
                // Email TextField
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                // Password TextField
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                // Loading indicator
                if (authProvider.state.isLoading)
                  CircularProgressIndicator(),
                // Sign In Button
                ElevatedButton(
                  onPressed: authProvider.state.isLoading ? null : () {
                    final authEntity = AuthEntity(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    authProvider.signInWithEmailAndPassword(
                      authEntity: authEntity,
                      context: context,
                    );
                  },
                  child: Text('Sign In'),
                ),
                // Error Display
                if (authProvider.state.errorMessage != null)
                  Text(
                    authProvider.state.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### Accessing Auth State

```dart
// In any widget with access to AuthProviderNew
Consumer<AuthProviderNew>(
  builder: (context, authProvider, _) {
    final authState = authProvider.state;
    
    return Column(
      children: [
        Text('Loading: ${authState.isLoading}'),
        Text('Authenticated: ${authState.isAuthenticated}'),
        Text('User UID: ${authState.userUid ?? 'Not set'}'),
        if (authState.errorMessage != null)
          Text('Error: ${authState.errorMessage}'),
        Text('Email Verification Sent: ${authState.emailVerificationSent}'),
      ],
    );
  },
)
```

## User Feature Usage

### In your Widget (View Layer)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pedalpulse/features/user/presentation/providers/user_provider_new.dart';
import 'package:pedalpulse/injection_container.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<UserProviderNew>()..getUser(context: context),
      child: Consumer<UserProviderNew>(
        builder: (context, userProvider, _) {
          final userState = userProvider.state;
          
          if (userState.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (userState.user == null) {
            return Center(child: Text('No user data available'));
          }
          
          return Scaffold(
            appBar: AppBar(title: Text('Profile')),
            body: Column(
              children: [
                CircleAvatar(
                  backgroundImage: userState.user!.profileImageUrl.isNotEmpty
                      ? NetworkImage(userState.user!.profileImageUrl)
                      : null,
                  child: userState.user!.profileImageUrl.isEmpty
                      ? Icon(Icons.person)
                      : null,
                ),
                Text('Username: ${userState.user!.username}'),
                Text('Email: ${userState.user!.email}'),
                Text('Bio: ${userState.user!.bio}'),
                Text('Likes Count: ${userState.userLikes.length}'),
                ElevatedButton(
                  onPressed: () {
                    // Example: Update user profile
                    final updatedUser = userState.user!.copyWith(
                      bio: 'Updated bio text',
                    );
                    userProvider.updateUser(
                      userEntity: updatedUser,
                      context: context,
                    );
                  },
                  child: Text('Update Profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

## Key Benefits of This Architecture

### 1. **Separation of Concerns**
- **View Layer**: Only handles UI rendering and user interactions
- **Provider Layer**: Handles UI logic, navigation, and snackbars
- **View Model Layer**: Manages business logic and state updates
- **State Layer**: Stores immutable data with copyWith functionality

### 2. **Testability**
- Each layer can be unit tested independently
- View models can be tested without UI dependencies
- State models are immutable and easily testable

### 3. **Maintainability**
- Clear boundaries between layers
- Easy to locate and fix bugs
- Business logic is separated from UI logic

### 4. **Scalability**
- Easy to add new features following the same pattern
- State management is centralized and predictable
- Dependencies are properly injected

## Migration Strategy

### For Existing Code
1. Replace old provider imports with new provider imports
2. Update widget consumers to use the new provider
3. Access state through `provider.state` instead of individual properties
4. Update any direct usecase calls to go through the provider methods

### Example Migration
```dart
// Old way
Consumer<AuthProvider>(
  builder: (context, authProvider, _) {
    return ElevatedButton(
      onPressed: authProvider.isLoading ? null : () {
        authProvider.signInWithEmailAndPassword(
          authEntity: authEntity,
          context: context,
        );
      },
      child: Text('Sign In'),
    );
  },
)

// New way
Consumer<AuthProviderNew>(
  builder: (context, authProvider, _) {
    return ElevatedButton(
      onPressed: authProvider.state.isLoading ? null : () {
        authProvider.signInWithEmailAndPassword(
          authEntity: authEntity,
          context: context,
        );
      },
      child: Text('Sign In'),
    );
  },
)
```
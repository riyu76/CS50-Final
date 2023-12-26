# Sources
The app was based on the techniques that I acquired from the freecodecamp 37 hour flutter tutorial, which was my main source of learning flutter.
https://www.youtube.com/watch?v=VPvVD8t02U8&t=88229s

The icon of the app was created through this website https://www.shopify.com/tools/logo-maker

The ui of the application took insipration from this person's work
https://dribbble.com/umerjaved021

# Introduction about the project
So this is my final project for cs50 and it took me a very long time to complete and that because the flutter course was 37 hours long and between school and exams that is why it took a very long time but it's here and I am proud of it so i will be presenting it you below and explaing what the importants files does and explain what even is my app about

# Explanation

## The Idea
the idea for my app is it acts like a daily task app which is an app that I actually need in my day to day life that is why i was insiting on making this app

## the files
### main.dart
this file is the very core of the application it acts as a renderer to render which view to the user depending on their state and it also has my routes, themes, etc

### firebase_options.dart
this file is way for the app to communicate with my firebase project which i use as a way to store user's authentication data

### tasks/register_view
this file includes my register method that i use to make a user out of the user input and send it to firebase so it can create a user and save it in the firebase database for later use

### tasks/login_view
this file is for users who already have an account and want to login in into the app by sending their information to firebase and see if that information matches the information that is stored in firebase

### tasks/verify_email_view
this is for verifying that the user's email input is actually an email that the user has a hold off and not just signing someone else for this app

### services/auth
this folder includes the files necessary for user authentication

### services/crud/crud_exceptions.dart
this file is for the exceptions thrown by the functions in task_service.dart

### services/crud/task_service.dart.dart
this file is for my crud handling functions that i use to open databases, close them, create tasks, update them or even delete them this file has a lot of functions and the explanation for each function is above it as a commnect in the file

### services/utilities
this fodlder includes my popups that is used either for loging out or just an error etc

### extensions/list/filter.dart
this file extends the filter function and make it so it can filter lists

### enums
this file has my enums which is like a list but for constants

### constants
this folder has my constant values that i use across my application"# CS50-Final" 

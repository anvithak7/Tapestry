# Tapestry

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
[Description of your app]

### App Evaluation

- **Category:** Social Networking, Lifestyle
- **Mobile:** This app makes it easy to share real-time everyday updates with close friends and family, taking advantage of a mobile device’s camera, location services, and sensors to enhance the user experience.
- **Story:** Each user can join groups with their family or friends that they want to keep in touch with, and every day (or every week or at a set time interval), they can share what has been going on in their lives with the people that matter to them most. Everyone’s updates are compiled into a newsletter-style format, which helps users know what’s happening in the lives of those in their group without having to schedule frequent calls with everyone and repeating the same information. It’s a virtual group dinner, in a way, but at everyone’s convenience. This app can be used as a personal journal, a way to stay connected and updated on close friends’ and family members’ lives, and a documentation of fond memories over the years.
- **Market:** This app can be used by anyone, but it’s primarily catered especially towards those who might be physically far away from their close friends and family, and towards older users who want to strengthen and maintain meaningful connections. To ensure it is safe, security and privacy would be primary concerns, with users only being able to join groups that they are given the code for.
- **Habit:** This app is meant to be used regularly, to continue to keep in touch with the others who are in a user’s groups. Ideally, the app would send notifications to remind users to add a message.
- **Scope:** Although the initial idea was for user-generated content to be shared, future ideas could include prompts that can be used in case no one in the group knows what to say or ways of sharing travel moments and suggestions with friends and family. A user could also use this app to keep track of their own accomplishments, such as exercising every day or learning to cook.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can login
* The current signed in user is persisted across app restarts 
* User can create groups and add friends and family members to a group
* User can view the newsletter for the time period with all of the data from their group
* User can view a list of their groups
* User can input text and share it with groups that they choose
* User can share images from the camera and photo library with their groups
* User can logout

**Optional Nice-to-have Stories**

* User can have multiple personal journals
* User can personalize their newsletter updates
* User can personalize newsletter
* User can comment on their group members’ updates
* User receives notification reminders to fill out their update
* User can message other users that they are connected with
* User can use speech to text to write their updates
* User can download pictures and media from newsletters
* A calendar shows the days where a user has made an update (like a streak calendar)

### 2. Screen Archetypes

* Login
   * User can login
* Register
   * User can create a new account
* Story Creation
   * User can input text and share it with groups that they choose
   * User can share images from the camera and photo library with their groups
   * User can log out
* Group Creation
   * User can create groups and add friends and family members to a group
* Group Stream
   * User can view a list of their groups
* Tapestry Stream
   * User can view the newsletter for the time period with all of the data from their group
* User Profile
   * User can edit their profile information
* Group Settings
   * User can view and edit group settings

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Story Creation
* Group Stream

**Flow Navigation** (Screen to Screen)

* Login/Register
   * Story Creation
* Story Creation
   * Group Creation
   * Group Stream
* Group Creation
   * Story Creation
* Group Stream
  * Tapestry Stream
  * Story Creation
  * User Profile
* Tapestry Stream
  *  Group Stream
  *  Group Settings

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

## Schema 

### Models

#### User

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique ID for the user (default field) |
   | username      | String   | user-inputted username to log in (default field) |
   | password      | String   | user's password to log in (default field) |
   | email         | String   | user's email address |
   | fullName      | String   | name of user for identifying user in their groups |
   | avatarImage   | File     | profile image for user |
   | groups        | Array of Pointers to Groups  | groups that the user has joined |
   | userStories   | Pointer to Group  | default group for a user which contains all of the stories that a user has ever woven |
   | createdAt     | DateTime | date when user is created (default field) |
   | updatedAt     | DateTime | date when user is last updated (default field) |
   
#### Group

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique ID for the group (default field) |
   | groupInviteCode  | String | unique code for other users to join the group |
   | groupName     | String   | user-defined name of group |
   | administrator | Pointer to User| creator of group and first group member |
   | membersArray  | Array of Pointers to Users   | list of all of the members in a group |
   | groupImage    | File     | image to represent the group |
   | createdAt     | DateTime | date when group is created (default field) |
   | updatedAt     | DateTime | date when group is last updated (default field) |

#### Story

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique ID for the story (default field) |
   | storyText     | String   | user's story of the day |
   | author        | Pointer to User| user who posted story |
   | groupsArray   | Array of Pointers to Groups  | groups that the story is sent to |
   | image         | File     | image added to story |
   | backgroundColor | String   | hexcode for background color for story |
   | createdAt     | DateTime | date when story is created (default field) |
   | updatedAt     | DateTime | date when story is last updated (default field) |
   
### Networking

#### List of Network Requests By Screen

* Register
   * (Create/POST) Create a new user with a full name, email, username, and password
   ```Objective C
         [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
            }
        }];
         ```
* Log In 
   * (Read/GET) Log in the user with the given credentials
   ```Objective C
         [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser * user, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User logged in successfully!");
            }
        }];
         ```
* Story Creation
   * (Create/POST) Create a new story with the given text, images, and background color
* Group Creation
   * (Create/POST) Create a new group with a name
   * (Update/PUT) Add a user to a group's membersArray and a group to a user's groups
* Group Stream
   * (Read/GET) Query all of the groups that a user is in
* Tapestry Stream
   * (Read/GET) Query stories based on the members of the group and between the dates given
   ```Objective C
         PFQuery *query = [PFQuery queryWithClassName:@"Story"];
        [query whereKey:@"groupsArray" containsAllObjectsInArray:@[self.group]];
        [query whereKey:@"createdAt" greaterThanOrEqualTo:self.startDatePicker.date];
        [query whereKey:@"createdAt" lessThanOrEqualTo:self.endDatePicker.date];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"Stories: %@", objects);
            }
        }];
         ```
* User Profile
   * (Read/GET) Query the current user object
   * (Update/PUT) Edit the user's profile image, name, username, and email
* Group Settings
   * (Read/GET) Query the current group object
   * (Update/PUT) Edit the group image and name
   * (Delete/DELETE) Remove the current user from the group

- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]



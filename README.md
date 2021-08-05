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
[Evaluation of your app across the following attributes]
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
  *  Tapestry Settings

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]



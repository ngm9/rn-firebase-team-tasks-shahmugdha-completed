# Real-Time Team Task Management

## Task Overview

You are working on a collaborative task management app built with React Native and Firebase. The app serves internal teams where multiple users simultaneously view and update shared tasks — meaning stale data and inconsistent auth state are not cosmetic bugs, they are workflow-breaking failures. The codebase has a working navigation shell and Firebase SDK configured against a live emulator, but the data layer is poorly architected: auth state leaks across screens, task data goes stale immediately after load, the MyTasks screen has no implementation, and Firestore listeners are never cleaned up. Your goal is to refactor the auth layer, implement real-time data patterns, build the missing screen, and ensure listener lifecycle is correctly managed across navigation.

## Helpful Tips

- Consider how auth state should be shared across the entire app and what happens to screens that hold a reference to a user object after sign-out
- Think about the lifecycle of a Firestore listener relative to the lifecycle of the screen that creates it
- Explore how Firestore compound queries can filter tasks by both ownership and ordering in a single query
- Review how SectionList can be used to visually group documents that share a field value
- Consider what a well-designed custom hook for a Firestore real-time query should expose to the calling component

## Objectives

- Implement a shared auth architecture so that user state is consistent across all screens and sign-out cleans up correctly
- Refactor TeamTasks to show only the current user's team tasks, grouped by status, updating in real-time as Firestore data changes
- Build the MyTasks screen to display tasks assigned to the current user, ordered by priority, with a working status toggle
- Ensure all Firestore listeners are properly unsubscribed when screens unmount or the user signs out
- Abstract Firebase data operations into reusable hooks or service functions that separate Firebase logic from UI components
- Handle loading and error states for all async Firebase operations across screens

## How to Verify

- Sign out while TeamTasks is active — confirm navigation goes to Login and no console warnings about state updates on unmounted components appear
- Open the Emulator UI at port 4000 and manually change a task's status in Firestore — confirm TeamTasks reflects the change in real-time without any user interaction
- Confirm MyTasks shows only tasks where assignedTo matches the signed-in user's UID, and that tapping a task cycles its status correctly
- Sign in as two different users and verify TeamTasks shows different task sets corresponding to each user's teamId
- Verify in the Emulator UI that status update writes from the app appear correctly in the tasks collection
- Review the code structure and confirm Firebase logic is not embedded directly inside screen components

# Project Title

SmartGoal - SMART Goal setter app

## Problem description

Many “task schedulers” and goal setting apps in the market do not guide users in formulating SMART goals. Because of this, most people do not create well-defined goals or tend to set goals without a realistic timeframe. As a consequence of this, they often fail to commit and dedicate the necessary effort to their pursued goals and do not develop the routines that will allow them to succeed. As a result, they are less likely to achieve these 
Goals.

## Solution

Our SMART goal terminal application solves this problem by guiding the user through the steps to set goals that are:

* Specific
* Measurable
* Attainable
* Relevant
* Timely

The user will first be prompted to set a description and realistic timeframe for the goal. Following the app’s SMART guidelines, he or she will be able to refine the goal to a more specific definition.

The user will be also asked to provide reasons as to why their goal is attainable and relevant which will help motivate them to achieve their goal. 

The user is also expected to provide his/her email address as well as the ones of a person who will be responsible to keep him/her on track.

The implementation of reminders make it possible to notify the user of any scheduled task through pop-up messages and emails. In the case a task has not been marked as completed before the target date, the same notifications will let the user know about his or her failure.

In this case, another email will be sent to the person the user chose as accountable for his or her performance who will be urged to motivate and encourage the user to do better.

Users have the option to add either one-off or recurring tasks with a specified frequency (daily, weekly, monthly, yearly). Our app also allows users to track completed and failed tasks as well as tasks which are yet to be done.

## Architecture

* We split our program into 8 different classes, 4 main classes and 5 utility classes:
 The GoalSetter class contains high-level information about the user and the user’s accountability partner. It also keeps track of the goals in an array and it defines the menu and methods which create, view, edit and delete goals.
  * The **Goal** class contains an array of tasks. Users can set one-off tasks with a set due date for completion. Users can also set recurring tasks by setting the frequency of a task. This creates multiple instances of a task at the time interval set by the user. If a user marks a task as completed, the task appears on the “Completed Tasks” list. Otherwise, the user will receive a failed task pop-up and email notification. The task menu allows the user to view, create, delete and mark tasks as completed.
  * The **Task** class has a status attribute set to :todo which would change to :completed if the user marks the task as completed or :failed if the user misses the task deadline.
  * Class **Scheduler**: Responsible for scheduling notifications and generating recurring tasks.
  * Class **Question**: Contains methods for the question and answer prompts and validation.
  * Module **Helpers**: Contains various helper methods for calculating frequency and validations.
  * Class **Popup**: Create pop-up messages
  * Class **Email**: Send emails
* The Smartgoals Module wraps all classes to allow us to set constants that can be accessed and/or referenced in various parts of the app and to avoid polluting the global namespace.
* Gems used: 
  * *Rufus-scheduler*: Allows scheduling of notifications and other jobs in the background.             
  https://github.com/jmettraux/rufus-scheduler
  * *Highline*: Allows us to create and store user prompts (instead of using gets) and validate user input.   
  https://github.com/JEG2/highline
  * *Tty-prompt*: Allows us to create user-friendly selection menus and provides a better user experience in the terminal.
  https://github.com/piotrmurach/tty-prompt
  * *Terminal-table*: Allows us to display information in table format.
  https://github.com/tj/terminal-table
  * *OS*: Allows us to detect the user’s operating system.
  https://github.com/rdp/os
  * *Mail*: Allows us to easily send email messages.
  https://github.com/mikel/mail
  * *Colorize*: Allows us to change the colour of text output in the terminal.
  https://github.com/fazibear/colorize
  * *Terminal-notifier*: Allows us to access MacOS notifications as we use a similar native command for Linux called notify-send.
  https://github.com/julienXX/terminal-notifier

## Problems encountered

* **Recurring tasks** - One of the first issues we had to deal with in the early stages of the project was how to implement recurring tasks. We thought of two possible approaches:
  * When the user sets the frequency (i.e. daily, monthly, weekly, etc), instances of the task are generated along with defined reminder dates and target dates. However, this could potentially store a lot of objects in memory and could be inflexible in the event that a user would want to delete a recurring task or change its frequency.
  * When creating one instance of task at time intervals using a scheduler in the background, we chose to go with this option as it allowed for greatest flexibility. We implemented it with the help of a good background scheduler gem (i.e. Rufus Scheduler).
* **Scheduling recurring task instance generation** - We struggled to decide where to place the code for generating recurring task instances at set intervals. At first, we tried delegating this responsibility to the Task instance. However doing so made it difficult to push new task instances to the Tasks array in the Goal class. After much research and testing, we solved this by putting a scheduler in the Goal class and using the every method in Rufus Scheduler to generate tasks at set intervals. We then allowed Tasks to handle the creation of pop-up messages and email notifications.
* **Deleting tasks** - Another challenge was the decision to go about deleting recurring tasks. If we deleted a recurring task instance, we had to prevent new task instances from being generated by shutting down the scheduler which are creating those tasks. We solved this by setting an ‘id’ instance variable on the scheduler to be referenced by any task created by the scheduler (which is similar to a foreign key in a database). With this method of deleting tasks, we could easily identify the scheduler by that ‘id’ and shut it down. 
* **Global variables** - Given it was bad practice to use global variables prefixed by $, we had to decide how to avoid polluting the global namespace. By looking at other code bases, we learned to wrap our classes in a Module called SmartGoals. This allowed us to set constants that would not be accessible from outside of the module.

## Utilities Used

* *Github*: Allowed us to collaborate more easily when working on the code.
* *Slack*: Facilitated smoother communication in the team.
* Lucidchart: Helpful tool for designing app architecture and classes (Appendix B).
* *SimpleMind*: Helpful for brainstorming ideas and drawing diagrams (Appendix A).
* *Google Docs*: Allowed easy collaboration on documentation.

## Future Implementations and Improvements

1. Saving the current session to preserve the data. We decided to leave this problem as optional as we didn’t have enough time to make it work. We were considering serializing objects into JSON format. Ideally, we would want to update a JSON file during the application runtime and load the data from the file upon opening the app.
2. Displaying task stats to allow user to track progress towards achieving his/her goal.
3. Success animations after tasks have been accomplished and/or the goal has been reached.
4. Implementing a graphical user interface.

## Appendix A:   Basic Concept of a SMART Goal
![alt-text](/assets/AppendixA.jpg)

## Appendix B:   Class and Attributes Diagram
![alt-text](/assets/AppendixB.jpg)

## Collaborators: 
* John Voon https://github.com/johnvoon
* Glenn Dimaliwat https://github.com/glenndimaliwat
* Alessio Palumbo https://github.com/alessio-palumbo
* Chris Edgar https://github.com/eventus1

## Todos

- [DONE] Move Date to Goal for recurring tasks (JOHN)
- [DONE] Validations email, date input - check if there's a gem# (GLENN)
- [DONE] Display task saved after adding task (JOHN)
- [DONE] View Goals - fix bug (ALESSIO)
- [DONE] Update Goals (ALESSIO)
- [DONE] Remove Goals (ALESSIO)
- [DONE] View tasks (JOHN)
- [DONE] Update tasks (JOHN)
- [DONE] Remove Tasks (JOHN)
- [DONE] Popup reminders background job (GLENN)
- Task stats/progress (ALESSIO)
- [DONE] Documentation (ALESSIO/CHRIS)
- [DONE] Program flow - guide through SMART Goal setting process, e.g. allow editing of goal description at the end of the process (JOHN/CHRIS)
- [DONE] Incorporate mail gem
- [DONE] UI/UX Improvements



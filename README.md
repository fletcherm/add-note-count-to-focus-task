# Description

As of 2018-01-12, this script updates my "Process TextExpander snippets" OmniFocus task with suggested snippets once a month.

(FYI - at one point, it automatically updated my `Process Evernote inbox` OmniFocus task with the number of unprocessed articles I have waiting in Evernote. No longer by the time I stopped using the script...)

## Required software

* OS X 10.11. It may also work on 10.10.
* Ruby 2.2.
* Bundler.

## How to use

1. Clone this repository.
1. `bundle install`
1. `bundle exec rake` - compiles the script, `launchd` configuration file, and prints installation instructions.
1. `bundle exec run` - runs the script.
1. `bundle exec help` or `bundle exec rake -T` for more information.

## Context
As of 2015, my personal choice for long-term archival of interesting articles & other documentation is Evernote. I keep these articles filed away using a variety of notebooks and tags.

My current workflow is :

1. Decide I want to archive an article that I'm reading on the web, in Instapaper, a blog post, etc.
2. I send it to Evernote. All articles go, by default, into the `inbox` notebook.
3. Every morning I have a set of routines I go through as OmniFocus recurring tasks. One of these is named `Process Evernote inbox`. This is my reminder "hey, dummy, go archive all of those new articles in Evernote!"
4. I bounce over to Evernote, go through each article, and send it to the appropriate notebook with the appropriate tags.

This script keeps my OmniFocus task up-to-date with the number of unprocessed articles. If I have none (which is common), I know I can immediately check that task as done and move along.

![My OmniFocus daily routine list](https://github.com/fletcherm/add-note-count-to-focus-task/blob/master/images/process-evernote.png)

# Todo
- [x] Create 'thereCanBeOnlyOne' function to assert we only find one folder, project, task, notebook.
- [x] Update Evernote notebook search to use whose function.
- [x] Wrap up into a class (for visuals and readability).
- [x] Automatically run every minute.
- [x] Write up a litte more in the README.md.
- [x] Write up a blog post.
- [ ] Copy the final artifact somewhere so I can work on this project without affecting the rest of the system.

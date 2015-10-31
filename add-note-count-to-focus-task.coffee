class UpdateReviewEvernoteTask
  countNotesInReviewNotebook = ->
    Evernote = Application('Evernote')

    notebooks = Evernote.notebooks.whose(name: 'review')
    if notebooks.length != 1
      names = (notebook.name() for notebook in notebooks).join()
      throw "Got more than one review notebook!
        That's not good, as Evernote enforces unique notebook names. There's probably something wrong with the name matcher.
        Matching notebook names were : [#{names}]."
    reviewNotebook = notebooks[0]

    reviewNotebook.notes.length

  updateReviewEvernoteTask = ({count}) ->
    OmniFocus = Application('OmniFocus')

    defaultDocument = OmniFocus.defaultDocument()
    routines = defaultDocument.flattenedFolders.whose(name: 'Routines')[0]
    daily = routines.flattenedProjects.whose(name: 'Daily')[0]

    reviewTaskBasename = 'Process Evernote review notebook'
    reviewTaskNameWithCount = "#{reviewTaskBasename} (#{count})"
    reviewTask = daily.flattenedTasks.whose(
      name: { _beginsWith: reviewTaskBasename }
      completed: false
    )[0]
    reviewTask.name = reviewTaskNameWithCount

  @run: ->
    updateReviewEvernoteTask(count: countNotesInReviewNotebook())

UpdateReviewEvernoteTask.run()

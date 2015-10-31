class UpdateReviewEvernoteTask
  _findByName: ({name, source, multipleResultsMessage}) ->
    @_findBy(
      source: source
      multipleResultsMessage: multipleResultsMessage
      query:
        name: name
    )

  _findBy: ({query, source, multipleResultsMessage}) ->
    results = source.whose(query)

    # October 31, 2015 MRF
    # These finders are intentionally brittle for now, as I want to start out with them
    # assuming my current folder, project, taskname structure. Consider loosening these
    # up in the future.
    if results.length != 1
      names = (result.name() for result in results).join()
      throw multipleResultsMessage(names)
    else
      results[0]

  _countNotesInReviewNotebook: ->
    Evernote = Application('Evernote')

    reviewNotebook = @_findByName(
      name: 'review'
      source: Evernote.notebooks
      multipleResultsMessage: (names) ->
        "Got more than one review notebook!
         That's not good, as Evernote enforces unique notebook names. There's probably something wrong with the name matcher.
         Matching notebook names were : [#{names}]."
    )

    reviewNotebook.notes.length

  _updateReviewEvernoteTask: ({count}) ->
    OmniFocus = Application('OmniFocus')

    routines = @_findByName(
      name: 'Routines'
      source: OmniFocus.defaultDocument().flattenedFolders
      multipleResultsMessage: (names) ->
        "Got more than one Routines folder! There should only be one.
         Matching folder names were : [#{names}]."
    )
    daily = @_findByName(
      name: 'Daily'
      source: routines.flattenedProjects
      multipleResultsMessage: (names) ->
        "Got more than one Daily project! There should only be one.
         Matching project names were : [#{names}]."
    )

    reviewTaskBasename = 'Process Evernote review notebook'
    reviewTask = @_findBy(
      query:
        completed: false
        name:
          _beginsWith: reviewTaskBasename
      source: daily.flattenedTasks
      multipleResultsMessage: (names) ->
        "Got more than one #{reviewTaskBasename} task! There should only be one.
         Matching task names were : [#{names}]."
    )

    reviewTask.name = "#{reviewTaskBasename} (#{count})"

  run: ->
    @_updateReviewEvernoteTask(count: @_countNotesInReviewNotebook())

new UpdateReviewEvernoteTask().run()

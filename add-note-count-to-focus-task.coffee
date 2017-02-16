class UpdateFocusTasks
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

  _countNotesInInbox: ->
    Evernote = Application('Evernote')

    inboxNotebook = @_findByName(
      name: 'inbox'
      source: Evernote.notebooks
      multipleResultsMessage: (names) ->
        "Got more than one inbox notebook!
         That's not good, as Evernote enforces unique notebook names. There's probably something wrong with the name matcher.
         Matching notebook names were : [#{names}]."
    )

    inboxNotebook.notes.length

  _findTextExpanderSnippetsForGroup: (group) ->
    TextExpander = Application('TextExpander')

    group = @_findByName(
      name: group
      source: TextExpander.groups
      multipleResultsMessage: (names) ->
        "Got more than one '#{group}' TextExpander group!
         Matching group names were : [#{names}]."
    )

    # November 16, 2015 MRF
    # In playing around with the TextExpander group, the way I'm accessing snippets didn't
    # seem quite right. This does appear to give the correct number but it may be by
    # coincidence. Please improve if it is necessary and you can.
    group.snippets

  _countTextExpanderSuggestions: ->
    @_findTextExpanderSnippetsForGroup('Suggested Snippets').length

  _contentForTextExpanderSuggestions: ->
    snippets = [].slice.call(@_findTextExpanderSnippetsForGroup('Suggested Snippets'))

    foo = snippets.map((snippet) ->
      snippet.name()
    ).map((name) ->
      "* #{name}"
    )
    foo.join('\n')

  _findOmniFocusTask: (taskBasename) ->
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

    @_findBy(
      query:
        completed: false
        name:
          _beginsWith: taskBasename
      source: daily.flattenedTasks
      multipleResultsMessage: (names) ->
        "Got more than one #{taskBasename} task! There should only be one.
         Matching task names were : [#{names}]."
    )

  _updateOmniFocusTaskTitle: ({taskBasename, content}) ->
    task = @_findOmniFocusTask(taskBasename)
    task.name = "#{taskBasename} (#{content})"

  _updateOmniFocusTaskNote: ({taskBasename, content}) ->
    task = @_findOmniFocusTask(taskBasename)
    task.note = content

  run: ->
    @_updateOmniFocusTaskTitle(
      taskBasename: 'Process TextExpander suggestions'
      content: @_countTextExpanderSuggestions()
    )
    @_updateOmniFocusTaskNote(
      taskBasename: 'Process TextExpander suggestions'
      content: @_contentForTextExpanderSuggestions()
    )
    # MRF 2016-03-31
    # In the process of migrating away from Evernote. Turning this off.
    # @_updateOmniFocusTask(
    #   taskBasename: 'Process Evernote inbox'
    #   count: @_countNotesInInbox()
    # )

new UpdateFocusTasks().run()

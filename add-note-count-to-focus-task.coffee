countReviewNotes = ->
  Evernote = Application('Evernote')

  notebooks = (notebook for notebook in Evernote.notebooks when notebook.name() is 'review')
  if notebooks.length != 1
    names = (notebook.name() for notebook in notebooks).join()
    throw "Got more than one review notebook!
      That's not good, as Evernote enforces unique notebook names. There's probably something wrong with the name matcher.
      Matching notebook names were : [#{names}]."
  reviewNotebook = notebooks[0]

  reviewNotebook.notes.length

console.log countReviewNotes()

import { EditorView, keymap } from "@codemirror/view";
import { Compartment, EditorState } from "@codemirror/state";
import { lineNumbers, highlightActiveLineGutter } from "@codemirror/gutter";
import { closeBrackets, closeBracketsKeymap } from "@codemirror/closebrackets";
import { oneDark } from "@codemirror/theme-one-dark";
import { indentOnInput } from "@codemirror/language";
import { history, historyKeymap } from "@codemirror/history";
import { defaultKeymap } from "@codemirror/commands";
import { languages } from "@codemirror/language-data";
import { LanguageDescription } from "@codemirror/language";
import EventEmitter from "events";

const buffers = {}
const events = new EventEmitter
const view = new EditorView({
  parent: document.body
})

const theme = EditorView.theme({
  "&": {
    fontSize: "12pt",
    backgroundColor: "#191925"
  },
  ".cm-gutters": {
    backgroundColor: "#191925"
  }
});

events.on('createBuffer', (data) => {
  if (buffers.hasOwnProperty(data.id)) return;

  let languageCompartment = new Compartment();

  buffers[data.id] = EditorState.create({
    extensions: [
      theme,
      lineNumbers(),
      highlightActiveLineGutter(),
      closeBrackets(),
      indentOnInput(),
      history(),
      oneDark,
      keymap.of([
        ...closeBracketsKeymap,
        ...historyKeymap,
        ...defaultKeymap
      ]),
      languageCompartment.of([]),
      EditorView.updateListener.of((update) => {
        if (update.docChanged) BufferContent.postMessage(JSON.stringify({
          id: currentId,
          content: view.state.doc.toString()
        }))
      })
    ]
  })

  LanguageDescription.matchFilename(languages, '.' + data.extension)?.load().then((language) => {
    let state = (currentId == data.id) ? view.state : buffers[data.id]
    let transaction = state.update({
      effects: languageCompartment.reconfigure(language)
    })
    if (currentId == data.id) {
      view.update([transaction])
    }
    buffers[data.id] = transaction.state
  });
})

events.on('deleteBuffer', (data) => delete buffers[data.id])

let currentId
events.on('switchBuffer', (data) => {
  if (!buffers.hasOwnProperty(data.id)) return;
  buffers[currentId] = view.state
  view.setState(buffers[data.id])
  currentId = data.id
})

events.on('updateBuffer', (data) => {
  if (!buffers.hasOwnProperty(data.id)) return;
  let state
  if (currentId == data.id) state = view.state
  else state = buffers[data.id]
  let transaction = state.update({
    changes: {
      from: 0,
      to: state.doc.length,
      insert: data.content
    }
  })
  buffers[data.id] = transaction.state
  if (currentId == data.id) {
    view.dispatch(transaction)
  }
})

document.body.style.margin = '0px'
document.querySelector('.cm-editor').style.height = '100vh'

globalThis.events = events
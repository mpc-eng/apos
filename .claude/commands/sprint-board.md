Launch the APOS Sprint Board — a visual, interactive sprint planning board.

Run the sprint board server in the background:

```
node tools/sprint-board/server.js
```

Then tell the user to open http://localhost:3333 in their browser.

If port 3333 is already in use, kill the existing process first with `kill $(lsof -ti:3333)` and restart.

This is a local-only tool. No data leaves the machine. The board reads from `apps/<slug>/app-state.json` and `apps/<slug>/action-queue.json`. Drag-and-drop saves directly to `app-state.json` (with `.bak` backup).

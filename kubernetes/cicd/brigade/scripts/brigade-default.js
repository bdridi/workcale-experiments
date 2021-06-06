// Generic Gateway example

const { events, Job } = require("brigadier");

events.on("simpleevent", (e, p) => {  // handler for a SimpleEvent
  var echo = new Job("echosimpleevent", "alpine:3.8");
  echo.tasks = [
    "echo Project " + p.name,
    "echo event type: $EVENT_TYPE",
    "echo payload " + JSON.stringify(e.payload)
  ];
  echo.env = {
    "EVENT_TYPE": e.type
  };
  echo.run();
});
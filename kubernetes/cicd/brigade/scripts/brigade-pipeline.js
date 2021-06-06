
const { events, Job, Group } = require("brigadier");

events.on("exec", (e, p) => {  
  var dest = '/mnt/brigade/share/hello.txt'
  var one = new Job("one", "alpine:3.8", ["echo Hello > " + dest]);
  var two = new Job("two", "alpine:3.8", ["echo Cloud-Native Foundation !  >> " + dest]);
  var three = new Job("three", "alpine:3.8", ["cat " + dest]);

  one.storage.enabled = true;
  two.storage.enabled = true;
  three.storage.enabled = true;

  Group.runEach([one, two, three])
});
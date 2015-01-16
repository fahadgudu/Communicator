 //
 // A class for keeping an on-screen counter going.  Methods init, stop, start, clear.
 //   sel: a jQuery selector for the HTML element
 //

 function CounterManager(sel, suffix) {

   var that = this;

   this.suffix = suffix;
   this.startTime = new Date();
   this.timer = null;

   function pad(val) {
     var valString = val + "";
     if (valString.length < 2) {
       return "0" + valString;
     }
     else {
       return valString;
     }
   }

   function updateDisplay() {
     var endTime = new Date();
     var timeDiff = endTime - that.startTime;
     var timeDiff = timeDiff/ 1000; // from ms to sec
     var seconds = Math.round(timeDiff % 60);
     var minutes = Math.floor( (timeDiff / 60) % 60);

     $(sel).html( pad(minutes) + ":" + pad(seconds) + that.suffix);
   }

   function run() {
     that.timer = setInterval(updateDisplay, 1000);
   }

   function stop(suffix) {
     that.suffix = suffix;
     updateDisplay();
     if (that.timer != null) {
       clearInterval(that.timer);
       that.timer = null;
     }
   }

   // start it
   run();

   // exports
   this.run = run;
   this.stop = stop;
 }


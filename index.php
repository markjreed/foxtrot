<?php
header('Content-Type: text/html');
?>
<html>
 <head>
  <title>Foxtrot Translations</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/comic-mono@0.0.1/index.css">
  <style>
   html * { font-family: sans-serif; }
   h1, p, form { margin-left: auto; margin-right: auto; text-align: center; }
   #comic { width: 900px; height: 296px; background-size:900px 296px;
            background-repeat:no-repeat;
            margin-left: auto; margin-right: auto; text-align: center;
            background-image: url(foxtrot_ccode.jpg);
            padding-left: 2; padding-top: 0 }
   #blackboard { width: 533px; height: 240px; max-height: 240px;
                 background-color: black;  word-wrap: break-word; overflow-y: scroll;
                 color: white; margin-left: 0; margin-top: 0;
                 scroll: auto; padding: 0; margin: 0; text-align: left }
   #blackboard pre { margin: 0; font-family: "dejavu sans mono", "comic mono", "comic sans ms", sans-serif;
                     font-size: 75%; padding-top: 0;}
   #blackboard::-webkit-scrollbar { height: 0px; width: 0px; }
   #programs::-webkit-scrollbar { -webkit-appearance: none; }
   #programs::-webkit-scrollbar:vertical { width: 11px; }
   #programs::-webkit-scrollbar-thumb  {
     border-radius: 8px;
     border: 2px solid white; /* should match background, can't be transparent */
     background-color: rgba(0, 0, 0, .5);
   }

   #programs::-webkit-scrollbar-track {
      background-color: #fff;
      border-radius: 8px;
   }
  </style>
 </head>
 <body>
  <h1>Foxtrot Translations</h1>
  <p>Version <?php include "version.txt"?></p>
  <div id="comic"><div id="blackboard"><pre id="code">#include &lt;stdio.h>
int main(void)
{
  int count;
  for(count=1;count&lt;=500;count++)
    printf("I will not throw paper airplanes in class.");
  return 0;
}</pre>
   </div>
  </div>

  <p>Transcribed blackboards in <a href="foxtrot_ccode.jpg">this picture</a> from alternate
   universes where Jason chose a language other than C (and also to
   output newlines).</p>

  <p>Select Language</p>
  <form>
   <select id="programs" size="15">
<?php
  $languages = json_decode(file_get_contents('languages.json'), true);
  $filenames = glob('solutions/[Pp]unishment_*');
  $programs = array();
  foreach ($filenames as $name) {
    list($a, $b) = explode('_', $name);
    list($sfx, $c) = explode('.', $b);
    $label = null;
    if (array_key_exists($sfx, $languages)) {
      $programs[$name] = $languages[$sfx];
    }
  }
  natcasesort($programs);
  foreach ($programs as $name => $label) {
    if ($label == "C") {
      $selected = ' selected';
    } else {
      $selected = '';
    }
    ?>

    <option<?=$selected?> value="<?=$name?>"><?= $label ?></option>
<?php } ?>
   </select>
   <input type="button" id="download" value="Download">
  </form>
 </body>
 <script>
   function load(filename) {
     var xhr = new XMLHttpRequest();
     var i;
     xhr.open("GET", filename);
     xhr.onreadystatechange = function() {
       if (xhr.readyState==4) {
         code.innerHTML =
            xhr.responseText.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')
       }
     }
     for (i=0; i<programs.options.length; ++i) {
       if (programs.options[i].value == filename) {
         programs.selectedIndex = i;
         window.location.hash = '#' + encodeURIComponent(programs.options[i].label)
         break;
       }
     }
     xhr.send(null);
   }
   var blackboard, code, programs;
   function loadCode() {
     load(programs.options[programs.selectedIndex].value)
     blackboard.scrollTop = 0;
   }
   var show = false;
   function scrollCode() {
     if (blackboard.scrollHeight > blackboard.clientHeight) {
        blackboard.scrollTop += 1;
     }
   }
   function initialize() {
     blackboard = document.getElementById("blackboard")
     programs = document.getElementById("programs")
     code = document.getElementById("code")
     var h, i, o, download = document.getElementById("download")
     download.onclick = function() {
       window.location = programs.options[programs.selectedIndex].value;
     }
     programs.onchange = loadCode
     setInterval(scrollCode,100);
     if (window.location.hash) {
       h = decodeURIComponent(window.location.hash.substring(1)).toLowerCase()
       for (i=0; i<programs.options.length; ++i) {
         o = programs.options[i]
         if (o.label.toLowerCase() == h ||
             o.value.toLowerCase() == "punishment_" + h + ".txt") {
           programs.selectedIndex = i;
           loadCode();
           break;
         }
       }
     }
   }

   window.onload = initialize;
 </script>
</html>

<?php
header('Content-Type: text/html');
?>
<html>
 <head>
  <title>Foxtrot Translations</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/comic-mono@0.0.1/index.css">
  <style>
   html * { font-family: sans-serif; }
   tt { font-family: fixed }
   div#captiondiv, div#versiondiv { width: 900px; margin-left: auto; margin-right: auto;
    text-align: center; }
   h1 { margin-left: auto; margin-right: auto; text-align: center; font-weight: bold; }
   input#download, { display: block; margin-left: auto; margin-right: auto; text-align: center; }
   form { display: block; float: left; width: 40% }
   div#bottom { width:900px; margin-left: auto; margin-right: auto; text-align: center; }
   div#notes { margin-top: 1em; float: right; width: 40%; border: solid 1px black; padding: 0.25in;
               vertical-align: bottom; overflow: scroll; height: 400px;}
   div#notes p { text-align: left }
   label, div#notes { vertical-align: top; }
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
  <div id="versiondiv"><p id="version">Version <?php include "version.txt"?></p></div>
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

  <div id="captiondiv"><p id="caption">Transcribed blackboards in <a href="foxtrot_ccode.jpg">this
  picture</a> from alternate universes where Jason chose a language other than
  C (and also to output newlines).</p></div>

  <div id="bottom">
  <form>
   <label for="programs">Select Language</label>
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
  <div id="notes"></div>
  </div>
 </body>
 <script>
   function load(element, filename, quote) {
     var xhr = new XMLHttpRequest();
     var i;
     xhr.open("GET", filename);
     xhr.onreadystatechange = function() {
       if (xhr.readyState==4) {
         let text = xhr.responseText
         if (quote) {
            text = text.replace(/&/g, '&amp;').
                        replace(/</g, '&lt;').
                        replace(/>/g, '&gt;').
                        replace(/"/g, '&quot;');
         }
         element.innerHTML = text;
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
   var blackboard, code, notes, programs;
   function loadCode() {
     const code_file = programs.options[programs.selectedIndex].value;
     load(code, code_file);
     const notes_file = code_file.replace(/solutions\/[Pp]unishment_(.*)\.txt/,
                                          'notes/notes_$1.html');
     load(notes, notes_file);
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
     notes = document.getElementById("notes")
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

#!/bin/bash
if ! type -p md5 >&/dev/null; then
  md5() {
    md5sum "$@" | awk '{print $1}'
  }
fi
let keep=0 verbose=0
if [[ "$1" == -v ]]; then
  let verbose=1
  exec 3>&2
  shift
fi
dir=/tmp/foxtrot$$
cd "$(dirname "$(type -p "$0")")"
mkdir -p "$dir"
(cd solutions && cp -r [Pp]unishment_*.txt Gemfile* .bundle vendor "$dir" >&/dev/null)
(cd tests && cp compile_*.sh run_*.sh "$dir" >&/dev/null)
cd "$dir"
IFS=$'\n' read -d '' -a languages < <(
    jq -r 'to_entries[]|.key+"\t"+.value' <~-/languages.json |
    sort -fk2,2 |
    if (( $# )); then
        grep -iwf <(printf '%s\n' "$@")
    else
        cat
    fi
)
for lang in "${languages[@]}"; do
  read ext name <<<"$lang"
  lext=$(tr A-Z a-z <<<"$ext")
  lname=$(tr A-Z a-z <<<"$name")
  f=$(ls | grep "[Pp]unishment_$ext.txt")
  old_f=$f
  f=${f%.txt}
  f=${f//_/.}
  mv "$old_f" "$f"
  lf="$(tr A-Z a-z <<<"$f")"
  old_f="$(tr A-Z a-z <<<"${lf%.$lext}_$lext.txt")"
  echo -n "$name:"
  if [ ! -r "$f" ]; then
    result='[33mSKIP[0m'
  else
    mkdir "$ext"
    mv "$f" "$ext"
    exec 3>&1
    keep=$(cd "$ext"
    result=
    compile=()
    run=()
    in=
    if [ -x "../compile_$ext.sh" ]; then
      compile=("../compile_$ext.sh" "$f" )
    fi
    if [ -x "../run_$ext.sh" ]; then
      run=("../run_$ext.sh" "$f" )
    else
      case "$ext" in
      (11l) run=(python -m11l "$f");;
      (4th) run=(4th cxq "$f");;
      (a68) run=(a68g "$f");;
      (adb) compile=(gnat make "$f"); run=("./${f%.$ext}");;
      (awk) run=(awk -f ./"$f");;
      (b) if ! type -p ybc >&/dev/null; then result='[33mSKIP[0m'; else compile=(bash -c "ybc -c "$PWD/$f"; clang -m32 $f.o /usr/local/opt/ybc/b-lib.o"); run=(./a.out); fi;;
      (bas) run=(basic "$f");;
      (bat) run=(4bat "$f");;
      (batsh) eval "$(opam env)";if ! type -p batsh >/dev/null; then result='[33mSKIP[0m'; else  compile=(bash -c "batsh bash '$f' >batsh.out"); run=(bash ./batsh.out); fi;;
      (bef) run=(bef -q "$f");;
      (bf) run=(bf); in="$f";;
      (c) compile=(gcc "$f" ); run=(./a.out);;
      (lisp) run=(clisp "$f");;
      (clj) run=(lein exec "$f");;
      (cob) compile=(cobc -x "$f"); run=("./${f%.$ext}");;
      (cpp) compile=(g++ "$f" ); run=(./a.out);;
      (cs) compile=(mcs "$f"); run=(mono "${f%.*}.exe");;
      (d) compile=(dmd "$f" ); run=("./${f%.$ext}");;
      (dc) run=(dc -f "$f");;
      (dylan) run=(rundylan "$f");;
      (elisp) run=(emacs --script "$f");;
      (elm) result='SKIP';;
      (erl) run=(escript "$f");;
      (exs) run=(elixir "$f");;
      (f) compile=(gfortran -std=legacy "$f" ); export GFORTRAN_UNBUFFERED_ALL=1; run=(./a.out);;
      ("><>") run=(python ~/bin/fish.py "$f");;
      (fr) compile=(fregec "$f" ); run=(frege Punishment);;
      (fsx) run=(dotnet fsi "$f");;
      (fth) run=(gforth "$f");;
      (go) run=(go run "$f");;
      (hs) . "$HOME/.ghcup/env"; run=(runhaskell "$f");;
      (hx) run=(haxe --main Punishment --interp);;
      (i) compile=(ick -b "$f"); run=("./${f%.$ext}");;
      (ico)  run=(icon "$f");;
      (ics) compile=(ics "$f"); run=(node "${f%.$ext}.mjs");;
      (idr) compile=(idris -o a.out "$f"); run=(./a.out);;
      (inf) compile=(inform "$f"); run=(dfrotz -mpq "${f%.$ext}.z5");;
      (j) run=(jconsole "$f");;
      (java) compile=(javac "$f"); run=(java Punishment);;
      (js) run=(node "$f");;
      (kt) compile=(kotlinc "$f"); run=(kotlin PunishmentKt);;
      (lasso) run=(lasso "$f");;
      (lol) run=(lci "$f");;
      (lsl) result='[33mSKIP[0m';;
      (m) compile=(clang -framework Foundation "$f"); run=(./a.out);;
      (mad) compile=(mad "$f"); run=(./"${f%.*}");;
      (mod) compile=(gm2 -fno-pth -flibs=log,pim "$f"); run=(./a.out);;
      (m3) compile=(cm3); run=(bash -c "./*/prog"); rm -f punishment.*;;
      (ml) run=(ocaml  "$f");;
      (nim) run=(nim --verbosity:0 --run compile "$f");;
      (occ) compile=(kroc "$f" -lcourse); run=(./punishment);;
      (octave) run=(octave -qf "$f");;
      (p) compile=(fpc "$f" ); run=("./${f%.$ext}");;
      (p4) run=(perl4 "$f");;
      (p5) run=(perl "$f");;
      (p5i) run=(perl5i "$f");;
      (raku) run=(raku "$f");;
      (pilot) compile=(mv "$f" "${f%.pilot}.p"); run=(pilot "${f%.pilot}.p");;
      (pl) run=(swipl -q -g main -l "$f");;
      (ps1) run=(pwsh "$f");;
      (py2) run=(python2 "$f");;
      (py3) run=(python3 "$f");;
      (pyth) export PYTHONPATH=$HOME/lib/pyth; run=(python ~/bin/pyth.py -c "$(<"$f")");;
      (q) run=(qore "$f");;
      (r)  run=(r -q --slave -f "$f");;
      (rb) run=(ruby "$f");;
      (reb) run=(rebol -q "$f");;
      (rkt) run=(racket "$f");;
      (rs) compile=(rustc "$f"); run=("./${f%.$ext}");;
      (sci) run=(scilab-cli -nb -f "$f" -quit);;
      (scm) run=(scheme --quiet --load "$f" --eval '(exit)');;
      (sed) run=(bash -c "sed -f '$f' <(echo)");;
      (semi) run=(semicolon "$f");;
      (sf) run=(sidef "$f");;
      (sim) compile=(cim "$f"); run=("./${f%.$ext}");;
      (sl) run=(slsh "$f");;
      (sml) compile=(mlton "$f"); run=("./${f%.$ext}");;
      (sno) run=(snobol4 "$f");;
      (spl) run=(splrun "$f");;
      (sq) run=(subleq "$f");;
      (st) run=(gst "$f");;
      (tcl) run=(tclsh "$f");;
      (ts) compile=(tsc "$f"); run=(node "${f%.$ext}.js");;
      (ua) run=(uiua run "$f");;
      (unl) run=(unlambda "$f");;
      (vala) compile=(valac "$f"); run=("./${f%.$ext}");;
      (vq) run=(varaq -s "$f");;
      (wren) run=(wren_cli "$f");;
      (yorick) run=(yorick -batch "$f");;
      (zig) run=(zig run "$f");;
      (🍇) compile=(emojicodec "$f"); run=("./${f%.$ext}");;
      (*) if type -t "$ext"  >/dev/null; then
           run=("$ext" "$f")
         else
           result='[33mSKIP[0m'
         fi;;
      esac
    fi
    if [ -z "$result" ]; then
      rm -f punishment a.out
      if (( ${#compile[@]} )); then
        if (( verbose )); then echo $'\n\t'"${compile[@]}" >&3; fi
        if type -p "${compile[0]}" >/dev/null 2>&1; then
          if "${compile[@]}" >/dev/null 2>&1; then
            :
          elif (( $? == 2 )); then
            result='[33mSKIP[0m'
          else
            result='[31mFAIL[0m'
            keep=1
          fi
        else
          result='[33mSKIP[0m'
        fi
      fi
      if [ -z "$result" ]; then
        if (( verbose )); then echo $'\t'"${run[@]}" >&3; fi
        if type -p "${run[0]}" >/dev/null 2>&1; then
          if [ -n "$in" ]; then
            "${run[@]}" <"$in"
          else
            "${run[@]}"
          fi
        else
          result='[33mSKIP[0m'
        fi >$ext.out1 2>$ext.err
        if (( $? == 2 )); then
          result='[33mSKIP[0m'
        else
          tr -d $'\r' <$ext.out1 | grep . >$ext.out
          if [ -z "$result" ]; then
            if [ "$(sed -e $'s/^[ \t]*//' -e $'s/[ \t]*$//' "$ext.out" | md5 | awk '{print $NF}')" == 6b1f79859ffd35ffe4930ce7d4a1848c ]; then
              result='[32mPASS[0m'
            else
              result='[31mFAIL[0m'
              keep=1
            fi
          fi
        fi
      fi
    fi
    echo "$result" >&3
    echo $keep)
  fi
done
if (( keep )); then
  echo "Files are in $dir"
else
  rm -rf "$dir"
fi

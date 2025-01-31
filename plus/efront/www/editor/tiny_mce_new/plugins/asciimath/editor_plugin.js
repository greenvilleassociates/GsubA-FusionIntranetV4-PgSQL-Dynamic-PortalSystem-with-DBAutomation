/**

 * ASCIIMath Plugin for TinyMCE editor

 *   port of ASCIIMath plugin for HTMLArea written by 

 *   David Lippman & Peter Jipsen

 *

 * @author David Lippman

 * @copyright Copyright � 2008 David Lippman.

 *

 * Plugin format based on code that is:

 * @copyright Copyright � 2004-2008, Moxiecode Systems AB, All rights reserved.

 */
(function() {
 // Load plugin specific language pack
 tinymce.PluginManager.requireLangPack('asciimath');
 tinymce.create('tinymce.plugins.AsciimathPlugin', {
  /**

		 * Initializes the plugin, this will be executed after the plugin has been created.

		 * This call is done before the editor instance has finished it's initialization so use the onInit event

		 * of the editor instance to intercept that event.

		 *

		 * @param {tinymce.Editor} ed Editor instance that the plugin is initialized in.

		 * @param {string} url Absolute URL to where the plugin is located.

		 */
  init : function(ed, url) {
   var t = this;
   // Register the command so that it can be invoked by using tinyMCE.activeEditor.execCommand('mceAsciimath');
   ed.addCommand('mceAsciimath', function(val) {
    if (t.lastAMnode==null) {
     existing = ed.selection.getContent();
     if (existing.indexOf('class=AM')==-1) { //existing does not contain an AM node, so turn it into one
            //strip out all existing html tags.
            existing = existing.replace(/<([^>]*)>/g,"");
            //replace entities like &lt; with lt.  Not perfect, but better than having
            //the whole entity in there
            existing = existing.replace(/&(.*?);/g,"$1");
            if (val) {
             existing = val;
            }
            entity = '<span class=AMedit>`'+existing+'<span id="removeme"></span>`</span> ';
            if (tinymce.isIE) ed.focus();
            ed.selection.setContent(entity);
            ed.selection.select(ed.dom.get('removeme'));
            ed.dom.remove('removeme');
            ed.selection.collapse(true);
            ed.nodeChanged();
      }
    } else if (val) {
     ed.selection.setContent(val);
    }
   });
   ed.addCommand('mceAsciimathDlg', function() {
    if (typeof AMTcgiloc == 'undefined') {
     AMTcgiloc = "";
    }
    ed.windowManager.open({
     file : url + '/amcharmap.htm',
     width : 630 + parseInt(ed.getLang('asciimathdlg.delta_width', 0)),
     height : 390 + parseInt(ed.getLang('asciimathdlg.delta_height', 0)),
     inline : 1
    }, {
     plugin_url : url, // Plugin absolute URL
     AMTcgiloc : AMTcgiloc
    });
   });
   ed.onKeyDown.add(function(ed, ev) {
    var keycode = ev.keyCode;
    if (keycode==36) { //HOME key
     e = ed.selection.getNode();
     if (t.testAMclass(e)) {
      p = e;
     } else {
      p = ed.dom.getParent(e,t.testAMclass);
     }
     if (p!=null) {
      var par = p.parentNode;
      var el = ed.dom.create("span", {id:'removeme'});
      el.innerText = " ";
      par.insertBefore(el, p);
      ed.nodeChanged();
     }
    }
   });
   ed.onKeyUp.add(function(ed, ev) {
    var keycode = ev.keyCode;
    if (keycode == 36) { //HOME key
     ed.dom.remove('removeme');
    }
   });
   ed.onKeyPress.add(function(ed, ev) {
    var keycode = ev.charCode || ev.keyCode;
    var key = String.fromCharCode(keycode);
    if (key=='`') {
     if (t.lastAMnode == null) {
      existing = ed.selection.getContent();
      if (existing.indexOf('class=AM')==-1) { //existing does not contain an AM node, so turn it into one
             //strip out all existing html tags.
             existing = existing.replace(/<([^>]*)>/g,"");
             entity = '<span class=AMedit>`'+existing+'<span id="removeme"></span>`</span> ';
             if (tinymce.isIE) ed.focus();
             ed.selection.setContent(entity);

             ed.selection.select(ed.dom.get('removeme'));
             ed.dom.remove('removeme');

             ed.nodeChanged();

       }
     }
     if (ev.stopPropagation) {
      ev.stopPropagation();
      ev.preventDefault();
           } else {
      ev.cancelBubble = true;
      ev.returnValue = false;
           }
    }
   });

   // Register asciimath button
   ed.addButton('asciimath', {
    title : 'asciimath.desc',
    cmd : 'mceAsciimath',
    image : url + '/img/ed_mathformula2.gif'
   });

   ed.addButton('asciimathcharmap', {
    title : 'asciimathcharmap.desc',
    cmd : 'mceAsciimathDlg',
    image : url + '/img/ed_mathformula.gif'
   });
   /*

			ed.onInit.add(function(ed) {

					AMtags = ed.dom.select('span.AM');

					for (var i=0; i<AMtags.length; i++) {

						t.nodeToAM(AMtags[i]);

					}

			});

			*/
   ed.onPreInit.add(function(ed) {
    if (tinymce.isIE) {
     addhtml = "<object id=\"mathplayer\" classid=\"clsid:32F66A20-7614-11D4-BD11-00104BD3F987\"></object>";
     addhtml +="<?import namespace=\"m\" implementation=\"#mathplayer\"?>";
     ed.dom.doc.getElementsByTagName("head")[0].insertAdjacentHTML("beforeEnd",addhtml);
    }
   });
   ed.onPreProcess.add(function(ed,o) {
    if (o.get) {
     AMtags = ed.dom.select('span.AM', o.node);
     for (var i=0; i<AMtags.length; i++) {
      t.math2ascii(AMtags[i]);
     }
    }
   });
   ed.onSetContent.add(function(ed,o) {
     AMtags = ed.dom.select('span.AM');
     for (var i=0; i<AMtags.length; i++) {
      t.nodeToAM(AMtags[i]);
     }
   });
   ed.onBeforeExecCommand.add(function(ed,cmd) {
    if (cmd != 'mceAsciimath' && cmd != 'mceAsciimathDlg') {
     AMtags = ed.dom.select('span.AM');
     for (var i=0; i<AMtags.length; i++) {
      t.math2ascii(AMtags[i]);
      AMtags[i].className = "AMedit";
     }
    }
   });
   ed.onExecCommand.add(function(ed,cmd) {
    if (cmd != 'mceAsciimath' && cmd != 'mceAsciimathDlg') {
     AMtags = ed.dom.select('span.AMedit');
     for (var i=0; i<AMtags.length; i++) {
      t.nodeToAM(AMtags[i]);
      AMtags[i].className = "AM";
     }
    }
   });

   ed.onNodeChange.add(function(ed, cm, e) {
    var doprocessnode = true;
    if (t.testAMclass(e)) {
     p = e;
    } else {
     p = ed.dom.getParent(e,t.testAMclass);
    }
    cm.setDisabled('charmap', p!=null);
    cm.setDisabled('sub', p!=null);
    cm.setDisabled('sup', p!=null);
    if (p != null) {
     if (t.lastAMnode == p) {
      doprocessnode = false;
     } else {
      t.math2ascii(p);
      p.className = 'AMedit';
      if (t.lastAMnode != null) {
       t.nodeToAM(t.lastAMnode);
       t.lastAMnode.className = 'AM'
      }
      t.lastAMnode = p;
      doprocessnode = false;
     }
    }
    if (doprocessnode && (t.lastAMnode != null)) { //if not in AM node, process last
         if (t.lastAMnode.innerHTML.match(/`(&nbsp;|\s|\u00a0|&#160;)*`/) || t.lastAMnode.innerHTML.match(/^(&nbsp;|\s|\u00a0|&#160;)*$/)) {
          p = t.lastAMnode.parentNode;
          p.removeChild(t.lastAMnode);
         } else {
          t.nodeToAM(t.lastAMnode);
          t.lastAMnode.className = 'AM';
         }
         t.lastAMnode = null;
          }

   });
   ed.onDeactivate.add(function(ed) {
    if (t.lastAMnode != null) {
         if (t.lastAMnode.innerHTML.match(/`(&nbsp;|\s)*`/)|| t.lastAMnode.innerHTML.match(/^(&nbsp;|\s|\u00a0|&#160;)*$/)) {
          p = t.lastAMnode.parentNode;
          p.removeChild(t.lastAMnode);
         } else {
          t.nodeToAM(t.lastAMnode);
          t.lastAMnode.className = 'AM';
         }
         t.lastAMnode = null;
    }
   });
  },

  /**

		 * Returns information about the plugin as a name/value array.

		 * The current keys are longname, author, authorurl, infourl and version.

		 *

		 * @return {Object} Name/value array containing information about the plugin.

		 */
  getInfo : function() {
   return {
    longname : 'Asciimath plugin',
    author : 'David Lippman',
    authorurl : 'http://www.pierce.ctc.edu/dlippman',
    infourl : '',
    version : "1.0"
   };
  },
  math2ascii : function(el) {
   var myAM = el.innerHTML;
   if (myAM.indexOf("`") == -1) {
    myAM = myAM.replace(/.+(alt|title)=\"(.*?)\".+/g,"`$2`");
    myAM = myAM.replace(/.+(alt|title)=\'(.*?)\'.+/g,"`$2`");
    myAM = myAM.replace(/.+(alt|title)=([^>]*?)\s.*>.*/g,"`$2`");
    myAM = myAM.replace(/.+(alt|title)=(.*?)>.*/g,"`$2`");
    //myAM = myAM.replace(/&gt;/g,">");
    //myAM = myAM.replace(/&lt;/g,"<");
    myAM = myAM.replace(/>/g,"&gt;");
    myAM = myAM.replace(/</g,"&lt;");
    el.innerHTML = myAM;
   }
  },
  nodeToAM : function(outnode) {
    if (tinymce.isIE) {
      var str = outnode.innerHTML.replace(/\`/g,"");
      str.replace(/\"/,"&quot;");
       var newAM = document.createElement("span");
      if (AMnoMathML) {
       newAM.appendChild(AMTparseMath(str));
      } else {
       newAM.appendChild(AMparseMath(str));
      }
      outnode.innerHTML = newAM.innerHTML;
     } else {
      //doesn't work on IE, probably because this script is in the parent
      //windows, and the node is in the iframe.  Should it work in Moz?
     var myAM = outnode.innerHTML; //next 2 lines needed to make caret
     outnode.innerHTML =myAM; //move between `` on Firefox insert math
     AMprocessNode(outnode);
     }
  },
  lastAMnode : null,
  preventAMrender : false,
  testAMclass : function(el) {
   if ((el.className == 'AM') || (el.className == 'AMedit')) {
    return true;
   } else {
    return false;
   }
  }
 });

 // Register plugin
 tinymce.PluginManager.add('asciimath', tinymce.plugins.AsciimathPlugin);
})();

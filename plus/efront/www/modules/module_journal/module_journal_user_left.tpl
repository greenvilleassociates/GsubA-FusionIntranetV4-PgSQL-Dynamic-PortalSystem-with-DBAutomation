{* Smarty Template for Journal Module (Student/Professor) - Hide right page *}

{if isset($smarty.get.print)}

{capture name = 't_print_code'}

<table class="contentArea">
 <tr>
  <td id="centerColumn">
   <p style="text-align:center">
    <input class="flatButton" type="submit" onClick="window.print();" value="{$smarty.const._PRINTIT}"/>
   </p>
  </td>
 </tr>
{foreach name = 'entries_loop' key = "id" item = "entry" from = $T_JOURNAL_ENTRIES}
 <tr>
  <td>{$entry.entry_date_formatted}</td>
 </tr>
 <tr>
  <td>{$entry.entry_body}</td>
 </tr>
 <tr>
  <td><div class="print_separator"></div></td>
 </tr>
{/foreach}
</table>

{/capture}
{eF_template_printBlock title=$smarty.const._JOURNAL_NAME data=$smarty.capture.t_print_code image=$T_JOURNAL_BASELINK|cat:'images/journal_logo.png' absoluteImagePath = 1}

{elseif isset($smarty.get.rules)}

{capture name = 't_rules_code'}

<table class="contentArea">
{foreach name = 'rules_loop' key = "id" item = "rule" from = $T_JOURNAL_ACTIVE_RULES}
 <tr>
  <td><div class="rule_title">{$rule.title}</div></td>
 </tr>
 <tr>
  <td><div class="rule_description">{$rule.description}</div></td>
 </tr>
{foreachelse}
 <tr>
  <td><p style="text-align:center">{$smarty.const._JOURNAL_NO_RULES_FOUND}</p></td>
 </tr>
{/foreach}
</table>

{/capture}
{eF_template_printBlock title=$smarty.const._JOURNAL_NAME data=$smarty.capture.t_rules_code image=$T_JOURNAL_BASELINK|cat:'images/journal_logo.png' absoluteImagePath = 1}

{elseif isset($smarty.get.popup_info)}

{capture name = 't_popup_info'}

<table class="contentArea">
 <tr>
  <td>{$smarty.const._JOURNAL_HOW_TO_OPEN_POPUP1}</td>
 </tr>
 <tr>
  <td>&nbsp;</td>
 </tr>
 <tr>
  <td>{$smarty.const._JOURNAL_HOW_TO_OPEN_POPUP2}</td>
 </tr>
 <tr>
  <td>
   <pre>&lt;a href="javascript:void(0);" onclick="openPopup('student.php?ctg=module&amp;op=module_journal&amp;popup=1&amp;journal_popup=1');"&gt;&lt;img src="{$T_JOURNAL_BASELINK|cat:'images/popup.png'}" alt="{$smarty.const._JOURNAL_OPEN_POPUP}" title="{$smarty.const._JOURNAL_OPEN_POPUP}" style="border:0px;" /&gt;&lt;/a&gt;</pre>
  </td>
 </tr>
 <tr>
  <td>{$smarty.const._JOURNAL_HOW_TO_OPEN_POPUP4}</td>
 </tr>
 <tr>
  <td>
   <pre>&lt;a href="javascript:void(0);" onclick="openPopup('professor.php?ctg=module&amp;op=module_journal&amp;popup=1&amp;journal_popup=1');"&gt;&lt;img src="{$T_JOURNAL_BASELINK|cat:'images/popup.png'}" alt="{$smarty.const._JOURNAL_OPEN_POPUP}" title="{$smarty.const._JOURNAL_OPEN_POPUP}" style="border:0px;" /&gt;&lt;/a&gt;</pre>
  </td>
 </tr>
 <tr>
  <td>{$smarty.const._JOURNAL_HOW_TO_OPEN_POPUP3}</td>
 </tr>
 <tr>
  <td>
   <div id="copy_js">{$smarty.const._JOURNAL_COPY_TO_CLIPBOARD}</div>
   <pre id="js_code">
&#60;script&#62;
 function openPopup(url)&#123;

  var width = 710;
  var height = 590;
  var left = (screen.width - width) / 2;
  var top = (screen.height - height) / 2;

  var params = 'width=' + width + ', height=' + height;
  params += ', top=' + top + ', left=' + left;
  params += ', directories=no';
  params += ', location=no';
  params += ', menubar=no';
  params += ', resizable=yes';
  params += ', scrollbars=yes';
  params += ', status=yes';
  params += ', toolbar=no';

  popupWindow = window.open(url, 'journal_popup', params);

  if(window.focus)
   popupWindow.focus()

  return false;
 &#125;
&#60;/script&#62;
   </pre>
  </td>
 </tr>
</table>

<script src="{$T_JOURNAL_BASELINK}scripts/ZeroClipboard.js"></script>
<script>
{literal}
 ZeroClipboard.setMoviePath('{/literal}{$T_JOURNAL_BASELINK}{literal}scripts/ZeroClipboard.swf');
 var clip = new ZeroClipboard.Client();
 clip.setText('');

 clip.addEventListener('mouseDown', function(){
  var pre = document.getElementById('js_code');
  var html = pre.innerHTML;
  html = html.replace(/&lt;/g, '<');
  html = html.replace(/&gt;/g, '>');
  clip.setText(html);
 });

 clip.glue('copy_js');
{/literal}
</script>

{/capture}
{eF_template_printBlock title=$smarty.const._JOURNAL_NAME data=$smarty.capture.t_popup_info image=$T_JOURNAL_BASELINK|cat:'images/journal_logo.png' absoluteImagePath = 1}

{elseif isset($smarty.get.check_students_journals)}

{capture name = 't_check_students_journals_info'}

<table class="sortedTable" style="width:100%">
 <tr>
  <td class="topTitle">{$smarty.const._JOURNAL_STUDENT_NAME}</td>
  <td class="topTitle centerAlign noSort">{$smarty.const._PREVIEW}</td>
 </tr>
{foreach name = "students_loop" key = "login" item = "student" from = $T_JOURNAL_STUDENTS}
 <tr id="row_{$student.login}" class="{cycle values = "oddRowColor, evenRowColor"}">
  <td>#filter:login-{$student.login}#</td>
  <td class="centerAlign"><a href="{$T_JOURNAL_BASEURL}&preview_journal=1&student={$student.login}&popup=1" onclick="eF_js_showDivPopup('{$smarty.const._PREVIEW}', 3)" target="POPUP_FRAME"><img src="{$T_JOURNAL_BASELINK|cat:'images/info.png'}" alt="{$smarty.const._PREVIEW}" title="{$smarty.const._PREVIEW}" style="vertical-align:middle" /></a></td>
 </tr>
{foreachelse}
 <tr class="defaultRowHeight oddRowColor">
  <td class="emptyCategory" colspan="100%">{$smarty.const._JOURNAL_NO_STUDENTS_FOUND}</td>
 </tr>
{/foreach}
</table>

{/capture}
{eF_template_printBlock title=$smarty.const._JOURNAL_NAME data=$smarty.capture.t_check_students_journals_info image=$T_JOURNAL_BASELINK|cat:'images/journal_logo.png' absoluteImagePath = 1}

{elseif isset($smarty.get.preview_journal)}

{capture name = 't_preview_journal_code'}

<table class="contentArea">
{foreach name = 'entries_loop' key = "id" item = "entry" from = $T_JOURNAL_STUDENT_ENTRIES}
 <tr>
  <td>{$entry.entry_date_formatted} ({$entry.lesson})</td>
 </tr>
 <tr>
  <td>{$entry.entry_body}</td>
 </tr>
 <tr>
  <td><div class="print_separator"></div></td>
 </tr>
{foreachelse}
<img src="{$T_JOURNAL_BASELINK|cat:'images/warning.png'}" alt="{$smarty.const._JOURNAL_NO_ENTRIES_FOUND}" title="{$smarty.const._JOURNAL_NO_ENTRIES_FOUND}" style="vertical-align:middle" />&nbsp;<div style="display: inline; font-style: italic;">{$smarty.const._JOURNAL_NO_ENTRIES_FOUND}</div>
{/foreach}
</table>

{/capture}
{eF_template_printBlock title=$smarty.const._JOURNAL_NAME data=$smarty.capture.t_preview_journal_code image=$T_JOURNAL_BASELINK|cat:'images/journal_logo.png' absoluteImagePath = 1}

{else}
{capture name = 't_journal_student_code'}

<table>
 <tr>
  <td>
   <img src="{$T_JOURNAL_BASELINK|cat:'images/change_dimensions.png'}" alt="{$smarty.const._JOURNAL_CHANGE_DIMENSIONS}" title="{$smarty.const._JOURNAL_CHANGE_DIMENSIONS}" style="vertical-align:middle" />&nbsp;{$smarty.const._JOURNAL_CHANGE_DIMENSIONS}
   <select id="journal_dimensions" name="journal_dimensions" onchange="location='{$T_JOURNAL_BASEURL}&dimension='+Element.extend(this).options[this.options.selectedIndex].value{if $T_POPUP_MODE == true}+'&popup=1'{/if}; resizePopupWindow(Element.extend(this).options[this.options.selectedIndex].value);">
    <option value="small" {if $T_JOURNAL_DIMENSIONS == 'small'}selected="selected"{/if}>{$smarty.const._JOURNAL_SMALL_DIMENSION}</option>
    <option value="medium" {if $T_JOURNAL_DIMENSIONS == 'medium'}selected="selected"{/if}>{$smarty.const._JOURNAL_MEDIUM_DIMENSION}</option>
    <option value="large" {if $T_JOURNAL_DIMENSIONS == 'large'}selected="selected"{/if}>{$smarty.const._JOURNAL_LARGE_DIMENSION}</option>
   </select>
{if $smarty.session.s_type == "professor" && $T_JOURNAL_ALLOW_PROFESSOR_PREVIEW == 1}
   &nbsp;<div class="options_separator"></div>
   <img src="{$T_JOURNAL_BASELINK|cat:'images/analysis.png'}" alt="{$smarty.const._JOURNAL_STUDENTS_JOURNAL}" title="{$smarty.const._JOURNAL_STUDENTS_JOURNAL}" style="vertical-align:middle" />&nbsp;<a href="{$T_JOURNAL_BASEURL}&check_students_journals=1">{$smarty.const._JOURNAL_STUDENTS_JOURNAL}</a>
{/if}
{if $T_POPUP_MODE == false}
   &nbsp;<div class="options_separator"></div>&nbsp;
   <img src="{$T_JOURNAL_BASELINK|cat:'images/popup.png'}" alt="{$smarty.const._JOURNAL_OPEN_POPUP}" title="{$smarty.const._JOURNAL_OPEN_POPUP}" style="vertical-align:middle" />&nbsp;<a href="javascript:void(0);" onclick="openPopup('{$T_JOURNAL_BASEURL}&popup=1&journal_popup=1');">{$smarty.const._JOURNAL_OPEN_POPUP}</a>
{/if}
  </td>
 </tr>
 <tr>
  <td>
   <div class="separator"></div>
   <div id="journal_{$T_JOURNAL_DIMENSIONS}">
    <div id="left_{$T_JOURNAL_DIMENSIONS}">
     <div id="editor_{$T_JOURNAL_DIMENSIONS}">
      {$T_JOURNAL_ADD_ENTRY_FORM.javascript}
      <form {$T_JOURNAL_ADD_ENTRY_FORM.attributes}>
       {$T_JOURNAL_ADD_ENTRY_FORM.hidden}
              <table class="formElements">
        <tr>
         <td class="elementCell">{$T_JOURNAL_ADD_ENTRY_FORM.entry_body.html}</td>
        </tr>
        <tr>
         <td class="submitCell">{$T_JOURNAL_ADD_ENTRY_FORM.submit.html}</td>
        </tr>
       </table>
      </form>
     </div>
    </div>
    <div id="right_{$T_JOURNAL_DIMENSIONS}">
     <div id="right_show_hide_{$T_JOURNAL_DIMENSIONS}">
      <a href="javascript:void(0);" onclick="showRight()"><img src="{$T_JOURNAL_BASELINK|cat:'images/show.png'}" alt="{$smarty.const._JOURNAL_SHOW_PAGE}" title="{$smarty.const._JOURNAL_SHOW_PAGE}" style="vertical-align:middle; border: 0px;" /></a>
     </div>
    </div>
   </div>
  </td>
 </tr>
</table>

{/capture}

{if $smarty.session.s_type == "professor"}
{eF_template_printBlock title=$smarty.const._JOURNAL_NAME data=$smarty.capture.t_journal_student_code image=$T_JOURNAL_BASELINK|cat:'images/journal_logo.png' absoluteImagePath = 1 options=$T_JOURNAL_POPUP_INFO}
{else}
{eF_template_printBlock title=$smarty.const._JOURNAL_NAME data=$smarty.capture.t_journal_student_code image=$T_JOURNAL_BASELINK|cat:'images/journal_logo.png' absoluteImagePath = 1}
{/if}

<script>
{literal}
 setInterval('autoSave()', 60000);
{/literal}
</script>

<script>
{literal}

 function autoSave(){

  {/literal}{if isset($smarty.get.edit_entry)}{assign var='edit_entry' value=$smarty.get.edit_entry}{else}{assign var='edit_entry' value='-1'}{/if}{literal}
  var edit_entry = {/literal}{$edit_entry}{literal};
  var entry_body = tinyMCE.get('entry_body').getContent();
  var url = '{/literal}{$T_JOURNAL_BASEURL}{literal}&autosave=1&entry_body=' + encodeURIComponent(entry_body) + '&edit_entry=' + edit_entry;

  if(entry_body != ''){

   new Ajax.Request(url, {
    method: 'post',
    asynchronous: true,
    onFailure: function(transport){
     alert(decodeURIComponent(transport.responseText));
    },
    onSuccess: function(transport){
    }
   });
  }
 }

 function openPopup(url){

  {/literal}{if isset($T_JOURNAL_DIMENSIONS)}{assign var='journal_dimension' value=$T_JOURNAL_DIMENSIONS}{else}{assign var='journal_dimension' value=-1}{/if}{literal}
  var journal_dimension = '{/literal}{$journal_dimension}{literal}';

  var width = 710;
  var height = 590;

  if(journal_dimension == 'small'){
   width = 710;
   height = 590;
  }
  else if(journal_dimension == 'medium'){
   width = 810;
   height = 660;
  }
  else if(journal_dimension == 'large'){
   width = 925;
   height = 730;
  }

  var left = (screen.width - width) / 2;
  var top = (screen.height - height) / 2;

  var params = 'width=' + width + ', height=' + height;
  params += ', top=' + top + ', left=' + left;
  params += ', directories=no';
  params += ', location=no';
  params += ', menubar=no';
  params += ', resizable=yes';
  params += ', scrollbars=yes';
  params += ', status=yes';
  params += ', toolbar=no';

  popupWindow = window.open(url, 'journal_popup', params);

  if(window.focus)
   popupWindow.focus()

  return false;
 }

 function resizePopupWindow(dimension){

  {/literal}{if $T_POPUP_MODE == true}{assign var='popup_mode' value='1'}{else}{assign var='popup_mode' value='0'}{/if}{literal}
  var popup_mode = {/literal}{$popup_mode}{literal};

  var width, height, left, top;

  if(popup_mode == '1'){

   if(dimension == 'small'){
    width = 730;
    height = 680;
   }
   else if(dimension == 'medium'){
    width = 830;
    height = 750;
   }
   else if(dimension == 'large'){
    width = 945;
    height = 750;
   }

   left = (screen.width - width) / 2;
   top = (screen.height - height) / 2;

   window.resizeTo(width, height);
   window.moveTo(left, top);
  }
 }

 function showRight(){

  {/literal}{if isset($smarty.get.edit_entry)}{assign var='edit_entry' value=$smarty.get.edit_entry}{else}{assign var='edit_entry' value='-1'}{/if}{literal}
  {/literal}{if $T_POPUP_MODE == true}{assign var='popup_mode' value='1'}{else}{assign var='popup_mode' value='0'}{/if}{literal}
  var edit_entry = {/literal}{$edit_entry}{literal};
  var popup_mode = {/literal}{$popup_mode}{literal};
  var entry_body = tinyMCE.get('entry_body').getContent();
  var url = '{/literal}{$T_JOURNAL_BASEURL}{literal}&show_right=1&entry_body=' + encodeURIComponent(entry_body) + '&edit=' + edit_entry + '&edit_entry=' + edit_entry;

  if(popup_mode == '1')
   url += '&popup=1';

  new Ajax.Request(url, {
   method: 'post',
   asynchronous: true,
   onFailure: function(transport){
    alert(decodeURIComponent(transport.responseText));
   },
   onSuccess: function(transport){
    location = url;
   }
  });
 }

{/literal}
</script>

{/if}

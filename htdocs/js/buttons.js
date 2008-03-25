function gbTurnOff (a) {
  if (document.getElementById(a+"_a")) { document.getElementById(a+"_a").checked='' };
  if (document.getElementById(a+"_n")) { document.getElementById(a+"_n").checked='' };
}

function gbCheck (button,state) {
  var a         = button.id;
  a             = a.substring(0,a.lastIndexOf("_"));
  var container = document.getElementById(a);
  if (!container) { return false; }
  var checkboxes = container.getElementsByTagName('input');
  if (!checkboxes) { return false; }
  for (var i=0; i<checkboxes.length; i++) {
     checkboxes[i].checked=state;
  }
  gbTurnOff(a);
  button.checked="on";
  return false;
}

function gbToggleTrack (button) {
  var track_name = button.value;
  var visible    = button.checked;
  var element    = document.getElementById("track_"+track_name);
  if (!element) { return false }
  if (visible) {
    element.style.display="block";
  } else {
    element.style.display="none";
  }
}

function create_drag (div_name,div_part) {
  Sortable.create(
		  div_name,
		  {
		  constraint: 'vertical',
		      tag: 'div',
		      only: div_part,
		      handle: 'titlebar',
		      onUpdate: function() {
		      var postData = Sortable.serialize(div_name,{name:'label'});
		      new Ajax.Request(document.URL,{method:'post',postBody:postData});
		    }
		  }
		  );
}

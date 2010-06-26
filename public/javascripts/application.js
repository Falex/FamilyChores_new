// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


jQuery.ajaxSetup({ 'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} })
02	 
03	function _ajax_request(url, data, callback, type, method) {
04	    if (jQuery.isFunction(data)) {
05	        callback = data;
06	        data = {};
07	    }
08	    return jQuery.ajax({
09	        type: method,
10	        url: url,
11	        data: data,
12	        success: callback,
13	        dataType: type
14	        });
15	}
16	 
17	jQuery.extend({
18	    put: function(url, data, callback, type) {
19	        return _ajax_request(url, data, callback, type, 'PUT');
20	    },
21	    delete_: function(url, data, callback, type) {
22	        return _ajax_request(url, data, callback, type, 'DELETE');
23	    }
24	});
25	 
26	jQuery.fn.submitWithAjax = function() {
27	  this.unbind('submit', false);
28	  this.submit(function() {
29	    $.post(this.action, $(this).serialize(), null, "script");
30	    return false;
31	  })
32	 
33	  return this;
34	};
35	 
36	//Send data via get if <acronym title="JavaScript">JS</acronym> enabled
37	jQuery.fn.getWithAjax = function() {
38	  this.unbind('click', false);
39	  this.click(function() {
40	    $.get($(this).attr("href"), $(this).serialize(), null, "script");
41	    return false;
42	  })
43	  return this;
44	};
45	 
46	//Send data via Post if <acronym title="JavaScript">JS</acronym> enabled
47	jQuery.fn.postWithAjax = function() {
48	  this.unbind('click', false);
49	  this.click(function() {
50	    $.post($(this).attr("href"), $(this).serialize(), null, "script");
51	    return false;
52	  })
53	  return this;
54	};
55	 
56	jQuery.fn.putWithAjax = function() {
57	  this.unbind('click', false);
58	  this.click(function() {
59	    $.put($(this).attr("href"), $(this).serialize(), null, "script");
60	    return false;
61	  })
62	  return this;
63	};
64	 
65	jQuery.fn.deleteWithAjax = function() {
66	  this.removeAttr('onclick');
67	  this.unbind('click', false);
68	  this.click(function() {
69	    $.delete_($(this).attr("href"), $(this).serialize(), null, "script");
70	    return false;
71	  })
72	  return this;
73	};
74	 
75	//This will "ajaxify" the links
76	function ajaxLinks(){
77	    $('.ajaxForm').submitWithAjax();
78	    $('a.get').getWithAjax();
79	    $('a.post').postWithAjax();
80	    $('a.put').putWithAjax();
81	    $('a.delete').deleteWithAjax();
82	}
83	 
84	$(document).ready(function() {
85	
86	// All non-GET requests will add the authenticity token
87	  // if not already present in the data packet
88	 $(document).ajaxSend(function(event, request, settings) {
89	       if (typeof(window.AUTH_TOKEN) == "undefined") return;
90	       // <acronym title="Internet Explorer 6">IE6</acronym> fix for http://dev.jquery.com/ticket/3155
91	       if (settings.type == 'GET' || settings.type == 'get') return;
92	 
93	       settings.data = settings.data || "";
94	       settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
95	     });
96	 
97	  ajaxLinks();
98	});
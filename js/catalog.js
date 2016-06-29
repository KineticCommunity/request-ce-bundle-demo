/**
 * Forms Search using Twitter Typeahead. Prefetch all accessible forms
 * for the Kapp.
**/
(function($, _, moment){
    var locale = window.navigator.userLanguage || window.navigator.language;
    moment.locale(locale);

    $(function(){

      if (!$('.navbar-form .typeahead').length){
        return;
      }
      var matcher = function(strs) {
        return function findMatches(query, callback) {
            var matches, substringRegex;
            matches = [];
            substrRegex = new RegExp(query, 'i');
            $.each(strs, function(i, str) {
              if (substrRegex.test(str)) {
                matches.push(str);
              }
            });
            callback(matches);
        };
      };
      var formNames = [];
      var forms = {};
      $.get(window.bundle.apiLocation() + "/kapps/" + window.bundle.kappSlug() + "/forms", function( data ) {
        forms = data.forms;
        $.each(forms, function(i,val) {
          formNames.push(val.name);
          forms[val.name] = val;
        });
      });
      $('.navbar-form .typeahead').typeahead({
          highlight:true
        },{
          name: 'forms',
          source: matcher(formNames),
        }).bind('typeahead:select', function(ev, suggestion) {
          window.location.replace(window.bundle.kappLocation() + "/" + forms[suggestion].slug)
      });

    });

    /**
     * Sidebar category active states (opening parents for subparents)
     * Open parent category page when it contains forms
     **/
    $(function(){
        $('ul.treeview-menu li.active').parents('li').addClass('active');

        $('section.sidebar ul li').on('click', function(e){
            console.log($(this));
            console.log($(this).attr('data-forms'));
            if(typeof $(this).attr('data-forms') != "undefined"){
                console.log('defined');
                e.stopImmediatePropagation();
            }
        })
    });



    /**
     * Applies the Jquery DataTables plugin to a rendered HTML table to provide
     * column sorting and Moment.js functionality to date/time values.
     *
     * @param {String} tableId The id of the table element.
     * @returns {undefined}
     */
    function submissionsTable (tableId) {
        $('#'+tableId).DataTable({
            dom: '<"wrapper">t',
            columns: [ { defaultContent: ''}, null, null, null, null ],
            columnDefs: [
                {
                    render: function ( cellData, type, row ) {
                        var span = $('<a>').attr('href', 'javascript:void(0);');
                        var iso8601date = cellData;
                        $(span).text(moment(iso8601date).fromNow())
                                .attr('title', moment(iso8601date).format('MMMM Do YYYY, h:mm:ss A'))
                                .addClass('time-ago')
                                .data('toggle', 'tooltip')
                                .data('placement', 'top');
                        var td = $('#'+tableId+' td:contains('+cellData+')');
                        td.html(span);
                        return td.html();
                    },
                    targets: 'date'
                },
                {
                    orderable: false,
                    targets: 'nosort'
                }
            ]
        });
    }
    //Request and Approval datatables 
    $(function(){
        currentId = getUrlParameters().page;
       
        if (currentId == 'approval'){
            renderTable({
                table: '#approvalTable',
                type: 'Approval',
                serverSide: false,
            });
        }
        if(currentId === 'service'){
            renderTable({
                table: '#serviceTable',
                type: 'Service',
                serverSide: false,
            });
        }
        if(currentId == 'complete'){
            $('#completeTable').removeData('pageTokens');
            renderTable({
                table: '#completeTable',
                length: 10,
                serverSide: true,
            });
        }
        
        /* We are using the page load to set some visual cues so the user know what tab they are on*/
        if(currentId === undefined){
            $('#home').addClass('active');
        }else{
            $('#'+currentId).addClass('active');
        }
    });

    // Build Datatables if datatable class exists on a table. If empty, Display Empty Text 
    $(function(){
        // Make sure namespace exists
        bundle.submissions = bundle.submissions || {};
        bundle.submissions.tableObjects = bundle.submissions.tableObjects || {};

        $('table.datatable').each(function(){
            var usesearch = $(this).hasClass("nosearch") ? false:true ;
            $(this).css("width:100%");
            var tabId = $(this).closest('div.tab-pane').attr('id');
            bundle.submissions.tableObjects[tabId] = $(this).DataTable({
                "paging": true,
                "lengthChange": false,
                "searching": usesearch,
                "order": [[ 3, "desc" ]],
                "info": true,
                "autoWidth": true,
                "scrollX": true
            });
        })
        $('td.dataTables_empty').html('None found. Check back soon!');
    });

    // Redraw datatable on tab select to redraw columns
    $(function(){
        //$('ul.nav-tabs li').on('click',function(){
        $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            var tabId = $(e.target).attr("href").substring(1);
            bundle.submissions.tableObjects[tabId].columns.adjust().draw();
        });
    })

    function renderTable(options){
        $.ajax({
            method: 'get',
            contentType: 'application/json',
            url: buildAjaxUrl(options),
            success: function(data, textStatus, jqXHR){
                if(options.serverSide){
                    // For server side pagination we are collecting the nextpagetoken metadata that is attached to submissions return object.
                    // The token is added to an array that is attached to the table elements data property. 
                    var nextPageToken;
                    if(data.nextPageToken === null){
                        nextPageToken = "lastPage";
                    }else{
                        nextPageToken = data.nextPageToken;
                    }
                    $(options.table).data('nextPageToken', nextPageToken);
                    if ($(options.table).data('pageTokens') === undefined) {
                        $(options.table).data('pageTokens', ["firstPage"]); 
                    }
                    //  To make sure duplicate tokens are not created when pages are revisited.
                    var tokenArray = $(options.table).data('pageTokens');
                    if(!($.inArray(nextPageToken,tokenArray) > 0)){
                        $(options.table).data('pageTokens').push(nextPageToken);
                    }
                }
                $.fn.dataTable.moment('MMMM Do YYYY, h:mm:ss A');
                var table = $(options.table).DataTable({
                    "destroy": true,
                    "order": [[ 0, "desc" ]],
                    bSort: options.serverSide ? false : true,
                    destroy:true,
                    "pagingType": options.serverSide ? "simple" : "simple_numbers",
                    "dom": options.serverSide ? '<"top"l>t<"bottom"p><"clear">' : "lftip",
                    "data": data.submissions,
                    "language": {"search":""},
                    "pageLength": options.length,
                    "columns": [
                        { "data":function(data){return moment(data.submittedAt).format('MMMM Do YYYY, h:mm:ss A');} },
                        { "data":"form.name" },
                        { "data":function(data){
                                // This allows the submission id to be a url to the submission details display page or if the submission
                                // has a coreState of draft the url will link to the submission to be completed.
                                // TODO: use submission label instead of guid
                                if(data.coreState == "Draft"){
                                    var id = "<a href='"+window.bundle.spaceLocation()+"/submissions/"+data.id+"'>"+data.label+"</a>"; 
                                }else{
                                    var id = "<a href='"+window.bundle.kappLocation()+"?page=submission&id="+data.id+"'>"+data.label+"</a>"; 
                                }
                                return id;} },
                        { "data":"coreState"  },
                    ]
                });
                
                if(options.serverSide){
                    var arr = $(options.table).data('pageTokens');
                    var nextToken = $(options.table).data('nextPageToken')
                    var index = $.inArray(nextToken, arr);
                    
                    if($(options.table).data('nextPageToken') !== "lastPage"){
                        $(options.table+'_next').removeClass('disabled');
                        // Add click event to next button, if serverSide property is set to true, to allow pagination to addintional results.
                        $(options.table+'_next').on('click',function(){    
                            renderTable($.extend({},options,{
                                token: function(){
                                    var token = arr[index];
                                    return token;},
                            }));
                        });
                    }
                    if(index !== 1){
                        $(options.table+'_previous').removeClass('disabled');
                        // Add click event to previous button, if serverSide property is set to true, to allow pagination to previous results.
                        $(options.table+'_previous').on('click',function(){
                            renderTable($.extend({},options,{
                                token: function(){
                                    var token = arr[index-2];
                                    return token;},
                            }));
                        });
                    }
                    /* Sets the number of rows displayed with the select option menu */
                    $(options.table+'_length').change(function(){
                        delete options.token;
                        $('#completeTable').removeData('pageTokens');
                        renderTable($.extend({},options,{
                            length: $(options.table+'_length option:selected').val(),
                        }));
                    });
                }
            },
            complete: function(){
                $('.dataTables_filter input').addClass('form-control');
                $('.dataTables_filter input').attr('placeholder', 'Filter...');
            }
        });
    }
    /* This fucntion build a Url to be used by the ajax call.
     * The intention is to be able to pass parameter to this function to have a configurable url so that we can have 
     * the ability to configure the query with the same piece of code*/
    function buildAjaxUrl(options){
        var url = bundle.apiLocation()+'/kapps/'+bundle.kappSlug()+'/submissions?include=form,details&timeline=createdAt&createdBy='+identity;
        
        if(options.serverSide){
            url += '&coreState=Closed'; 
        }else{
            url += '&coreState=Draft&coreState=Submitted&type='+options.type;
        }
        if(options.serverSide && options.length !== undefined){
            url += '&limit=' + options.length;
        }
        if(options.token && options.token() != "firstPage"){
            url += '&pageToken='+options.token();
        };
        return url;
    }
    
    // Display error message if authentication error is found in URL.  This happens if login credentials fail.
    $(function(){
        if(window.location.search.substring(1).indexOf('authentication_error') !== -1){
            $('form').notifie({type:'alert',severity:'info',message:'username or password not found'});
        };
    });
    //  utility 
    getUrlParameters = function() {
       var searchString = window.location.search.substring(1), params = searchString.split("&"), hash = {};

       for (var i = 0; i < params.length; i++) {
         var val = params[i].split("=");
         hash[unescape(val[0])] = unescape(val[1]);
       }
       return hash;
    };
    
    $(function() {
        $('[data-moment]').each(function(index, item) {
            var element = $(item);
            element.html(moment(element.text()).format('MMMM Do YYYY, h:mm:ss A'));
        });
        $('[data-moment-short]').each(function(index, item) {
            var element = $(item);
            element.html(moment(element.text()).fromNow());
        });
    });
    
    /*----------------------------------------------------------------------------------------------
     * BUNDLE.CONFIG OVERWRITES
     *--------------------------------------------------------------------------------------------*/
    
    /**
     * Overwrite the default field constraint violation error handler to use Notifie to display the errors above the individual fields.
     */
    bundle.config = bundle.config || {};
    bundle.config.renderers = bundle.config.renderers || {};
    bundle.config.renderers.fieldConstraintViolations = function(form, fieldConstraintViolations) {
        _.each(fieldConstraintViolations, function(value, key){
            $(form.getFieldByName(key).wrapper()).notifie({
                message: value.join("<br>"),
                exitEvents: "click"
            });
        });
    }
    bundle.config.renderers.submitErrors = function(response) {
        $('[data-form]').notifie({
            message: 'There was a ' + response.status + ' : "' + response.statusText + '" error.' ,
            exitEvents: "click"
        });
        console.log(response);
    }

})(jQuery, _, moment);

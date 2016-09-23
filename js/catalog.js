/**
 * Forms Search using Twitter Typeahead. Prefetch all accessible forms
 * for the Kapp.
**/
(function($, _, moment){
    /*----------------------------------------------------------------------------------------------
     * COMMON INIALIZATION 
     *   This code is executed when the Javascript file is loaded
     *--------------------------------------------------------------------------------------------*/

    // Ensure the BUNDLE global object exists
    bundle = typeof bundle !== "undefined" ? bundle : {};
    // Create your namespace
    bundle.demo = bundle.demo || {};
    // Create a scoped alias to simplify references to your namespace
    var demo = bundle.demo;
    
    // UTILITY METHODS

    /**
     * Returns an Object with keys/values for each of the url parameters.
     */
    demo.getUrlParameters = function() {
       var searchString = window.location.search.substring(1), params = searchString.split("&"), hash = {};
       for (var i = 0; i < params.length; i++) {
         var val = params[i].split("=");
         hash[unescape(val[0])] = unescape(val[1]);
       }
       return hash;
    };
    
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
 
    /*
     * DataTables
     * These dynamically created tables gerneraed from an ajax call located in the renderTable function.
     * The ajax call is configured to hit an endpoint in the partials file in the bundle of the current kapp.
     * The renderTable function has required and optional parameters.
     * The dataTables are initialized int the on load function at the bottom of the file.
     * 
     * ATTRIBTUES: 
     * table                    *REQUIRED       (this will be id of the table element in the html file that the dataTable will be rendered in)
     * jsonFileName             *REQUIRED       (the file name that has the json payload for the dataTable)
     * type                     *OPTIONAL       (not including a type or including an empty sting will return submissions with a null type {as of core 1.0.5})
     * coreState                *OPTIONAL       (this will return all submissions for the current kapp that match the core state)
     * serverSide               *OPTIONAL       (for server side pagination)
     * length                   *OPTIONAL       (use with serverSide.  Sets the number of rows that are displayed on the load of the table. defaults to 10)
     */
    function initializeTable(){
        currentId = demo.getUrlParameters().page;

        /*  The dataTables that are built depend on the value of the page parameter in the url. 
         *  The the object sent to the renderTable function is extended with format options for the dataTable.
         */
        if (currentId == 'approvals'){
            renderTable({
                table: '#pendingTable',
                jsonFileName: 'pendingTable.json',
                type: 'Approval',
                coreState: ['Submitted','Draft'],
                serverSide: false,
            });
            renderTable({
                table: '#closedTable',
                jsonFileName: 'completedTable.json',
                type: 'Approval',
                coreState: ['Closed'],
                serverSide: true,
            });
        }
        if(currentId === 'requests'){
            renderTable({
                table: '#openTable',
                jsonFileName: 'openTable.json',
                type: 'Service',
                coreState: ['Submitted'],
                serverSide: false
            });
            renderTable({
                table: '#closedTable',
                jsonFileName: 'closedTable.json',
                type: 'Service',
                coreState: ['Closed'],
                serverSide: true
            });
            renderTable({
                table: '#draftTable',
                jsonFileName: 'openTable.json',
                type: 'Service',
                coreState: ['Draft'],
                serverSide: false
            });
        }
        if(currentId == 'workOrder'){
            $('#completeTable').removeData('pageTokens');
            renderTable({
                table: '#openTable',
                jsonFileName: 'openTable.json',
                type: 'Work Order',
                coreState: ['Submitted','Draft'],
                serverSide: false,
            });
            renderTable({
                table: '#closedTable',
                jsonFileName: 'closedTable.json',
                type: 'Work Order',
                coreState: ['Closed'],
                serverSide: true,
            });
        }
    };

    function renderTable(options){
        $.ajax({
            method: 'get',
            url: buildAjaxUrl(options),
            dataType: "json",
            contentType: 'application/json',
            beforeSend: function(jqXHR, obj){
                $(options.table).append('<div><i id="spinner" class="fa fa-cog fa-spin fa-3x" style="text-align:center;width:100%"/></div>');
            },
            success: function(data, textStatus, jqXHR){
                $('#spinner').remove();
                // extend the object to format the dataTable.
                records = $.extend(data, {
                    responsive: {breakpoints: [
                        { name: 'desktop', width: Infinity },
                        { name: 'tablet',  width: 1024 },
                        { name: 'fablet',  width: 768 },
                        { name: 'phone',   width: 480 }
                    ]},
                    "destroy": true,                   
                    "bSort": options.serverSide ? false : true,
                    "pagingType": options.serverSide ? "simple" : "simple_numbers",
                    "dom": options.serverSide ? '<"top"l><"dataTables_date">t<"bottom"p><"clear">' : 'lftip',
                    "pageLength": options.serverSide ? options.length : 10,
                    "createdRow": function (row, data) {
                        $(row).find('td.data-moment').each(function(index, td) {
                            $(td).text(moment($(td).text()).format('MMMM Do YYYY, h:mm:ss A'));
                        });
                        $(row).find('td.data-link').each(function(index, td) {
                            if(data.State == "Draft"){
                                $(td).html("<a href='"+window.bundle.spaceLocation()+"/submissions/"+data.Id+"'>"+data.Submission+"</a>"); 
                            }else{
                                $(td).html("<a href='"+window.bundle.kappLocation()+"?page=submission&id="+data.Id+"'>"+data.Submission+"</a>"); 
                            }
                        });
                        $(row).find('td.data-label').each(function(index, td) {
                            $(td).html('<span class="label '+labelStatusColor(options, data)+'">'+data.State+'</span>'); 
                        });
                    },
                });
                var table = $(options.table).DataTable(records);

                /* After the table has been built we are adding an html element that has a dropdown list so that a user can select a number of days back
                 * to retrieve the list from.
                 */
                //addDateDropdown(options)
                if(options.serverSide){
                    serverOptions(options,data);
                }
            },
        });
    }
    
    /* This fucntion build a Url to be used by the ajax call.
     * The intention is to be able to pass parameter to this function to have a configurable url so that we can have 
     * the ability to configure the query with the same piece of code*/
    function buildAjaxUrl(options){
        var url = bundle.kappLocation() + "?partial="+options.jsonFileName;
        if(options.type === 'Approval'){
            url += '&values[Assigned Individual]='+identity;
        }else{
            url += '&createdBy='+identity+'&requestedFor='+identity;
        }
        if(options.coreState !== undefined){
            $.each(options.coreState, function(k,v){
                url += '&coreState='+v; 
            });
        }
        if(options.type !== undefined){
            url += '&type='+options.type;
        }
        if(options.backDate !== undefined){
            url += '&date=' + options.backDate;
        }
        if(options.length !== undefined){
            url += '&limit=' + options.length;
        }
        if(options.token && options.token() !== undefined){
            url += '&pageToken='+options.token();
        }
        return url;
    }
    
    /*  This code is to override dataTables default behavior. 
     *  This is done because dataTables uses an offset token for pagination but core does has the concept of page tokens.
     */
    function serverOptions(options,data){
        // For server side pagination we are collecting the nextpagetoken metadata that is attached to submissions return object.
        // The token is added to an array that is attached to the table elements data property. 
        if ($(options.table).data('nextPageTokens') === undefined) {
            $(options.table).data('nextPageTokens', []); 
        }
        $(options.table).data('nextPageTokens').push(data.nextPageToken);
        var arr = $(options.table).data('nextPageTokens');
        var token = _.last(arr);

        /*  If the table DOM element has a 'nextPageTokens' data attribute array that has a token in it then we remove the disabled class from the Next button.
         *  When the Next button is clicked the current object is extended to add the next page token (of the next page) parameter that will be appended to the URL.
         */
        if(token !== ''){
            $(options.table+'_next').removeClass('disabled');
            // Add click event to next button, if serverSide property is set to true, to allow pagination to addintional results.
            $(options.table+'_next').on('click',function(){    
                renderTable($.extend({},options,{
                    token: function(){
                        return token;},
                }));
            });
        }

        // TODO: should we and a refresh button?
        // Do a $.pop() action will be required to remove the next page token from the nextPageTokens array.

        /*  If the table DOM element has a 'nextPageTokens' data attribute greater than one then we remove the disabled class from the Previous button.
         *  When the Previous button is clicked the current object is extended to add the next page tokens (of the privous page) parameter that will be appended to the URL.
         */
        if(arr.length > 1){
            $(options.table+'_previous').removeClass('disabled');
            // Add click event to previous button, if serverSide property is set to true, to allow pagination to previous results.
            $(options.table+'_previous').on('click',function(){
                // To move to a previous page two $.pop() actions required.
                // One to remove the next page token and One to remove the current page token from the nextPageTokens array.
                $(options.table).data('nextPageTokens').pop();
                $(options.table).data('nextPageTokens').pop();
                // We rebuild that table with the values of the previous page including any new rows of data.
                renderTable($.extend({},options,{
                    token: function(){
                        token = _.last(arr);
                        return token;},
                }));
            });
        }
        /* Sets the number of rows displayed with the select option menu.  We have to delete the old tokens from the object and remove the data-nextPageTokens attribute.
         * We do this so that the token store is clear and the display of the Previous and Next button behaves correctly 
         */
        $(options.table+'_length').change(function(){
            delete options.token;
            $(options.table).removeData('nextPageTokens');
            renderTable($.extend({},options,{
                length: $(options.table+'_length option:selected').val(),
            }));
        });
    };
    
    /*  This sets the color of the value in the status field in the dataTable.  
     *  The value for data.State is set here if the submission had a field with the name 'Decision'.
     */
    function labelStatusColor(options, data){
        var statusColor;
        if(data.Values !== undefined && data.Values.Decision !== undefined){
            data.State = data.Values.Decision;
            if(data.Values.Decision === "Approved"){
                statusColor = "label-success";
            }else if(data.Values.Decision === "Denied"){
                statusColor = "label-danger";
            }else{
                statusColor = "label-default"; 
            }
        }else{
            if(data.State == "Draft"){
                statusColor = "label-warning";
            }else if(data.State == "Submitted"){
                statusColor = "label-primary"; 
            }else{
                statusColor = "label-default"; 
            }
        }
        return statusColor;
    }
    
  
    $(function(){

    });
    
    $(function() {
        // Initialize, with seed values, the dataTables that are used on the approval, request and work order pages 
        initializeTable();
        
        // Display error message if authentication error is found in URL.  This happens if login credentials fail.
        if(window.location.search.substring(1).indexOf('authentication_error') !== -1){
            $('form').notifie({type:'alert',severity:'info',message:'username or password not found'});
        };
        
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
    }

})(jQuery, _, moment);

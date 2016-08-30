(function($){
    $(function(){

        // Change the Status that the Task Engine returns to pe properly formatted and in the correct color
        $('td.status').each(function(){
            var arr = $(this).html().replace("CREATE_","").replace("_"," ").toLowerCase().split(' ');
            var result = "";
            for (var x=0; x<arr.length; x++)
                result+=arr[x].substring(0,1).toUpperCase()+arr[x].substring(1)+' ';
            result = result.substring(0, result.length-1);
            if ( result === "Complete" ){
                $(this).parent('tr').addClass("bg-green");
            }
            if ( result === "In Progress" ){
                $(this).parent('tr').addClass("bg-yellow");
            } 
            $(this).html(result);
        });

        // Setup Spinner HTML
        var spinner = $('<div class="text-center spinner">').append($('<i class="fa fa-cog fa-spin fa-3x"></i>'))

        /*
        // Begin looking up Custom Fulfillment Details 
        */

        // Process Change Requests
        $('.change-request').each(function(){
            // Container where the Bridged Data will be returned to
            var container = $(this);
            // Append Spinner while bridge is being searched
            $(container).append(spinner);
            // Id of the Object to get data for
            var id = $(this).data('for');
            // URL of Bridged Data
            bridgeUrlParent = bundle.kappLocation() + "/shared-resources/bridgedResources/Change?values[Change Id]=" + id;
            workLogUrl = bundle.kappLocation() + '/work-log-entry'
            // Look for Parent Object
            $.ajax({
                url: bridgeUrlParent,
                success: function(data){
                    var parent = data.record.attributes;
                    var parentHtml = $('<div class="well"><h4>Change Number: ' + parent.Id + '</h4><hr></div>');
                    // Set Status of Task to Status of Parent Record
                    $(container).parents('.timeline-item').find('.task-status').text(parent['Status']);
                    bridgeUrlChild = bundle.kappLocation() + "/shared-resources/bridgedResources/Change Work Info?values[Change Id]=" + parent.Id;
                    // Look for Child - Note Entries
                    $.ajax({
                        url: bridgeUrlChild,
                        success: function(data){
                            if(data.records.records.length > 0){
                                var childrenHtml = $('<ul class="list-unstyled ui-sortable"><h4>Notes:</h4></ul>');
                                var children = _.map(data.records.records, function(record){
                                    return _.object(data.records.fields, record);
                                });
                                $.each(children, function(i,child){
                                    var childHtml = $('<strong class="pull-left primary-font">' + child['Submitter'] + '</strong>' + 
                                        '<small class="pull-right text-muted"><span class="glyphicon glyphicon-time"></span>&nbsp;<span data-moment-short>' + child['Submit Date'] + '</span></small></br>' + 
                                        '<li class="ui-state-default">' + child['Notes'] + '</li><hr></br>')
                                    $(childrenHtml).append(childHtml);
                                })
                                $(parentHtml).append(childrenHtml);
                            }
                            $(parentHtml).append($('<div note-for="' + parent.Id + '"></div>'))
                            $(parentHtml).find('[data-moment-short]').each(function(index, item) {
                                var element = $(item);
                                element.html(moment(element.text()).fromNow());
                            });
                            $(container).html(parentHtml);
                            // Only Allow Work Info's to be added to open Records
                            if (parent['Status'] !== "Resolved" && parent['Status'] !== "Closed") {
                                // Load Work Notes Subform
                                K.load({
                                    path: workLogUrl,
                                    container: '[note-for="'+parent.Id+'"]',
                                    loaded: function(form) { 
                                        form.select('field[Parent Submission Id]').value(parent.Id);
                                        form.select('field[Parent Fulfillment Id]').value(parent.Id);
                                        form.select('field[Parent Fulfillment Type]').value("Change");
                                    },
                                    completed: function(submission, action) {
                                        action.close();
                                        $('[note-for="'+parent.Id+'"]').html('<p>Your note has been successfully added to the system...</p>');
                                        // COMPLETED CODE HERE
                                    }
                                });
                            }
                        },
                        dataType: "json"
                    });
                },
                dataType: "json"
            });
        });
        // Process Incidents
        $('.incident').each(function(){
            // Container where the Bridged Data will be returned to
            var container = $(this);
            // Append Spinner while bridge is being searched
            $(container).append(spinner);
            // Id of the Object to get data for
            var id = $(this).data('for');
            // URL of Bridged Data
            bridgeUrlParent = bundle.kappLocation() + "/shared-resources/bridgedResources/Incident?values[Incident Id]=" + id;
            workLogUrl = bundle.kappLocation() + '/work-log-entry'
            // Look for Parent Object
            $.ajax({
                url: bridgeUrlParent,
                success: function(data){
                    var parent = data.record.attributes;
                    var parentHtml = $('<div class="well"><h4>Incident Number: ' + parent.Id + '</h4><hr></div>');
                    // Set Status of Task to Status of Parent Record
                    $(container).parents('.timeline-item').find('.task-status').text(parent['Status']);
                    bridgeUrlChild = bundle.kappLocation() + "/shared-resources/bridgedResources/Incident Work Info?values[Incident Id]=" + parent.Id;
                    // Look for Child - Note Entries
                    $.ajax({
                        url: bridgeUrlChild,
                        success: function(data){
                            if(data.records.records.length > 0){
                                var childrenHtml = $('<ul class="list-unstyled ui-sortable"><h4>Notes:</h4></ul>');
                                var children = _.map(data.records.records, function(record){
                                    return _.object(data.records.fields, record);
                                });
                                $.each(children, function(i,child){
                                    var childHtml = $('<strong class="pull-left primary-font">' + child['Submitter'] + '</strong>' + 
                                        '<small class="pull-right text-muted"><span class="glyphicon glyphicon-time"></span>&nbsp;<span data-moment-short>' + child['Submit Date'] + '</span></small></br>' + 
                                        '<li class="ui-state-default">' + child['Notes'] + '</li><hr></br>')
                                    $(childrenHtml).append(childHtml);
                                })
                                $(parentHtml).append(childrenHtml);
                            }
                            $(parentHtml).append($('<div note-for="' + parent.Id + '"></div>'))
                            $(parentHtml).find('[data-moment-short]').each(function(index, item) {
                                var element = $(item);
                                element.html(moment(element.text()).fromNow());
                            });
                            $(container).html(parentHtml);
                            
                            // Only Allow Work Info's to be added to open Records
                            if (parent['Status'] !== "Resolved" && parent['Status'] !== "Closed") {
                                // Load Work Notes Subform
                                K.load({
                                    path: workLogUrl,
                                    container: '[note-for="'+parent.Id+'"]',
                                    loaded: function(form) { 
                                        form.select('field[Parent Submission Id]').value(parent.Id);
                                        form.select('field[Parent Fulfillment Id]').value(parent.Id);
                                        form.select('field[Parent Fulfillment Type]').value("Incident");
                                    },
                                    completed: function(submission, action) {
                                        action.close();
                                        $('[note-for="'+parent.Id+'"]').html('<p>Your note has been successfully added to the system...</p>');
                                    }
                                }); 
                            }
                        },
                        dataType: "json"
                    });
                },
                dataType: "json"
            });
        });

        /*
        // END looking up Custom Fulfillment Details 
        */

    }); // End on load function

})(jQuery);



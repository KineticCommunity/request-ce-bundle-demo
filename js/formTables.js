

/* Function called when a table needs to be built. Pass the following parameters
 * sectionWithQuestions - Name of the section that contains the questions we want to show in the table. Note: All questions in this section will show
 * jsonQuestionName - this is the Name of the question on the SI that stores the JSON data for the table
 * tableDivID - create a text element on the page that you'll be displaying a table and give it an ID. Pass that ID here...
 * tableName - pass a unique name for this table so you can handle oneoffs downstream 
 */
function loadData(sectionWithQuestions, jsonQuestionName, tableDivID, tableName) {

    // Define Variables
    var oTable;                                 // DataTable Variable
    var columns = [];                           // Variable used to store the column/question names and label
    var jsonData = [];                          // Array or entries in table
    var tableName = tableName;                  // Name of Table used in Buttons and Table Header
    var sectionWithQuestions = K('section[' + sectionWithQuestions + ']') ; // Kinetic Section Object that contains the questions (we show and hide this section)
    var tableDiv = $('#' + tableDivID);         // jQuery table div selector
    var innerTableDiv = tableDivID +"_Table";   // jQuery Inner table div selector
    var jsonQuestion = K('field['+ jsonQuestionName + ']'); // jsonQuestion referenced when making updates to the data
    var allowDeleteClone = true; // Variable used to configure if values can be deleted or colned
    
    // Loop through all of the questions in the section passed and grab the question name and labels. These will be used to build the columns
    // in the table as well as update the questionAnswers when adding and modifying rows    
    columns = $(sectionWithQuestions.element()).find( 'div[data-element-type="wrapper"]' ).map(function() {
        return {'Name' : $(this).data("element-name"), 'title' : $(this).children('label.field-label').html()};
    });

    // Add the last column which has the row manipulator buttons (Edit, Clone, Delete)
    columns.push({"title": '',
             "width": '100px',
             "data" :  null,
             "defaultContent": "<button title='Remove Item' class='btn-delete' value='Delete'><i class='fa fa-times'></i></button>" +
                               "<button title='Clone Item' class='btn-clone' value='Clone'><i class='fa fa-clone'></i></button>" +
                               "<button title='Edit Item' class='btn-edit' value='Edit'><i class='fa fa-pencil-square-o'></i></button>" +
                               "<button style='display:none;' title='Save Item' class='btn-save' value='Save'><i class='fa fa-floppy-o'></i></button>",
             "orderable": false
            });
    
    /**********************************
    CUSTOM CODE SPECIFIC TO PROJECT
    **********************************/

    /**********************************
    END CUSTOM CODE SPECIFIC TO PROJECT
    **********************************/
   

    // Check to see if there is already Table Data from a saved request
    if (jsonQuestion.value() != null && jsonQuestion.value() != "[]"){
        // Parse the question value string into a json array
        jsonData = JSON.parse(jsonQuestion.value());
        // Create an Array of Data that the Data Table can accept
        var dataSetArray = [];
        for(var i = 0; i < jsonData.length; i++){
            var keyArray = Object.keys(jsonData[i]);
            var resultArray = [];
                for(var j = 0; j < keyArray.length; j++){
                    resultArray.push(jsonData[i][keyArray[j]]);
                }
            dataSetArray.push(resultArray);
        }
        buildDataTable(dataSetArray);
    }
    // If no data exists, build an empty table
    else {
        buildDataTable([]);
    }

    // Function the builds the actual Data Table
    function buildDataTable(dataArray) {
        //Destroy first, if the table already exists.
        if (oTable){
            oTable.destroy();
        }
       
        /* Add table container and definition to container div */
       tableDiv.html('<div class="' + tableDivID + '-table-header"></div>').append('<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" id=\"'+ innerTableDiv+'\"></table>' );
        oTable = $('#'+innerTableDiv).DataTable({
            "data": dataArray,
            "columns" : columns,
            "pageLength": 5,
            "lengthChange": true,
            "searching": false,
            "bLengthChange": false
        });

        // Append an add button and a save button
        //if(clientManager.submitType != "ReviewRequest" && allowDeleteClone == true){
            tableDiv.append($("<div id='action-btns-" + tableDivID + "' style='padding-top:15px;'>" +
                    "<button name='Add Row' class='btn-create' value='addButton' style='margin-right: 10px;'>Add a New Row</button>" +
                    "<button name='Save Row' class='btn-save' value='saveButton' style='display:none; margin-right: 10px;'>Save Row to Table</button>"+
                    "<button name='Cancel Edits' class='btn-cancel' value='cancelButton' style='display:none; margin-right: 10px;' >Cancel</button>"));
        //}
        
        //watch for add button click on Table Buttons (action-btns div) For Adding New Row, Saving a Row, or Canceling Edits to a Row
        $('#action-btns-' + tableDivID).on( 'click', 'button', function () {
            if (this.value==="addButton") {
                sectionWithQuestions.show();
                $('#action-btns-' + tableDivID +' .btn-save').show();
                $('#action-btns-' + tableDivID +' .btn-cancel').show();
                $('#action-btns-' + tableDivID +' .btn-create').hide();
                $('button[data-element-type="button"]').hide();
            }

            if (this.value==="cancelButton") {
                sectionWithQuestions.hide();
                $('#action-btns-' + tableDivID +' .btn-save').hide();
                $('#action-btns-' + tableDivID +' .btn-cancel').hide();
                $('#action-btns-' + tableDivID +' .btn-create').show();
                $('button[data-element-type="button"]').show();

                for (var i = 0; i < columns.length -1 ; i++){
                    K('field['+ columns[i].Name +']').value(null);
                }
            }

            if (this.value==="saveButton") {            
                // temp variable for new table row
                var newRow = [];
                // temp variable for building JSON object to be pushed to jsonData array
                var newRowJSON = {};
                // temp value to validate data

                if(validateBeforeSave()){
                    // loop through each question and build up temp variables, also blank out questions 
                    for (var i = 0; i < columns.length -1; i++){              
                        newRowJSON[columns[i].Name]=K('field['+ columns[i].Name +']').value();
                        newRow.push(K('field['+ columns[i].Name +']').value());
                        K('field['+ columns[i].Name +']').value(null);                    
                    }
                    // push temp json object to jsonData array
                    jsonData.push(newRowJSON);
                    // set the json question on the Service Item which ultimately saves the data
                    jsonQuestion.value(JSON.stringify(jsonData) );
                    // add the new row to the table
                    oTable.row.add(newRow).draw();
                    $('#action-btns-' + tableDivID +' .btn-save').hide();
                    sectionWithQuestions.hide();
                    $('#action-btns-' + tableDivID +' .btn-create').show();
                    $('#action-btns-' + tableDivID +' .btn-cancel').hide();
                    $('button[data-element-type="button"]').show();
                }
            }
        });

        
        // Watch for in-table button clicks (Clone / Edit / Delete)
        $('table tbody', tableDiv).on( 'click', 'button', function () {
            var row = $(this).parents('tr'),
                index = oTable.row( row ).index(),
                data = oTable.row( row ).data();
                var rowIdentifier;
                for(var j = 0; j < jsonData.length; j++){
                    if (jsonData[j][columns[0].name] == data[0]){
                        rowIdentifier = j;
                    }
                }
                
            if (this.value=="Edit") {

                //swap buttons
                rowButtonsToggle(row);
                disableEditCloneButtons(row.closest("table").attr("id"))
                oTable.columns.adjust().draw();

                //remove the action buttons         
                sectionWithQuestions.show();
                $('#action-btns-' + tableDivID +' .btn-create').hide(); 
                $('#action-btns-' + tableDivID +' .btn-save').hide();
                $('button[data-element-type="button"]').hide(); 
                       
                
                //populate content fields per the data in the row
                for (var i = 0; i< columns.length - 1; i++){
                    K('field['+ columns[i].Name +']').value(oTable.row( row ).data()[i])
                }
            }

            if (this.value=="Clone") {

                //remove the action buttons         
                sectionWithQuestions.show();
                $('#action-btns-' + tableDivID +' .btn-create').hide();
                $('#action-btns-' + tableDivID +' .btn-save').show(); 
                $('button[data-element-type="button"]').hide();          
                
                //populate content fields per the data in the row
                for (var i = 0; i< columns.length - 1; i++){
                    K('field['+ columns[i].Name +']').value(oTable.row( row ).data()[i]);
                }
            }
            
            if (this.value=="Cancel") {
                var verify = confirm('Are you sure you want to cancel edits to this Row');
                if (verify==true) {
                    //swap buttons
                    rowButtonsToggle(row);
                    enableEditCloneButtons(row.closest("table").attr("id"))
                    $('button[data-element-type="button"]').show(); 
                    oTable.columns.adjust().draw();

                    //$sectionWithQuestionsDiv.hide();
                    $('#action-btns-' + tableDivID +' .btn-create').show(); 

                    for (var i = 0; i< columns.length -1; i++){
                        K('field['+ columns[i].Name +']').value(null);
                    }
                    
                }
            }
            
            if (this.value=="Delete") {
                var verify = confirm('Are you sure you want to delete this Row?');
                if (verify==true) {
                    jsonData.splice(rowIdentifier,1);
                    oTable.row(row).remove().draw();
                    jsonQuestion.value(JSON.stringify(jsonData));
                }
            }
            
            if (this.value=="Save") {               
                
                var newRow = [];
                // temp variable for building JSON object to be pushed to jsonData array
                var newRowJSON = {};               
                if(validateBeforeSave()){
                    // loop through each question and build up temp variables, also blank out questions 
                    for (var i = 0; i< columns.length - 1; i++){
                        newRowJSON[columns[i].Name] = K('field['+ columns[i].Name +']').value();
                        newRow.push(K('field['+ columns[i].Name +']').value());
                        K('field['+ columns[i].Name +']').value(null);
                    }
                    // push temp json object to jsonData array
                    jsonData[rowIdentifier]=newRowJSON;
                    // set the json question on the Service Item which ultimately saves the data
                    jsonQuestion.value(JSON.stringify(jsonData))
                    // add the new row to the table
                    oTable.row(row).data(newRow).draw();

                    $('#action-btns-' + tableDivID +' .btn-save').hide();
                    sectionWithQuestions.hide();
                    $('#action-btns-' + tableDivID +' .btn-create').show();
                    $('button[data-element-type="button"]').show();
                    enableEditCloneButtons(row.closest("table").attr("id"));
                    checkButtons();
                }
            }
        } );

    checkButtons();

    function checkButtons(){
        // Remove Delete Clone Buttons    
        if(allowDeleteClone == false){
                $(".btn-clone").hide();
                $(".btn-delete").hide();
            }
        }

        if ("ReviewRequest" != "ReviewRequest"){
            $(".btn-clone").hide();
            $(".btn-delete").hide();
            $(".btn-edit").hide();
        }
    }


    function rowButtonsToggle(row) {
        //make appropriate buttons visible on the identified row.  If editing, hide the edit and clone buttons.
        //if not editing, hide save and cancel.
        row.find($('.btn-edit')).toggle();
        row.find($('.btn-save')).toggle();
        row.find($('.btn-cancel')).toggle();
        row.find($('.btn-apply')).toggle();
        if(allowDeleteClone == true){
            row.find($('.btn-delete')).toggle();
            row.find($('.btn-clone')).toggle();
        }
    }

    function disableEditCloneButtons(tableID) {
        //disable all edit and clone buttons on the identified table once an edit is taking place
        $('#' + tableID + ' .btn-edit, #' + tableID + ' .btn-clone, #' + tableID + ' .btn-delete').attr("disabled", "disabled");
    };

    function enableEditCloneButtons(tableID) {
        //enable all edit and clone buttons on the identified table once an edit has been saved/applied or cancelled.
        if(allowDeleteClone == true){
            $('#' + tableID + ' .btn-edit, #' + tableID + ' .btn-clone, #' + tableID + ' .btn-delete').removeAttr("disabled");
        }
        else {
            $('#' + tableID + ' .btn-edit, #' + tableID).removeAttr("disabled");
        }
    };


    function validateBeforeSave(){
        allowSave = true;
        var alertMsg = $('<div class="alert alert-danger"/>');
        for (var i = 0; i< columns.length - 1; i++) {
            if( K('field['+ columns[i].Name +']').validate().length > 0 ) {
                allowSave = false;
                alerts = K('field['+ columns[i].Name +']').validate();
                for ( var j = 0; j < alerts.length; j++) {
                    alertMsg.append('<strong>Warning! </strong>' + alerts[j] + '<br>');
                }
            }
        }
        if(allowSave == false){
            $(sectionWithQuestions.element()).append($('<div class="clearfix"/>'),alertMsg);
        } else {
            $(sectionWithQuestions.element()).find('div.alert').remove();
        }
        return allowSave;
    }
    /*********************************************************/
    /*---------  End Add / Update Record Functions  ---------*/
    /*********************************************************/

}


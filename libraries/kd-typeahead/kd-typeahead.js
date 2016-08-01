/**
* Prerequisates to using this script are
* jQuery / underscore / moment
*/

/**
* TO IMPLEMENT:
* 1. Configure the required attributes on any input element within any Kinetic Form
* 2. Configure a bridge resource 
* 3. Create an on load event to call the typeAheadSearch() function OR call the typeAheadSearch() function from within the bundle.config's ready callback in your bundle
* 4. Add this code to custom head content, or include it within your form's jsp
* 5. Add the css (at the bottom of this file) to custom head content, or include it within your form's jsp
*/

/**
* DESCRIPTION
* kd-typeahead is meant for making it easy to creat typeahead searches in Kinetic Forms
* 
* The typeahead functionality is implemented on any input element with an attribute called "uses-typeahead". Additional input attributes can be specified to 
* allow form builders to manipulate the typeahead behavior. 
* 
* There is a default configuration object that is used for each typeahead search. It can be overridden by a custom configuration object added to the bundle 
* or to the forms custom head content. Additional attributes can be added to the input element that will override the custom or default configuration object.
*/

/*------------------------------------------------------------
* TYPEAHEAD SEARCH INPUT ATTRIBTUES: 
* uses-typeahead               *REQUIRED      (Provide a value if this input uses typeahead ex. 'yes')
* typeahead-config-object      *OPTIONAL      (Configuration object to use in lieu of the default configuration)
* typeahead-fields-to-set      *REQUIRED      (Comma separated Field on Form to Bridge Attribute) (e.g. Login Id Field=Login Id,Name Field=Name)
* typeahead-attribute-to-set   *REQUIRED      (Name of Bridge Attribute to Set in Typeahead Search Field) (e.g. Name)
* typeahead-attributes-to-show *REQUIRED      (Comma separated List of Bridge Attributes to Show in Typeahead Search) (e.g. Login Id,Name)
* typeahead-bridged-resource   *REQUIRED      (Name of Bridged Resource to Use - must match a valid bridge resource on the current or shared-resource form)
* typeahead-bridge-location    *OPTIONAL      (If the search uses a shared-resource form specify it's slug - Defaults to current form)
* typeahead-query-field        *OPTIONAL      (Name field the Bridged Resource is expecting to be passed as a parameter - Defaults to the typeahead search field)
* typeahead-fa-class           *OPTIONAL      (Font awesom icon to append to typeahead search and results)
* typeahead-empy-message       *OPTIONAL      (Message to display if no results are found)
* typeahead-user-id-attribute  *OPTIONAL      (If filtering results to not include logged in user (for person searching) bridge attribute for the user's Id)
* typeahead-placeholder        *OPTIONAL      (Placholder text to put into the search field)
* typeahead-min-length         *OPTIONAL      (Minium Length to begin search)
* typeahead-additional-params  *OPTIONAL      (Comma separated List of additional values to be provided to the bridge. 
*                                              The values should be prefixed with STRING:: or FIELD:: depending on if you are passing a 
*                                              hard coded string, or want the system to get a Field's Value)  (e.g Bridge Param 1=STRING::XYZ,Bridge Param 2=FIELD::FieldName )
*/

(function($, _, moment){

    // On Load Event that Searches the current form for any "typeahead" input attributes
    typeAheadSearch = function(form){
        
        $(form.element()).find('input[uses-typeahead]').each(function(){
            var typeaheadForm = form;
            // Setup Config Variables for Typeahead
            var input = $(this)
            var typeaheadConfig = $.extend({},typeaheadConfigurations['defaultConfiguration'])
            //_.extend(typeaheadConfig, typeaheadConfigurations['defaultConfiguration']) 
            typeaheadConfig['typeaheadForm'] = typeaheadForm;
            // Check to see if there is a typeahead config object being specified
            if($(input).attr('typeahead-config-object') !== undefined){
                // If so, set the typeaheadConfig to the specified config object
                typeaheadConfig = $.extend(typeaheadConfig, typeaheadConfigurations[$(input).attr('typeahead-config-object')])
            }

            // Override the specified config object if any extra typeahead attributes were set
            if(!_.isEmpty($(input).attr('typeahead-query-field'))) typeaheadConfig['queryField'] = $(input).attr('typeahead-query-field')
            if(!_.isEmpty($(input).attr('typeahead-min-length'))) typeaheadConfig['minLength'] = parceInt($(input).attr('typeahead-min-length'))
            if(!_.isEmpty($(input).attr('typeahead-fa-class'))) typeaheadConfig['faClass'] = $(input).attr('typeahead-fa-class')
            if(!_.isEmpty($(input).attr('typeahead-placeholder'))) typeaheadConfig['placeholder'] = $(input).attr('typeahead-placeholder')
            if(!_.isEmpty($(input).attr('typeahead-empty-message'))) typeaheadConfig['emptyMessage'] = $(input).attr('typeahead-empty-message')
            if(!_.isEmpty($(input).attr('typeahead-user-id-attribute'))) typeaheadConfig['userIdAttribute'] = $(input).attr('typeahead-user-id-attribute')
            if(!_.isEmpty($(input).attr('typeahead-bridged-resource'))) typeaheadConfig['bridgedResource'] = $(input).attr('typeahead-bridged-resource')
            if(!_.isEmpty($(input).attr('typeahead-bridge-location'))) typeaheadConfig['bridgeLocation'] = $(input).attr('typeahead-bridge-location')
            if(!_.isEmpty($(input).attr('typeahead-attributes-to-show'))) typeaheadConfig['attrsToShow'] = $(input).attr('typeahead-attributes-to-show').split(',')
            if(!_.isEmpty($(input).attr('typeahead-attribute-to-set'))) typeaheadConfig['attrToSet'] = $(input).attr('typeahead-attribute-to-set')

            if(!_.isEmpty($(input).attr('typeahead-query-field'))){
                typeaheadConfig['queryField'] = $(input).attr('typeahead-query-field')
            } else if (!_.isEmpty(typeaheadConfig['queryField'])){
                typeaheadConfig['queryField'] = typeaheadConfig['queryField']
            } else {
                typeaheadConfig['queryField'] = $(input).attr('name')
            }

            // Check to see if the fields-to-set attribute was provided and should override the config object provided
            if(!_.isEmpty($(input).attr('typeahead-fields-to-set'))){
                typeaheadConfig['fieldsToSet'] = {}
                $.each($(input).attr('typeahead-fields-to-set').split(','), function(i, v){
                    var fname = v.split('=')[0]
                    var fbridgedValue = v.split('=')[1]
                    typeaheadConfig['fieldsToSet'][fname] = fbridgedValue
                })
            } 

            // Check to see if any additional parameters were specified to be passed to the bridge search
            if(!_.isEmpty($(input).attr('typeahead-additional-params'))){
                typeaheadConfig['additionalParams'] = {}
                $.each($(input).attr('typeahead-additional-params').split(','), function(i, v){
                    var fname = v.split('=')[0]
                    var fbridgedValue = v.split('=')[1]
                    typeaheadConfig['additionalParams'][fname] = fbridgedValue
                })
            }

            // Determine and build bridge url to use
            if(!_.isEmpty(typeaheadConfig['bridgeLocation'])){
                typeaheadConfig['bridgeUrl'] = bundle.kappLocation() + "/" + typeaheadConfig['bridgeLocation'] + "/bridgedResources/" + typeaheadConfig['bridgedResource'] + "?values[" + typeaheadConfig['queryField'] + "]=%QUERY"
            } else {
                typeaheadConfig['bridgeUrl'] = bundle.kappLocation() + "/" + typeaheadForm.slug() + "/bridgedResources/" + typeaheadConfig['bridgedResource']  + "?values[" + typeaheadConfig['queryField'] + "]=%QUERY"
            }

            // If additional Parameters were passed, append them to the bridge URL
            if(!_.isEmpty(typeaheadConfig['additionalParams'])){
                $.each(typeaheadConfig['additionalParams'], function(name,value){
                    var addtlParam = "";
                    var valToSet = value.split('::')[1]
                    if(value.split('::')[0].toLowerCase() === 'string'){
                        addtlParam = '&values[' + name + ']=' + valToSet;
                    } else if(value.split('::')[0].toLowerCase() === 'field') {
                        addtlParam = '&values[' + name + ']=' + typeaheadForm.select('field['+ valToSet +']').value();
                    }
                    typeaheadConfig['bridgeUrl'] += addtlParam
                })
            }

            // Stop processing if no fields or bridgedresource have been defined 
            if( Object.keys(typeaheadConfig['fieldsToSet']).length < 1 || _.isEmpty(typeaheadConfig['bridgedResource']) 
                || _.isEmpty(typeaheadConfig['bridgeUrl']) || _.isEmpty(typeaheadConfig['attrToSet']) ) {
                console.log("Typeahead Search Misconfigured");
                return false;
            }

            // Manipulate DOM to prepare for Typeahead Searching
            $(input).wrap($('<div class="input-group"/>'));
            $(input).closest('.input-group').prepend($('<span class="input-group-addon" id="basic-addon1"><i class="fa ' + typeaheadConfig['faClass'] + '" aria-hidden="true"></i></span>'));
            $(input).attr('placeholder', typeaheadConfig['placeholder'] )
            $(input).attr('data-provide', 'typeahead').addClass('typeahead');

            // BLOODHOUND Search
            var bridgeSearch = new Bloodhound({
                datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
                queryTokenizer: Bloodhound.tokenizers.whitespace,
                remote: {
                    url: typeaheadConfig['bridgeUrl'],
                    wildcard: '%QUERY',
                    filter: function(data){
                        var dataArrayObjects = _.map(data.records.records, function(record){
                           return _.object(data.records.fields, record);
                        });
                        if (_.isEmpty(typeaheadConfig['userIdAttribute'])){
                            return dataArrayObjects;
                        }
                        else {
                            return $.grep(dataArrayObjects, function(data){
                                return data[typeaheadConfig['userIdAttribute']] !== K('identity').username;
                            });
                        }
                    }
                }
            }); // End Bloodhound Search

            // Initialize typeahead search
            $(input).typeahead(
                {
                    hint: true,
                    highlight: true,
                    minLength: typeaheadConfig['minLength'],
                },
                {
                    name: 'typeahead-search',
                    limit: 100,
                    display: typeaheadConfig['attrToSet'],
                    source: bridgeSearch,
                    templates: {
                        empty: [
                            '<div class="empty-message text-center">',
                            typeaheadConfig['emptyMessage'],'<br>',
                            '</div>',
                                ].join('\n'),
                        suggestion: function(data) {
                            suggestion = typeaheadConfig.suggestionHtml(data, typeaheadConfig)
                            return suggestion;
                        }
                    }
                }
            );
            
            // Typeahead Change and Select Events
            $(input).bind('typeahead:select', function(ev, suggestion) {
                // Render the Callback Sepecified in the Configuration
                typeaheadConfig.selectedCallback(suggestion, typeaheadConfig)
            });
            $(input).bind('typeahead:change', function(ev) {
                // Change Event on Typeahead goes here
            });
            // Prevent Submitting of form when hitting enter
            $(input).keydown(function(event){
                if(event.keyCode == 13) {
                  event.preventDefault();
                  return false;
                }
            });
        });
    }// End Typeahead search function
})(jQuery, _, moment);


// CONFIGURATION Object
typeaheadConfigurations = {
    defaultConfiguration:{
        faClass: 'fa-cog',  // Font awesom icon to append to typeahead search and results
        placeholder: 'Start typing to begin your search...',  // Placholder text to put into the search field
        emptyMessage: 'No results found', // Message to display if no results are found
        userIdAttribute : null, // If filtering results to not include logged in user (for person searching) bridge attribute for the user's Id
        queryField:  null, // Name field the Bridged Resource is expecting to be passed as a parameter - Defaults to the typeahead search field
        additionalParams: null, // JS Object with name value pairs of additinal parameters to be provided to the bridge 
                                // The values should be prefixed with STRING:: or FIELD:: depending on if you are passing a 
                                // hard coded string, or want the system to get a Field's Value)  (e.g {"Bridge Param 1":"STRING::XYZ","Bridge Param 2":"FIELD::FieldName"} )
        minLength: 3, // Minium Length to begin search
        bridgedResource: null, // Name of Bridged Resource to Use - must match a valid bridge resource on the current or shared-resource form
        bridgeLocation: null, // If the search uses a shared-resource form specify it's slug - Defaults to current form
        attrsToShow: null, // Comma separated List of Bridge Attributes to Show in Typeahead Search dropdown. (e.g. Login Id,Name)
        attrToSet: null, // Name of Bridge Attribute to Set in Typeahead Search Field
        fieldsToSet: null, // JS Object with name value pairs of Fields on Form to Bridge Attribute (e.g. {"Login Id Field":"Login Id","Name Field"="Name"})
        suggestionHtml: function(data, config) {    // Data is the Data Records Returned from the Bridge Call, Config is the typeaheadConfiguration Object
            var suggestionDetails = $('<div class="tt-details"/>');
            $.each(config['attrsToShow'],function(i,attr){
                $(suggestionDetails).append('<div class="tt-attribute col-sm-6">' + data[attr] + '</div>')
            })
            var suggestion = $('<div class="tt-suggestion"/>').append(
                                $('<i class="fa ' + config['faClass'] + ' fa-3x pull-left" aria-hidden="true"></i>'),
                                $(suggestionDetails)
                             );
            return suggestion;
        },
        selectedCallback: function(data, config) {  // Data is the row that was selected, all attributes returned from the bridge are available
            // Loop over the Fields to Set and Set them
            $.each( config['fieldsToSet'], function( key, value ) {
                config['typeaheadForm'].select('field[' + key + ']').value(data[value]);
                // Fire change event on field that was set
                $(config['typeaheadForm'].select('field[' + key + ']').element()).change();
            });
        }
    },
    // Example for Person Searching
    personConfiguration:{
        queryField: 'Name',
        faClass: 'fa-user',
        bridgeLocation: 'shared-resources',
        attrsToShow: ['Full Name', 'Email', 'Telephone Number'],
        bridgedResource: 'People - By Name',
        attrToSet: 'Full Name',
        fieldsToSet: {
            "Requested For":"Id",
            "Requested For Displayed Name":"Full Name"
        }
    },
    // Used by The update ram on existing server (example service)
    searchForRam:{
        faClass: 'fa-server',
        placeholder: 'Start typing to begin your search...',
        emptyMessage: 'No servers by that name found',
        queryField:  'Host Name',
        additionalParams: {"Class":"STRING::BMC_COMPUTERSYSTEM","DataSetId":"STRING::BMC:Asset"},
        minLength: 2,
        bridgedResource: 'BMC Computer System',
        bridgeLocation: null,
        attrsToShow: ['CI Name', 'Manufacturer', 'Product'],
        attrToSet: 'CI Name',
        fieldsToSet: {
            "Host Name":"CI Name",
            "Reconciliation Identity":"ReconciliationId"
        },
        selectedCallback: function(data, config) {  // Data is the row that was selected, all attributes returned from the bridge are available
            // Loop over the Fields to Set and Set them
            $.each( config['fieldsToSet'], function( key, value ) {
                config['typeaheadForm'].select('field[' + key + ']').value(data[value]);
                // Fire change event on field that was set
                $(config['typeaheadForm'].select('field[' + key + ']').element()).change();
            });
        }
    }
};
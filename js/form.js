// Initialize Bootstrappy field overrides.
bundle.config.fields = {
    text: function(field, triggerFn) {
        $(field.wrapper()).addClass('form-group');
        $(field.wrapper()).find('label').addClass('control-label').removeClass(function (index, css) {
            return (css.match (/(^|\s)col-\S+/g) || []).join(' ');
        });
        $(field.element()).addClass('form-control').removeClass(function (index, css) {
            return (css.match (/(^|\s)col-\S+/g) || []).join(' ');
        });
        $(field.element()).on('change', triggerFn);
    },
    // datetime: function(field, triggerFn) {
    //     $(field.wrapper()).addClass('form-group');
    //     $(field.wrapper()).find('label').addClass('control-label');
    //     $(field.element()).addClass('form-control');
    //     $(field.element()).on('change', triggerFn);
    // },
    dropdown: function(field, triggerFn) {
        $(field.wrapper()).addClass('form-group');
        $(field.wrapper()).find('label').addClass('control-label').removeClass(function (index, css) {
            return (css.match (/(^|\s)col-\S+/g) || []).join(' ');
        });
        $(field.element()).addClass('form-control').removeClass(function (index, css) {
            return (css.match (/(^|\s)col-\S+/g) || []).join(' ');
        });
        $(field.element()).on('change', triggerFn);
    },
    checkbox: function(field, triggerFn) {
        $(field.wrapper()).removeClass('checkbox');
        $(field.wrapper()).find('label').first().addClass('control-label').removeClass(function (index, css) {
            return (css.match (/(^|\s)col-\S+/g) || []).join(' ');
        });
        $(field.wrapper()).find('label').first().removeClass('field-label');
        $(field.wrapper()).children().not(':first-child').addClass('checkbox');
        $(field.wrapper()).children().not(':first-child').attr('style', 'margin-left:20px;');
        $(field.element()).on('change', triggerFn);
    },
    radio: function(field, triggerFn) {
        $(field.wrapper()).removeClass('radio');
        $(field.wrapper()).find('label').first().addClass('control-label').removeClass(function (index, css) {
            return (css.match (/(^|\s)col-\S+/g) || []).join(' ');
        });
        $(field.wrapper()).find('label').first().removeClass('field-label');
        $(field.wrapper()).children().not(':first-child').addClass('radio');
        $(field.wrapper()).children().not(':first-child').attr('style', 'margin-left:20px;');
        $(field.element()).on('change', triggerFn);
    }
};
bundle.config.ready = function(form) {
    // Manipulate Default Buttons on Forms
    $(form.element()).find('[data-element-type="button"]').addClass('btn btn-default');
    $(form.element()).find('[data-button-type="submit-page"]').addClass('pull-right');
    $(form.element()).find('[data-button-type="save"], [data-button-type="previous-page"]').css('margin-right','15px');

    // Loop over each Form Section and Add Appropriate Classes
    $(form.element()).find('section').each(function(){
        // If the Section ONLY contains form buttons, add the box-footer class 
        if( $(this).find('button[data-button-type]').length > 0 && $(this).children().length === $(this).find('button[data-button-type]').length ){
            // Check to make sure it wasn't already added to the section via the builder
            if( !$(this).hasClass('box-footer') ){
                $(this).children().not('h1').wrapAll('<div class="box-footer"></div>');
            }
            // Wrap all other Sections with Box-Body. If the sections have a visible header, wrap it with box-header
        } else if ( !$(this).is('[class^="col-"]') && $(this).children('h1').length > 0) {
            $(this).children().not('h1').wrapAll('<div class="box-body"></div>');
            $(this).children('h1').replaceWith('<div class="box-header with-border"><h3 class="box-title">' + $(this).children('h1').text() + '</h3></div>');
        }
    });

    // Add box-body to forms with no sections
    if( $(form.element()).find('section').length === 0 ){
        $(form.element()).children().wrapAll('<div class="box-body"></div>');
    }

    // Wrap all additional questions that aren't in a section with box body div
    $(form.element()).children('.form-group').not('section').wrapAll('<div class="box-body"></div>');

    // Work around for Date-Time fields that can't be manipulated in bundle.config.fields without overriding
    // default datepicker behavior
    $(form.element()).find('div[data-element-type="wrapper"]:has( >label )').children('label').removeClass('col-sm-12 col-sm-6 col-sm-4');
    $(form.element()).find('div[data-element-type="wrapper"]:has( >label )').children('input').addClass('form-control');

    // Initialize typeahead searching on Kinetic Forms if the library exists
    if(typeAheadSearch !== undefined) { typeAheadSearch(form); }
    if(subformTables !== undefined) { subformTables.initialize(form); }

    // Help Text Setup (Popover / Bootstrap)
    $(form.element()).find('div[help-text]').each(function(){
        var hlptxt = $(this).attr('help-text')
        $(this).children('label').first().append("&nbsp;&nbsp;", $("<i class='fa fa-info-circle fa-1x' aria-hidden='true' tabindex='0' data-toggle='popover' data-trigger='hover' title='Help' role='button'></i>").attr('data-content', hlptxt));
    });
    $(form.element()).find('[data-toggle="popover"]').popover()
};
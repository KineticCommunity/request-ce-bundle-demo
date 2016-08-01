(function(){
  /* On load of the search.jsp page bring focus back to the search input and add a space to the end of the text.
   * This will allow the user to add addtional search terms to the query for a more specific search.
   */
  $(function(){
    $('#sidebar-search input:nth-child(2)').focus().val($('#sidebar-search input:nth-child(2)').val()+" ");
  });
})();
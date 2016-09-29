<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<c:set scope="request" var="openSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissions('Approval', 'Draft', 1000)}"/>
<c:set scope="request" var="closedSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissions('Approval', 'Closed',1000)}"/>

<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:variable name="head">
        <title>${text.escape(kapp.name)} Approvals</title>
    </bundle:variable>
    <section class="content-header">
        <span class="small-box-custom bg-green">
            <h1><i class="fa fa-thumbs-o-up"></i> My Approvals</h1>
        </span>
        <ol class="breadcrumb">
            <li>
                <a href="${bundle.kappLocation}"><i class="fa fa-home"></i> Home</a>
            </li>
            <li class="active">My Approvals</li>
        </ol>
    </section>
    <section class="content">
    <div class="nav-tabs-custom ">
        <ul class="nav nav-tabs" role="tablist">
            <li role="presentation" class="active">
                <a href="#tab_1" data-toggle="tab" role="tab" aria-expanded="false">Pending</a>
            </li>
            <li role="presentation">
                <a href="#tab_2" data-toggle="tab" role="tab" aria-expanded="false">Closed</a>
            </li>
        </ul>
        <i id="spinner" class="fa fa-cog fa-spin fa-3x" style="text-align:center;width:100%;margin-top:15%"></i> 
        <div class="tab-content">
            <div role="tabpanel" class="tab-pane active" id="tab_1">
                <c:set scope="request" var="tableId" value="pendingTable" />
                <c:import url="${bundle.path}/partials/dateRangeDropdown.jsp" charEncoding="UTF-8"/>
                <table id="${tableId}" class="table table-hover" width="100%">  
                    <%--This Table is build using DataTables, the width is requiered because of the way dataTables renders.
                        The code for this table can be found in catlog.js renderTable() with the table property that matches the table id.--%>                  
                </table>
            </div><!-- End Tab 1 -->
            <div role="tabpanel" class="tab-pane" id="tab_2">
                <c:set scope="request" var="tableId" value="closedTable" />
                <c:import url="${bundle.path}/partials/dateRangeDropdown.jsp" charEncoding="UTF-8"/>
                <table id="closedTable" class="table table-hover" width="100%">  
                    <%--This Table is build using DataTables, the width is requiered because of the way dataTables renders.
                        The code for this table can be found in catlog.js renderTable() with the table property that matches the table id.--%>                   
                </table>
            </div><!-- End Tab 2 -->
        </div>
    </div>
</bundle:layout>
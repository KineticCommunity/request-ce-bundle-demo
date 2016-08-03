<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<c:set scope="request" var="openSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissions('Service', 'Submitted',1000)}"/>
<c:set scope="request" var="closedSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissions('Service', 'Closed',1000)}"/>
<c:set scope="request" var="draftSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissions('Service', 'Draft',1000)}"/>

<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <section class="content-header">
        <span class="small-box-custom bg-aqua">
            <h1><i class="fa fa-shopping-cart"></i> My Requests</h1>
        </span>
        <ol class="breadcrumb">
            <li>
                <a href="${bundle.kappLocation}"><i class="fa fa-home"></i> Home</a>
            </li>
            <li class="active">My Requests</li>
        </ol>
    </section>
    <section class="content">
        <div class="nav-tabs-custom ">
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active">
                    <a href="#tab_1" data-toggle="tab" role="tab" aria-expanded="false">Open</a>
                </li>
                <li role="presentation">
                    <a href="#tab_2" data-toggle="tab" role="tab" aria-expanded="false">Closed</a>
                </li>
                <li role="presention">
                    <a href="#tab_3" data-toggle="tab" role="tab" aria-expanded="false">Draft</a>
                </li>
            </ul>
            <div class="tab-content"><div role="tabpanel" class="tab-pane active" id="tab_1">     
                    <table id="openTable" class="table table-hover">  
                        <thead>
                            <tr>
                                <th>Item Requested</th>
                                <th>Details</th>
                                <th>Date Submitted</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${openSubmissionsList}" var="submission">
                                <c:set var="statusColor" value="label-success"/>
                                <tr>
                                    <td>${text.escape(submission.form.name)}</td>
                                    <td>
                                        <a href="${bundle.kappLocation}?page=submission&id=${submission.id}">${text.escape(submission.label)}</a>
                                    </td>
                                    <td data-moment>${submission.createdAt}</td>
                                    <td><span class="label ${statusColor}">${submission.coreState}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div><!-- End Tab 1 -->
                <div role="tabpanel" class="tab-pane" id="tab_2">
                    <table id="closedTable" class="table table-hover datatable">  
                        <thead>
                            <tr>
                                <th>Item Requested</th>
                                <th>Details</th>
                                <th>Date Closed</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${closedSubmissionsList}" var="submission">
                                    <c:set var="statusColor" value="label-primary"/>
                                    <tr>
                                        <td>${text.escape(submission.form.name)}</td>
                                        <td>
                                            <a href="${bundle.kappLocation}?page=submission&id=${submission.id}">${text.escape(submission.label)}</a>
                                        </td>
                                        <td data-moment>${submission.closedAt}</td>
                                        <td><span class="label ${statusColor}">${submission.coreState}</span></td>
                                    </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div><!-- End Tab 2 -->
                <div role="tabpanel" class="tab-pane" id="tab_3">
                    <table id="draftTable" class="table table-hover">  
<!--                        <thead>
                            <tr>
                                <th>Item Requested</th>
                                <th>Details</th>
                                <th>Date Submitted</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${draftSubmissionsList}" var="submission">
                                <c:set var="statusColor" value="label-warning"/>
                                <tr>
                                    <td>${text.escape(submission.form.name)}</td>
                                    <td>
                                        <a href="${bundle.spaceLocation}/submissions/${submission.id}">${text.escape(submission.label)}</a>
                                    </td>
                                    <td data-moment>${submission.createdAt}</td>
                                    <td><span class="label ${statusColor}">${submission.coreState}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>-->
                    </table>
                </div><!-- End Tab 3 -->
            </div>
        </div>
    </section>
</bundle:layout>
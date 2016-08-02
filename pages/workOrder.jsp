<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<c:set scope="request" var="openSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissionsByKapp(space.getAttributeValue('QApp Slug'), 'Draft', 999)}"/>
<c:set scope="request" var="closedSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissionsByKapp(space.getAttributeValue('QApp Slug'), 'Closed',1000)}"/>

<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <section class="content-header">
        <span class="small-box-custom bg-maroon">
            <h1><i class="fa fa-tasks"></i> My Tasks</h1>
        </span>
        <ol class="breadcrumb">
            <li>
                <a href="${bundle.kappLocation}"><i class="fa fa-home"></i> Home</a>
            </li>
            <li class="active">My Tasks</li>
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
            </ul>
            <div class="tab-content"><div role="tabpanel" class="tab-pane active" id="tab_1">     
                    <table class="table table-hover datatable">  
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
                                        <a target="_blank" href="${bundle.spaceLocation}/${space.getAttributeValue('QApp Slug')}#/queue/filter/Mine/details/${submission.id}/summery">${text.escape(submission.label)}</a>
                                    </td>
                                    <td data-moment>${submission.createdAt}</td>
                                    <td><span class="label ${statusColor}">${submission.coreState}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div><!-- End Tab 1 -->
                <div role="tabpanel" class="tab-pane" id="tab_2">
                    <table class="table table-hover datatable">  
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
            </div>
        </div>
    </section>
</bundle:layout>

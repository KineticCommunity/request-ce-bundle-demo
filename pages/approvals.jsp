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
        <div class="tab-content">
            <div role="tabpanel" class="tab-pane active" id="tab_1">
                <table class="table table-hover datatable">  
                    <thead>
                        <tr>
                            <th>Item Requested</th>
                            <th>Details</th>
                            <th>Date Submitted</th>
                            <th>Decision</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${openSubmissionsList}" var="submission">
                            <c:set var="statusColor" value="label-success"/>
                            <tr>
                                <td>${text.escape(submission.form.name)}</td>
                                <td><a href="${bundle.spaceLocation}/submissions/${submission.id}">${text.escape(submission.label)}</a></td>
                                <td data-moment>${submission.createdAt}</td>
                                <c:if test="${submission.form.getField('Decision') ne null}">
                                    <c:if test="${submission.getValue('Decision') eq 'Approved'}">
                                        <c:set var="statusColor" value="label-success"/>
                                    </c:if>
                                    <c:if test="${submission.getValue('Decision') eq 'Denied'}">
                                        <c:set var="statusColor" value="label-danger"/>
                                    </c:if>
                                    <c:set var="approvalStatus" value="${submission.getValue('Decision')}"/>
                                    <c:if test="${submission.coreState eq 'Draft'}">
                                        <c:set var="approvalStatus" value="Pending Approval"/>
                                    </c:if>
                                    <td><span class="label ${statusColor}">${approvalStatus}</span></td>
                                </c:if>
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
                            <th>Date Submitted</th>
                            <th>Date Closed</th>
                            <th>Decision</th>
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
                                <td data-moment>${submission.submittedAt}</td>
                                <td data-moment>${submission.closedAt}</td>
                                <c:if test="${submission.form.getField('Decision') ne null}">
                                    <c:if test="${submission.getValue('Decision') eq 'Approved'}">
                                        <c:set var="statusColor" value="label-success"/>
                                    </c:if>
                                    <c:if test="${submission.getValue('Decision') eq 'Denied'}">
                                        <c:set var="statusColor" value="label-danger"/>
                                    </c:if>
                                    <c:set var="approvalStatus" value="${submission.getValue('Decision')}"/>
                                    <c:if test="${submission.coreState eq 'Draft'}">
                                        <c:set var="approvalStatus" value="Pending Approval"/>
                                    </c:if>
                                    <td><span class="label ${statusColor}">${approvalStatus}</span></td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div><!-- End Tab 2 -->
        </div>
    </div>
</bundle:layout>
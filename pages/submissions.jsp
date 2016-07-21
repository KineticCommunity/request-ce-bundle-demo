<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<c:choose>
    <c:when test="${param['type'] eq 'request'}">
        <c:set var="status" value="${Text.defaultIfBlank(param['status'],'Submitted')}" />
    </c:when>
    <c:otherwise>
        <c:set var="status" value="${Text.defaultIfBlank(param['status'],'Submitted')}" />
    </c:otherwise>
</c:choose>
<c:set var="paramtype" value="${Text.defaultIfBlank(param['type'],'request')}" />
<c:choose>
    <c:when test="${paramtype eq 'approval'}">
        <c:set scope="request" var="openSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissions('Approval', 'Draft', 1000)}"/>
        <c:set scope="request" var="closedSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissions('Approval', 'Closed',1000)}"/>
        <c:set scope="request" var="type" value="Approvals"/>
        <c:set scope="page" var="typeVariables" value="${['bg-green','fa-thumbs-o-up']}"/>
    </c:when>
    <c:when test="${paramtype eq 'work-order'}">
        <c:if test="${space.hasAttribute('QApp Slug')}">
        <c:set scope="request" var="openSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissionsByKapp(space.getAttributeValue('QApp Slug'), 'Draft', 999)}"/>
        <c:set scope="request" var="closedSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissionsByKapp(space.getAttributeValue('QApp Slug'), 'Closed',1000)}"/>
        </c:if>
        <c:set scope="request" var="type" value="Tasks"/>
        <c:set scope="page" var="typeVariables" value="${['bg-maroon','fa-tasks']}"/>
    </c:when>
    <c:otherwise>
        <c:set scope="request" var="openSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissions('Service', 'Submitted',1000)}"/>
        <c:set scope="request" var="closedSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissions('Service', 'Closed',1000)}"/>
        <c:set scope="request" var="draftSubmissionsList" value="${SubmissionHelper.retrieveRecentSubmissions('Service', 'Draft',1000)}"/>
        <c:set scope="request" var="type" value="Requests"/>
        <c:set scope="page" var="typeVariables" value="${['bg-aqua','fa-shopping-cart']}"/>
    </c:otherwise>
</c:choose>
<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:variable name="head">
        <title>${text.escape(space.name)} Submissions</title>
    </bundle:variable>
    <section class="content-header">
        <span class="small-box-custom ${typeVariables[0]}">
            <h1><i class="fa ${typeVariables[1]}"></i> My ${type}</h1>
        </span>
        <ol class="breadcrumb">
            <li><a href="${bundle.kappLocation}">
                <i class="fa fa-home"></i> 
                Home</a>
            </li>
            <li class="active">My ${type}</li>
        </ol>
    </section>

    <section class="content">
        <div class="nav-tabs-custom ">
            <ul class="nav nav-tabs">
                <li <c:if test="${status eq 'Submitted'}">class="active"</c:if>>
                    <a href="#tab_1" data-toggle="tab" aria-expanded="false">
                        <c:choose>
                            <c:when test="${type eq 'Approvals'}">
                                Pending
                            </c:when>
                            <c:otherwise>
                                Open
                            </c:otherwise>
                        </c:choose>
                    </a>
                </li>
                <li <c:if test="${status eq 'Closed'}">class="active"</c:if>>
                    <a href="#tab_2" data-toggle="tab" aria-expanded="false">Closed</a>
                </li>
                <c:if test="${paramtype != 'work-order' && type != 'Approvals'}">
                    <li <c:if test="${status eq 'Draft'}">class="active"</c:if>>
                        <a href="#tab_3" data-toggle="tab" aria-expanded="false">Draft</a>
                    </li>
                </c:if>
            </ul>

            <div class="tab-content">
                <div id="tab_1" class="tab-pane <c:if test="${status eq 'Submitted'}">active</c:if>">
                    <table class="table table-hover datatable">  
                        <thead>
                            <tr>
                                <th>Item Requested</th>
                                <th>Details</th>
                                <th>Date Submitted</th>
                                <c:if test="${type eq 'Approvals'}">
                                    <th>Decision</th>
                                </c:if>
                                <c:if test="${type eq 'Requests' || type eq 'Tasks'}">
                                    <th>Status</th>
                                </c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${openSubmissionsList}" var="submission">
                                <c:set var="statusColor" value="label-success"/>
                                <tr>
                                    <td>${text.escape(submission.form.name)}</td>
                                    <c:choose>
                                        <c:when test="${type eq 'Requests'}">
                                            <td>
                                                <a href="${bundle.kappLocation}?page=submission&id=${submission.id}">${text.escape(submission.label)}</a>
                                            </td>
                                        </c:when>
                                        <c:when test="${type eq 'Approvals'}">
                                            <td>
                                                <a href="${bundle.spaceLocation}/submissions/${submission.id}">${text.escape(submission.label)}</a>
                                            </td>
                                        </c:when>
                                        <c:otherwise>
                                            <td>
                                                <a target="_blank" href="${bundle.spaceLocation}/${space.getAttributeValue('QApp Slug')}#/queue/filter/Mine/details/${submission.id}/summery">${text.escape(submission.label)}</a>
                                            </td>
                                        </c:otherwise>
                                    </c:choose>
                                    <td data-moment>${submission.createdAt}</td>
                                    <c:choose>
                                        <c:when test="${type eq 'Approvals' && submission.form.getField('Decision') ne null}">
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
                                        </c:when>
                                        <c:when test="${type eq 'Requests' || type eq 'Tasks'}">
                                            <td><span class="label ${statusColor}">${submission.coreState}</span></td>
                                        </c:when>
                                        <c:otherwise>
                                            <td><span class="label">${submission.coreState}</span></td>
                                        </c:otherwise>
                                    </c:choose>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div><!-- End Tab 1 -->
                <div id="tab_2" class="tab-pane <c:if test="${status eq 'Closed'}">active</c:if>">
                    <table class="table table-hover datatable">  
                        <thead>
                            <tr>
                                <th>Item Requested</th>
                                <th>Details</th>
                                <c:if test="${type ne 'Approvals'}">
                                    <th>Date Submitted</th>
                                </c:if>
                                <th>Date Closed</th>
                                <c:if test="${type eq 'Approvals'}">
                                    <th>Decision</th>
                                </c:if>
                                <c:if test="${type eq 'Requests' || type eq 'Tasks'}">
                                    <th>Status</th>
                                </c:if>
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
                                        <c:if test="${type ne 'Approvals'}">
                                            <td data-moment>${submission.submittedAt}</td>
                                        </c:if>
                                        <td data-moment>${submission.closedAt}</td>
                                        <c:choose>
                                            <c:when test="${type eq 'Approvals' && submission.form.getField('Decision') ne null}">
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
                                            </c:when>
                                            <c:when test="${type eq 'Requests' || type eq 'Tasks'}">
                                                <td><span class="label ${statusColor}">${submission.coreState}</span></td>
                                            </c:when>
                                            <c:otherwise>
                                                <td><span class="label">${submission.coreState}</span></td>
                                            </c:otherwise>
                                        </c:choose>
                                    </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div><!-- End Tab 2 -->
                <div id="tab_3" class="tab-pane <c:if test="${status eq 'Draft'}">active</c:if>">
                    <table class="table table-hover datatable">  
                        <thead>
                            <tr>
                                <th>Item Requested</th>
                                <th>Details</th>
                                <th>Date Submitted</th>
                                <c:if test="${type eq 'Approvals'}">
                                    <th>Decision</th>
                                </c:if>
                                <c:if test="${type eq 'Requests' || type eq 'Tasks'}">
                                    <th>Status</th>
                                </c:if>
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
                                    <c:choose>
                                        <c:when test="${type eq 'Approvals' && submission.form.getField('Decision') ne null}">
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
                                        </c:when>
                                        <c:when test="${type eq 'Requests' || type eq 'Tasks'}">
                                            <td><span class="label ${statusColor}">${submission.coreState}</span></td>
                                        </c:when>
                                        <c:otherwise>
                                            <td><span class="label">${submission.coreState}</span></td>
                                        </c:otherwise>
                                    </c:choose>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div><!-- End Tab 3 -->
            </div>
        </div>
    </section>
</bundle:layout>
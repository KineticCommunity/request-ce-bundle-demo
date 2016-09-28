<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<c:catch var="submissionException">
    <c:set var="submission" value="${Submissions.retrieve(param.id)}" scope="page"/>
</c:catch>
<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:variable name="head">
        <title>${text.escape(submission.form.name)}</title>
    </bundle:variable>
    <c:choose>
        <c:when test="${submissionException != null}">
            Error
        </c:when>
        <c:otherwise>
            <section class="content-header">
                <h1>
                    ${submission.label}
                    <small>Submitted On: <span data-moment> ${time.format(submission.submittedAt)}</span></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a class="${bundle.kappLocation}">
                        <i class="fa fa-home"></i> 
                        Home</a>
                    </li>
                    <li class="active">${submission.label}</li>
                </ol>
            </section>
            <section class="content">
                <div class="row">
                    <div class="col-md-4 col-xs-12 ">
                        <div class="submission-meta">
                            <h2>${submission.form.name}</h2>
                            <dl>
                                <dt>Label:</dt>
                                <dd>${submission.label}</dd>
                                <%--If the currently logged in user is not the one who made the submittion then display 
                                    the username or displayname of the submitter.--%> 
                                <c:if test="${submission.submittedBy != identity.username}">
                                    <dt>Submitted By:</dt>
                                    <c:choose>
                                        <c:when test="${not empty space.getUser(submission.submittedBy).displayName}">
                                            <dd>${space.getUser(submission.submittedBy).displayName}</dd>
                                        </c:when>
                                        <c:otherwise>
                                            <dd>${submission.createdBy}</dd>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <dt>Date Submitted:</dt>
                                <dd data-moment>${time.format(submission.submittedAt)}</dd>
                                <c:if test="${submission.type.name != 'Approval' && submission.closedAt != null}">
                                    <dt>Date Closed:</dt>
                                    <dd data-moment>${time.format(submission.closedAt)}</dd>
                                </c:if>
                                <dt>Status:</dt>
                                <dd>${submission.coreState}</dd>
                            </dl>
                            <p>${submission.form.description}</p>
                            <div class="box-body">
                                <a class="btn btn-info" href="${bundle.spaceLocation}/submissions/${submission.id}?review">Review Submitted Form</a>
                                <a class="btn btn-primary" href="${bundle.spaceLocation}/${kapp.slug}/${submission.form.slug}">Request Again</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8 col-xs-12 ">
                        <div id="submissionActivity" class="box-body">
                            <c:import url="partials/taskActivity.jsp" charEncoding="UTF-8"></c:import>
                        </div>
                    </div>
                </div>
            </section>
        </c:otherwise>
    </c:choose>
</bundle:layout>

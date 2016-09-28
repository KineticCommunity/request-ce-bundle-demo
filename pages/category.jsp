<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <c:set scope="request" var="category" value="${CategoryHelper.getCategory(param.category,kapp)}" />
    <bundle:variable name="head">
        <title>${BundleHelper.getTitle()} - ${text.escape(category.name)}</title>
    </bundle:variable>
    <bundle:scriptpack>
        <bundle:script src="${bundle.location}/js/formCard.js" />
        <bundle:script src="${bundle.location}/libraries/starrr/starrr.js" />
    </bundle:scriptpack>


    <section class="content-header">
        <h1>
            ${text.escape(category.name)}
        </h1>
        <ol class="breadcrumb">
            <li><a href="${bundle.kappLocation}">
                <i class="fa fa-home"></i> 
                Home</a>
            </li>
        <c:forEach var="parent" items="${category.getTrail()}">
            <li><a href="${bundle.spaceLocation}/${kapp.slug}?page=category&category=${parent.slug}">${text.escape(parent.name)}</a></li>
        </c:forEach>
        </ol>
    </section>


    <section class="content">
        <div class="row">
            <div class="col-xs-12 col-sm-8">
            <c:forEach var="form" items="${category.forms}">
                <c:set var="form" scope="request" value="${form}"/>
                <c:import url="${bundle.path}/partials/formCard.jsp" charEncoding="UTF-8"/>
            </c:forEach>
            </div>
            <c:set var="categorySubmissions" value="${SubmissionHelper.categorySubmissions(category.slug)}" />
            <div class="col-xs-12 col-sm-4">
                <c:if test="${not empty categorySubmissions}">
                    <div class="box box-solid">
                        <div class="box-header with-border">
                            <h3 class="box-title">My ${text.escape(category.name)} Tickets</h3>
                        </div>
                        <div class="box-body">
                           <ul class="products-list product-list-in-box">
                                <c:forEach var="submission" begin="0" end="5" items="${categorySubmissions}">
                                    <li class="item">
                                        <c:choose>
                                            <c:when test="${submission.coreState eq 'Draft'}">
                                                <h4><a href="${bundle.spaceLocation}/submissions/${submission.id}">${text.escape(submission.form.name)}</a></h4>
                                            </c:when>
                                            <c:otherwise>
                                                <h4><a href="${bundle.kappLocation}?page=submission&id=${submission.id}">${text.escape(submission.form.name)}</a></h4>
                                            </c:otherwise>
                                        </c:choose>
                                        <div><label>Request Date:</label> <span data-moment>${submission.submittedAt}</span></div>
                                        <div><label>Status:</label> ${submission.coreState}</div>
                                    </li><!-- /.item -->
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </section>
</bundle:layout>
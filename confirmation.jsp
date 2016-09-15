<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="bundle/initialization.jspf" %>
<bundle:layout page="layouts/form.jsp">
    <bundle:variable name="head">
        <title>${text.escape(form.name)}</title>
    </bundle:variable>
    <section class="content-header">
        <c:if test="${not empty form.getAttributeValue('Image')}">
            <img class="formlogo pull-left" src="${bundle.location}/images/forms/${form.getAttributeValue('Image')}"/>
        </c:if>
        <h1>
            <c:if test="${form.getAttributeValue('Icon')}">
                <i class="fa ${form.getAttributeValue('Icon')}"/>
            </c:if>
            ${text.escape(form.name)}
        </h1>
        <c:if test="${param.review != null && pages.size() > 1}">
            <ol class="breadcrumb">
                <li><a href="${bundle.kappLocation}">
                    <i class="fa fa-home"></i> 
                    Home</a>
                </li>
                <li class="active">${text.escape(form.name)}</li>
            </ol>
        </c:if>
    </section>
    <section class="content page " data-page="${page.name}">
        <c:set var="colClass" value="col-md-12"/>
        <div class="${colClass}">
            <div class="box box-primary">
                <div class="box-body">
                    <c:choose>
                        <c:when test='${empty submission.currentPage}'>
                            <h4>Thank you for your submission</h4>
                            <p><a href="${bundle.kappLocation}/${form.slug}">Submit again</a></p>
                            <p><a href="${bundle.kappLocation}">Return to the catalog</a></p>
                        </c:when>
                        <c:otherwise>
                             <app:bodyContent/>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </section>
</bundle:layout>

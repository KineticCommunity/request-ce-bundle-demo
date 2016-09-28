<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:scriptpack>
        <bundle:script src="${bundle.location}/js/formCard.js" />
        <bundle:script src="${bundle.location}/js/search.js" />
        <bundle:script src="${bundle.location}/libraries/starrr/starrr.js" />
    </bundle:scriptpack>

    <bundle:variable name="head">
        <title>${text.escape(space.name)} Search</title>
    </bundle:variable>

    <section class="content-header">
        <h1>
            <%--Use a c:out JSTL tag to sanitize the output and prevent XXS attacks--%>
            ${kappIter.name} Search Results <c:if test="${text.isNotBlank(param['q'])}">for '<c:out value="${param['q']}"/>'</c:if>
        </h1>
        <ol class="breadcrumb">
            <li><a href="${bundle.kappLocation}">
                <i class="fa fa-search"></i> 
                Home</a>
            </li>
            <li class="active">Search</li>
        </ol>
    </section>

    <section class="content">
        <div class="row">
            <div class="col-md-8">
                <c:choose>
                    <c:when test="${text.isNotBlank(param['q'])}">
                        <c:catch var ="searchException">
                           <c:set var="searchResults" scope="request" value="${CatalogSearchHelper.search(kapp.forms, param['q'])}" />
                        </c:catch>
                        <c:choose>
                            <c:when test="${searchException ne null}">
                                <div class="card">
                                    <div class="card-content alert alert-danger">
                                        <h5>
                                            <span class="fa fa-exclamation-triangle"></span>
                                            <span>Error: ${searchException.cause}</span>
                                        </h5>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="result" items="${searchResults}">
                                    <c:if test="${result.form.typeName eq 'Service'}">
                                        <c:set var="form" scope="request" value="${result.form}"/>
                                        <c:import url="${bundle.path}/partials/formCard.jsp" charEncoding="UTF-8"/>
                                    </c:if>
                                </c:forEach>                
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <div class="card">
                            <div class="card-content alert alert-danger">
                                <h5>
                                    <span class="fa fa-exclamation-triangle"></span>
                                    <span>Search term not found.</span>
                                </h5>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="col-md-4">
                <c:import url="${bundle.path}/partials/promotedRequests.jsp" charEncoding="UTF-8"/>
            </div>
        </div>
    </section>
</bundle:layout>